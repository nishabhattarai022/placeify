package tech.graaf.franz.ar_flutter_plugin_plus

import android.app.Activity
import android.app.Application
import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.SystemClock
import android.opengl.Matrix
import android.util.Log
import android.view.MotionEvent
import android.view.TextureView
import android.view.View
import android.view.ViewConfiguration
import android.widget.Toast
import android.widget.FrameLayout
import com.google.ar.core.*
import com.google.ar.core.exceptions.*
import tech.graaf.franz.ar_flutter_plugin_plus.Serialization.poseFromTransformMatrix
import tech.graaf.franz.ar_flutter_plugin_plus.Serialization.serializeAnchor
import tech.graaf.franz.ar_flutter_plugin_plus.Serialization.serializeHitResult
import tech.graaf.franz.ar_flutter_plugin_plus.Serialization.serializePose
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.io.ByteArrayOutputStream
import java.io.ByteArrayInputStream
import java.io.IOException
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.util.EnumSet
import java.util.concurrent.CompletableFuture
import java.util.concurrent.Executors
import java.util.regex.Pattern

import android.R
import android.view.ViewGroup
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner














internal class AndroidARView(
        val activity: Activity,
        context: Context,
        messenger: BinaryMessenger,
        id: Int,
        creationParams: Map<String?, Any?>?
) : PlatformView {
    companion object {
        private val cachedImageDatabaseBytes: MutableMap<String, ByteArray> = mutableMapOf()
    }
    private val TAG = "AndroidARView"

    private lateinit var viewContext: Context
    private lateinit var rootView: FrameLayout
    private lateinit var textureView: TextureView
    private lateinit var filamentRenderer: FilamentArRenderer

    private val sessionManagerChannel = MethodChannel(messenger, "arsession_$id")
    private val objectManagerChannel = MethodChannel(messenger, "arobjects_$id")
    private val anchorManagerChannel = MethodChannel(messenger, "aranchors_$id")

    private var session: Session? = null
    private var currentFrame: Frame? = null

    private var showFeaturePoints = false
    private var showPlanes = false
    private var showWorldOrigin = false
    private var showAnimatedGuide = false
    private var animatedGuide: View? = null

    private var isARInitialized = false
    private var mUserRequestedInstall = true

    private val tapLock = Any()
    private var queuedTap: MotionEvent? = null

    private var activeGestureNodeName: String? = null
    private var isPanning = false
    private var isRotating = false
    private var panPending = false
    private var panStartX = 0f
    private var panStartY = 0f
    private var lastRotationAngle = 0f
    private var hasReportedPlaneDetection = false
    private var planeDetectionFrameSkip = 0
    private var ancillaryFrameSkip = 0
    private var imageTrackingEnabled = false
    private val touchSlop by lazy { ViewConfiguration.get(viewContext).scaledTouchSlop }

    private var lastTrackingState: TrackingState? = null
    private var lastTrackingFailureReason: TrackingFailureReason? = null
    private var lastTapX: Float? = null
    private var lastTapY: Float? = null
    private var lastTapAtMs: Long = 0L

    private var worldOriginAnchor: Anchor? = null
    private var lastWorldOriginMatrix: FloatArray? = null
    private var stableTrackingFrames = 0
    private var nonTrackingFrames = 0
    private val requiredStableTrackingFrames = 10
    private val activeAugmentedImages: MutableSet<String> = mutableSetOf()
    private val lastAugmentedImageUpdateMs: MutableMap<String, Long> = mutableMapOf()
    private var continuousImageTracking = false
    private var imageTrackingUpdateIntervalMs: Long = 100

    private val nonTrackingResetThreshold = 30
    private val modelIoExecutor = Executors.newFixedThreadPool(2)
    private val imageTrackingExecutor = Executors.newSingleThreadExecutor()
    private var androidModelScaleFactor: Float = 0.33f
    // Setting defaults
    private var enableRotation = false
    private var enablePans = false

    // Logical scene state (ARCore-only, no rendering)
    private val nodesByName: MutableMap<String, SimpleNode> = mutableMapOf()
    private val anchorsByName: MutableMap<String, Anchor> = mutableMapOf()
    private val anchorChildren: MutableMap<String, MutableList<String>> = mutableMapOf()
    private val anchorTransformsByName: MutableMap<String, FloatArray> = mutableMapOf()
    /// Cached world matrices — recomputed only when a node transform changes.
    private val cachedWorldMatrices: MutableMap<String, FloatArray> = mutableMapOf()
    private val dirtyTransformNodes: MutableSet<String> = mutableSetOf()
    // Cloud anchor handler
    private lateinit var cloudAnchorHandler: CloudAnchorHandler

    private var onFrameUpdateListener: ((Long) -> Unit)? = null
    private var isSessionResumed = false
    private lateinit var activityLifecycleCallbacks: Application.ActivityLifecycleCallbacks

    // Method channel handlers
    private val onSessionMethodCall =
            object : MethodChannel.MethodCallHandler {
                override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                    when (call.method) {
                        "init" -> {
                            initializeARView(call, result)
                        }
                        "setLightIntensityMultiplier" -> {
                            val multiplier = call.argument<Number>("multiplier")?.toFloat() ?: 1.0f
                            filamentRenderer.setLightIntensityMultiplier(multiplier)
                            result.success(null)
                        }
                        "setShowPlanes" -> {
                            showPlanes = call.argument<Boolean>("show") == true
                            result.success(null)
                        }
                        "hitTestScreenCenter" -> {
                            val frame = currentFrame
                            val width = textureView.width
                            val height = textureView.height
                            if (frame == null || width <= 0 || height <= 0) {
                                result.success(ArrayList<HashMap<String, Any>>())
                                return
                            }
                            result.success(
                                serializePlaneAndPointHits(
                                    frame.hitTest(width / 2f, height / 2f)
                                )
                            )
                        }
                        "updateImageTrackingSettings" -> {
                            val argTrackingImagePaths: List<String>? = call.argument<List<String>>("trackingImagePaths")
                            val argContinuousImageTracking: Boolean? = call.argument<Boolean>("continuousImageTracking")
                            val argImageTrackingUpdateIntervalMs: Number? = call.argument<Number>("imageTrackingUpdateIntervalMs")

                            applyImageTrackingSettings(
                                imagePaths = argTrackingImagePaths,
                                continuous = argContinuousImageTracking,
                                intervalMs = argImageTrackingUpdateIntervalMs
                            )
                            result.success(null)
                        }
                        "precompileImageTrackingDatabase" -> {
                            val argTrackingImagePaths: List<String>? = call.argument<List<String>>("trackingImagePaths")
                            val imagePaths = argTrackingImagePaths ?: emptyList()
                            val session = session
                            if (session == null) {
                                result.error("Error", "Session not initialized", null)
                                return
                            }

                            imageTrackingExecutor.execute {
                                var success = true
                                try {
                                    val cacheKey = imageCacheKey(imagePaths)
                                    if (!cachedImageDatabaseBytes.containsKey(cacheKey)) {
                                        val (imageDatabase, buildSuccess) = buildImageDatabase(session, imagePaths)
                                        success = buildSuccess
                                        val bytes = serializeImageDatabase(imageDatabase)
                                        cachedImageDatabaseBytes[cacheKey] = bytes
                                    }
                                } catch (e: Exception) {
                                    success = false
                                    Log.e(TAG, "Error precompiling image database: ${e.message}")
                                }

                                activity.runOnUiThread {
                                    result.success(success)
                                }
                            }
                        }
                        "getAnchorPose" -> {
                            val anchorName = call.argument<String>("anchorId")
                            val anchor = if (anchorName != null) anchorsByName[anchorName] else null
                            if (anchor != null) {
                                result.success(serializePose(anchor.pose))
                            } else {
                                result.error("Error", "could not get anchor pose", null)
                            }
                        }
                        "getCameraPose" -> {
                            val cameraPose = currentFrame?.camera?.displayOrientedPose
                            if (cameraPose != null) {
                                result.success(serializePose(cameraPose))
                            } else {
                                result.error("Error", "could not get camera pose", null)
                            }
                        }
                        "snapshot" -> {
                            val width = textureView.width
                            val height = textureView.height
                            if (width <= 0 || height <= 0) {
                                result.error("e", "failed to take screenshot", null)
                                return
                            }
                            try {
                                val captured = textureView.bitmap
                                if (captured == null) {
                                    result.error("e", "failed to take screenshot", null)
                                    return
                                }
                                val bitmap = if (captured.width == width && captured.height == height) {
                                    captured
                                } else {
                                    Bitmap.createScaledBitmap(captured, width, height, true).also {
                                        if (it !== captured) captured.recycle()
                                    }
                                }
                                val stream = ByteArrayOutputStream()
                                bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
                                bitmap.recycle()
                                result.success(stream.toByteArray())
                            } catch (e: IOException) {
                                result.error("e", e.message, e.stackTrace)
                            }
                        }
                        "dispose" -> {
                            dispose()
                        }
                        else -> {}
                    }
                }
            }
    private val onObjectMethodCall =
            object : MethodChannel.MethodCallHandler {
                override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                    when (call.method) {
                        "init" -> {
                            // objectManagerChannel.invokeMethod("onError", listOf("ObjectTEST from
                            // Android"))
                            val scaleFactor = call.argument<Double>("androidScaleFactor")
                            if (scaleFactor != null) {
                                androidModelScaleFactor = scaleFactor.toFloat()
                            }
                        }
                        "addNode" -> {
                            val dict_node: HashMap<String, Any>? = call.arguments as? HashMap<String, Any>
                            dict_node?.let{
                                addNode(it).thenAccept{status: Boolean ->
                                    result.success(status)
                                }.exceptionally { throwable ->
                                    result.error("e", throwable.message, throwable.stackTrace)
                                    null
                                }
                            }
                        }
                        "addNodeToPlaneAnchor" -> {
                            val dict_node: HashMap<String, Any>? = call.argument<HashMap<String, Any>>("node")
                            val dict_anchor: HashMap<String, Any>? = call.argument<HashMap<String, Any>>("anchor")
                            if (dict_node != null && dict_anchor != null) {
                                addNode(dict_node, dict_anchor).thenAccept{status: Boolean ->
                                    result.success(status)
                                }.exceptionally { throwable ->
                                    result.error("e", throwable.message, throwable.stackTrace)
                                    null
                                }
                            } else {
                                result.success(false)
                            }

                        }
                        "removeNode" -> {
                            val nodeName: String? = call.argument<String>("name")
                            nodeName?.let{
                                nodesByName.remove(nodeName)
                                anchorChildren.values.forEach { it.remove(nodeName) }
                                cachedWorldMatrices.remove(nodeName)
                                dirtyTransformNodes.remove(nodeName)
                                filamentRenderer.removeModel(nodeName)
                                result.success(null)
                            }
                        }
                        "transformationChanged" -> {
                            val nodeName: String? = call.argument<String>("name")
                            val newTransformation: ArrayList<Double>? = call.argument<ArrayList<Double>>("transformation")
                            nodeName?.let{ name ->
                                newTransformation?.let{ transform ->
                                    transformNode(name, transform)
                                    result.success(null)
                                }
                            }
                        }
                        else -> {}
                    }
                }
            }
    private val onAnchorMethodCall =
            object : MethodChannel.MethodCallHandler {
                override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                    when (call.method) {
                        "addAnchor" -> {
                            val anchorType: Int? = call.argument<Int>("type")
                            if (anchorType != null){
                                when(anchorType) {
                                    0 -> { // Plane Anchor
                                        val transform: ArrayList<Double>? = call.argument<ArrayList<Double>>("transformation")
                                        val name: String? = call.argument<String>("name")
                                        if ( name != null && transform != null){
                                            result.success(addPlaneAnchor(transform, name))
                                        } else {
                                            result.success(false)
                                        }

                                    }
                                    else -> result.success(false)
                                }
                            } else {
                                result.success(false)
                            }
                        }
                        "removeAnchor" -> {
                            val anchorName: String? = call.argument<String>("name")
                            anchorName?.let{ name ->
                                removeAnchor(name)
                            }
                        }
                        "initGoogleCloudAnchorMode" -> {
                            if (session != null) {
                                val config = Config(session)
                                config.cloudAnchorMode = Config.CloudAnchorMode.ENABLED
                                config.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
                                config.focusMode = Config.FocusMode.AUTO
                                session?.configure(config)

                                cloudAnchorHandler = CloudAnchorHandler(session!!)
                            } else {
                                sessionManagerChannel.invokeMethod("onError", listOf("Error initializing cloud anchor mode: Session is null"))
                            }
                        }
                        "uploadAnchor" ->  {
                            val anchorName: String? = call.argument<String>("name")
                            val ttl: Int? = call.argument<Int>("ttl")
                            anchorName?.let {
                                val anchor = anchorsByName[anchorName]
                                if (ttl != null) {
                                    cloudAnchorHandler.hostCloudAnchorWithTtl(anchorName, anchor, cloudAnchorUploadedListener(), ttl!!)
                                } else {
                                    cloudAnchorHandler.hostCloudAnchor(anchorName, anchor, cloudAnchorUploadedListener())
                                }
                                result.success(true)
                            }

                        }
                        "downloadAnchor" -> {
                            val anchorId: String? = call.argument<String>("cloudanchorid")
                            anchorId?.let {
                                cloudAnchorHandler.resolveCloudAnchor(anchorId, cloudAnchorDownloadedListener())
                            }
                        }
                        else -> {}
                    }
                }
            }

    override fun getView(): View {
        return rootView
    }

    override fun dispose() {
        // Destroy AR session
        try {
            onPause()
            onDestroy()
            // ARCore session cleanup handled in onDestroy
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    init {
        viewContext = context

        rootView = FrameLayout(context)
        rootView.layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )

        textureView = TextureView(context)
        textureView.layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        textureView.isOpaque = true
        textureView.setLayerType(View.LAYER_TYPE_HARDWARE, null)

        filamentRenderer = FilamentArRenderer(
            context = viewContext,
            textureView = textureView,
            sessionProvider = { session },
            isSessionResumed = { isSessionResumed },
            onFrameAvailable = { frame -> handleArCoreFrame(frame) },
            onDisplayGeometryChanged = { rotation, width, height ->
                session?.setDisplayGeometry(rotation, width, height)
            },
        )

        rootView.addView(textureView)

        textureView.setOnTouchListener { _, motionEvent ->
            if (motionEvent.actionMasked == MotionEvent.ACTION_DOWN) {
                queueTap(motionEvent)
            }
            handleGestureTouch(motionEvent)
            true
        }

        setupLifeCycle(context)

        sessionManagerChannel.setMethodCallHandler(onSessionMethodCall)
        objectManagerChannel.setMethodCallHandler(onObjectMethodCall)
        anchorManagerChannel.setMethodCallHandler(onAnchorMethodCall)

        // Don't call onResume here - wait for initializeARView to configure the session first
    }

    private fun setupLifeCycle(context: Context) {
        activityLifecycleCallbacks =
                object : Application.ActivityLifecycleCallbacks {
                    override fun onActivityCreated(
                            activity: Activity,
                            savedInstanceState: Bundle?
                    ) {
                    }

                    override fun onActivityStarted(activity: Activity) {
                    }

                    override fun onActivityResumed(activity: Activity) {
                        if (isARInitialized) {
                            this@AndroidARView.onResume()
                        }
                    }

                    override fun onActivityPaused(activity: Activity) {
                        // Stop rendering before pausing ARCore to avoid session.update races.
                        this@AndroidARView.onPause()
                        try {
                            session?.pause()
                        } catch (e: Exception) {
                            Log.e(TAG, "Error in onActivityPaused: ${e.message}", e)
                        }
                    }

                    override fun onActivityStopped(activity: Activity) {
                        // onStopped()
                        this@AndroidARView.onPause()
                    }

                    override fun onActivitySaveInstanceState(
                            activity: Activity,
                            outState: Bundle
                    ) {}

                    override fun onActivityDestroyed(activity: Activity) {
//                        onPause()
//                        onDestroy()
                    }
                }

        activity.application.registerActivityLifecycleCallbacks(this.activityLifecycleCallbacks)
    }

    fun onResume() {
        filamentRenderer.attach()
        resumeSessionInternal()
    }

    fun onPause() {
        // hide instructions view if no longer required
        if (showAnimatedGuide){
            animatedGuide?.let { guide ->
                val view = activity.findViewById(R.id.content) as ViewGroup
                view.removeView(guide)
            }
            showAnimatedGuide = false
        }
        filamentRenderer.detach()
        activeAugmentedImages.clear()
        lastAugmentedImageUpdateMs.clear()
        isSessionResumed = false
    }

    private fun resumeSessionInternal() {
        try {
            session?.resume()
            isSessionResumed = true
        } catch (e: Exception) {
            isSessionResumed = false
            Log.e(TAG, "Error resuming session: ${e.javaClass.simpleName}: ${e.message}", e)
        }
    }

    fun onDestroy() {
        try {
            worldOriginAnchor?.detach()
            worldOriginAnchor = null
            filamentRenderer.destroy()
            session?.close()
            session = null

            activeAugmentedImages.clear()
            lastAugmentedImageUpdateMs.clear()

            modelIoExecutor.shutdown()
            imageTrackingExecutor.shutdown()
            
            onFrameUpdateListener = null
        } catch (e: Exception) {
            Log.e(TAG, "Error in onDestroy: ${e.message}")
            e.printStackTrace()
        }
    }

    private fun initializeARView(call: MethodCall, result: MethodChannel.Result) {
        // Unpack call arguments
        val argShowFeaturePoints: Boolean? = call.argument<Boolean>("showFeaturePoints")
        val argPlaneDetectionConfig: Int? = call.argument<Int>("planeDetectionConfig")
        val argShowPlanes: Boolean? = call.argument<Boolean>("showPlanes")
        val argCustomPlaneTexturePath: String? = call.argument<String>("customPlaneTexturePath")
        val argShowWorldOrigin: Boolean? = call.argument<Boolean>("showWorldOrigin")
        val argHandleTaps: Boolean? = call.argument<Boolean>("handleTaps")
        val argHandleRotation: Boolean? = call.argument<Boolean>("handleRotation")
        val argHandlePans: Boolean? = call.argument<Boolean>("handlePans")
        val argShowAnimatedGuide: Boolean? = call.argument<Boolean>("showAnimatedGuide")
        val argTrackingImagePaths: List<String>? = call.argument<List<String>>("trackingImagePaths")
        val argContinuousImageTracking: Boolean? = call.argument<Boolean>("continuousImageTracking")
        val argImageTrackingUpdateIntervalMs: Number? = call.argument<Number>("imageTrackingUpdateIntervalMs")
        val argLightIntensityMultiplier: Number? = call.argument<Number>("lightIntensityMultiplier")

        // Set up frame update listener
        onFrameUpdateListener = { frameTimeNanos ->
            onFrame(frameTimeNanos)
        }

        // Ensure ARCore is installed
        try {
            val installStatus = ArCoreApk.getInstance().requestInstall(activity, !mUserRequestedInstall)
            if (installStatus == ArCoreApk.InstallStatus.INSTALL_REQUESTED) {
                mUserRequestedInstall = false
                result.success(null)
                return
            }
        } catch (e: UnavailableArcoreNotInstalledException) {
            result.error("ARCore", "ARCore not installed", e)
            return
        } catch (e: UnavailableApkTooOldException) {
            result.error("ARCore", "ARCore APK too old", e)
            return
        } catch (e: UnavailableSdkTooOldException) {
            result.error("ARCore", "ARCore SDK too old", e)
            return
        } catch (e: UnavailableDeviceNotCompatibleException) {
            result.error("ARCore", "ARCore not compatible with this device", e)
            return
        }


        // Configure Plane scanning guide (UI handled by Flutter if needed)
        if (argShowAnimatedGuide == true) {
            showAnimatedGuide = true
        }

        // Create and configure ARCore session
        if (session == null) {
            session = Session(activity)
        }
        session?.let { filamentRenderer.bindSession(it) }

        val config = session!!.config
        when (argPlaneDetectionConfig) {
            1 -> config.planeFindingMode = Config.PlaneFindingMode.HORIZONTAL
            2 -> config.planeFindingMode = Config.PlaneFindingMode.VERTICAL
            3 -> config.planeFindingMode = Config.PlaneFindingMode.HORIZONTAL_AND_VERTICAL
            else -> config.planeFindingMode = Config.PlaneFindingMode.DISABLED
        }
        config.depthMode = Config.DepthMode.DISABLED
        config.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
        config.focusMode = Config.FocusMode.AUTO
        // Filament uses its own studio rig — skip ARCore HDR estimation for CPU savings.
        config.lightEstimationMode = Config.LightEstimationMode.DISABLED
        session!!.configure(config)
        configureBestCameraConfig(session!!)

        // Configure image tracking
        applyImageTrackingSettings(
            imagePaths = argTrackingImagePaths,
            continuous = argContinuousImageTracking,
            intervalMs = argImageTrackingUpdateIntervalMs
        )

        // Feature points/planes/world origin rendering is handled by the GL renderer
        showFeaturePoints = argShowFeaturePoints == true
        showPlanes = argShowPlanes == true
        showWorldOrigin = argShowWorldOrigin == true
        if (!showWorldOrigin) {
            worldOriginAnchor?.detach()
            worldOriginAnchor = null
        }

        // Configure gestures
        enableRotation = argHandleRotation == true
        enablePans = argHandlePans == true

        // Now that configuration is complete, start the AR session
        if (!isARInitialized) {
            isARInitialized = true
        }
        onResume()

        // Apply lighting multiplier if provided
        argLightIntensityMultiplier?.toFloat()?.let { multiplier ->
            filamentRenderer.setLightIntensityMultiplier(multiplier)
        }

        result.success(null)
    }

    private fun onFrame(frameTimeNanos: Long) {
        val frame = currentFrame ?: return

        ancillaryFrameSkip++

        // hide instructions view if no longer required
        if (showAnimatedGuide) {
            for (plane in frame.getUpdatedTrackables(Plane::class.java)) {
                if (plane.trackingState === TrackingState.TRACKING) {
                    animatedGuide?.let { guide ->
                        val view = activity.findViewById(R.id.content) as ViewGroup
                        view.removeView(guide)
                    }
                    showAnimatedGuide = false
                    break
                }
            }
        }

        val updatedAnchors = frame.updatedAnchors
        if (this::cloudAnchorHandler.isInitialized) {
            cloudAnchorHandler.onUpdate(updatedAnchors)
        }

        val scanForPlanes = !hasReportedPlaneDetection
        val scanForImages = imageTrackingEnabled || continuousImageTracking
        if (scanForPlanes || scanForImages || ancillaryFrameSkip % 2 == 0) {
            if (scanForImages) {
                checkForTrackedImages()
            }
            if (scanForPlanes || ancillaryFrameSkip % 2 == 0) {
                reportPlaneDetectedIfNeeded(frame)
            }
        }
    }

    /**
     * Picks the highest-resolution camera mode, preferring 60fps when it is close in
     * resolution to the best 30fps mode (smooth motion without sacrificing too much detail).
     */
    private fun configureBestCameraConfig(session: Session) {
        try {
            val filter60 = CameraConfigFilter(session)
                .setTargetFps(EnumSet.of(CameraConfig.TargetFps.TARGET_FPS_60))
            val configs60 = session.getSupportedCameraConfigs(filter60)

            val filter30 = CameraConfigFilter(session)
                .setTargetFps(EnumSet.of(CameraConfig.TargetFps.TARGET_FPS_30))
            val configs30 = session.getSupportedCameraConfigs(filter30)

            fun resolutionPixels(config: CameraConfig): Long {
                val size = config.imageSize
                return size.width.toLong() * size.height.toLong()
            }

            val best60 = configs60.maxByOrNull(::resolutionPixels)
            val best30 = configs30.maxByOrNull(::resolutionPixels)

            val selected = when {
                best60 != null && best30 != null -> {
                    val px60 = resolutionPixels(best60)
                    val px30 = resolutionPixels(best30)
                    if (px60 >= px30 * 85 / 100) best60 else best30
                }
                best60 != null -> best60
                best30 != null -> best30
                else -> session.getSupportedCameraConfigs(CameraConfigFilter(session))
                    .maxByOrNull(::resolutionPixels)
            }

            if (selected != null) {
                session.cameraConfig = selected
                val size = selected.imageSize
                Log.d(
                    TAG,
                    "AR camera config: ${size.width}x${size.height}, fps=${selected.fpsRange}",
                )
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to select camera config, using ARCore default", e)
        }
    }

    private fun addNode(dict_node: HashMap<String, Any>, dict_anchor: HashMap<String, Any>? = null): CompletableFuture<Boolean>{
        val completableFutureSuccess: CompletableFuture<Boolean> = CompletableFuture()

        try {
            val nodeName = dict_node["name"] as String
            val transformation = dict_node["transformation"] as ArrayList<Double>
            val nodeType = dict_node["type"] as Int
            val uri = dict_node["uri"] as String

            val anchorName: String? = dict_anchor?.get("name") as? String
            nodesByName[nodeName] = SimpleNode(
                name = nodeName,
                transformation = transformation,
                type = nodeType,
                uri = uri,
                anchorName = anchorName,
                worldLocked = anchorName != null,
            )

            if (anchorName != null) {
                val children = anchorChildren.getOrPut(anchorName) { mutableListOf() }
                if (!children.contains(nodeName)) {
                    children.add(nodeName)
                }
            }
            dirtyTransformNodes.add(nodeName)

            loadModelForNode(nodeName)
            completableFutureSuccess.complete(true)
        } catch (e: java.lang.Exception) {
            completableFutureSuccess.completeExceptionally(e)
        }

        return completableFutureSuccess
    }

    private fun loadModelForNode(nodeName: String) {
        val node = nodesByName[nodeName] ?: return

        modelIoExecutor.execute {
            try {
                when (node.type) {
                    0 -> { // localGLTF2
                        val gltfBytes = readFlutterAssetBytes(node.uri)
                        val basePath = node.uri.substringBeforeLast("/", "")
                        val resourceMap = loadGltfResourcesFromAssets(gltfBytes, basePath)
                        filamentRenderer.loadGltf(node.name, gltfBytes, resourceMap)
                    }
                    1 -> { // localGLB
                        val glbBytes = readFlutterAssetBytes(node.uri)
                        filamentRenderer.loadGlb(node.name, glbBytes)
                    }
                    2 -> { // webGLB
                        val glbBytes = readUrlBytes(node.uri)
                        filamentRenderer.loadGlb(node.name, glbBytes)
                    }
                    3 -> { // fileSystemAppFolderGLB
                        val glbBytes = readFileBytes(node.uri)
                        filamentRenderer.loadGlb(node.name, glbBytes)
                    }
                    4 -> { // fileSystemAppFolderGLTF2
                        val gltfBytes = readFileBytes(node.uri)
                        val basePath = File(node.uri).parent ?: ""
                        val resourceMap = loadGltfResourcesFromFile(gltfBytes, basePath)
                        filamentRenderer.loadGltf(node.name, gltfBytes, resourceMap)
                    }
                    else -> {
                        activity.runOnUiThread {
                            sessionManagerChannel.invokeMethod("onError", listOf("Unsupported node type ${node.type}"))
                        }
                    }
                }
            } catch (e: Exception) {
                activity.runOnUiThread {
                    sessionManagerChannel.invokeMethod("onError", listOf("Error loading model: ${e.message}"))
                }
            }
        }
    }

    private fun readFlutterAssetBytes(path: String): ByteArray {
        val loader = FlutterInjector.instance().flutterLoader()
        if (!loader.initialized()) {
            loader.startInitialization(viewContext)
            loader.ensureInitializationComplete(viewContext, null)
        }
        val key = loader.getLookupKeyForAsset(path)
        return viewContext.assets.open(key).readBytes()
    }

    private fun readUrlBytes(url: String): ByteArray {
        val connection = URL(url).openConnection() as HttpURLConnection
        connection.connectTimeout = 15000
        connection.readTimeout = 15000
        connection.requestMethod = "GET"
        connection.connect()
        connection.inputStream.use { input ->
            return input.readBytes()
        }
    }

    private fun readFileBytes(path: String): ByteArray {
        val file = if (path.startsWith("file://")) File(Uri.parse(path).path ?: path) else File(path)
        return file.readBytes()
    }

    private fun loadGltfResourcesFromAssets(gltfBytes: ByteArray, basePath: String): Map<String, ByteArray> {
        val json = String(gltfBytes)
        val uris = extractGltfUris(json)
        val resources = mutableMapOf<String, ByteArray>()
        for (uri in uris) {
            val data = decodeDataUri(uri) ?: run {
                val assetPath = if (basePath.isNotEmpty()) "$basePath/$uri" else uri
                readFlutterAssetBytes(assetPath)
            }
            resources[uri] = data
        }
        return resources
    }

    private fun loadGltfResourcesFromFile(gltfBytes: ByteArray, basePath: String): Map<String, ByteArray> {
        val json = String(gltfBytes)
        val uris = extractGltfUris(json)
        val resources = mutableMapOf<String, ByteArray>()
        for (uri in uris) {
            val data = decodeDataUri(uri) ?: run {
                val filePath = if (basePath.isNotEmpty()) "$basePath/$uri" else uri
                readFileBytes(filePath)
            }
            resources[uri] = data
        }
        return resources
    }

    private fun extractGltfUris(json: String): List<String> {
        val pattern = Pattern.compile("\\\"uri\\\"\\s*:\\s*\\\"([^\\\"]+)\\\"")
        val matcher = pattern.matcher(json)
        val uris = mutableListOf<String>()
        while (matcher.find()) {
            val uri = matcher.group(1)
            if (!uri.isNullOrBlank()) {
                uris.add(uri)
            }
        }
        return uris.distinct()
    }

    private fun decodeDataUri(uri: String): ByteArray? {
        if (!uri.startsWith("data:")) return null
        val parts = uri.split(",", limit = 2)
        if (parts.size != 2) return null
        return try {
            android.util.Base64.decode(parts[1], android.util.Base64.DEFAULT)
        } catch (e: Exception) {
            null
        }
    }

    private fun computeWorldMatrixForNode(node: SimpleNode): FloatArray {
        val nodeMatrix = FloatArray(16)
        val anchorMatrix = FloatArray(16)
        val modelMatrix = FloatArray(16)
        matrixFromTransform(node.transformation, nodeMatrix)
        val anchorName = node.anchorName
        if (anchorName != null) {
            val stableAnchor = anchorTransformsByName[anchorName]
            if (stableAnchor != null) {
                // Frozen at placement — never follow live plane refinement (causes jitter).
                System.arraycopy(stableAnchor, 0, anchorMatrix, 0, 16)
                Matrix.multiplyMM(modelMatrix, 0, anchorMatrix, 0, nodeMatrix, 0)
            } else {
                val anchor = anchorsByName[anchorName]
                if (anchor != null && anchor.trackingState == TrackingState.TRACKING) {
                    anchor.pose.toMatrix(anchorMatrix, 0)
                    Matrix.multiplyMM(modelMatrix, 0, anchorMatrix, 0, nodeMatrix, 0)
                } else {
                    System.arraycopy(nodeMatrix, 0, modelMatrix, 0, 16)
                }
            }
        } else {
            System.arraycopy(nodeMatrix, 0, modelMatrix, 0, 16)
        }
        return modelMatrix
    }

    private fun updateModelTransforms() {
        if (nodesByName.isEmpty()) return

        // After placement the world matrix is frozen — skip all matrix work until the
        // user drags, rotates, or scales (dirtyTransformNodes).
        if (dirtyTransformNodes.isEmpty()) {
            return
        }

        val scaleMatrix = FloatArray(16)
        val scaledModelMatrix = FloatArray(16)

        val dirtyNames = dirtyTransformNodes.toList()
        dirtyNames.forEach { nodeName ->
            val node = nodesByName[nodeName] ?: return@forEach
            val modelMatrix = computeWorldMatrixForNode(node)
            cachedWorldMatrices[node.name] = modelMatrix.clone()

            val modelScaleFactor = getModelScaleFactor(node.type)
            if (modelScaleFactor != 1.0f) {
                Matrix.setIdentityM(scaleMatrix, 0)
                Matrix.scaleM(scaleMatrix, 0, modelScaleFactor, modelScaleFactor, modelScaleFactor)
                Matrix.multiplyMM(scaledModelMatrix, 0, modelMatrix, 0, scaleMatrix, 0)
                filamentRenderer.updateTransformIfChanged(node.name, scaledModelMatrix)
            } else {
                filamentRenderer.updateTransformIfChanged(node.name, modelMatrix)
            }
        }
        dirtyTransformNodes.removeAll(dirtyNames.toSet())
    }

    private fun getModelScaleFactor(nodeType: Int): Float {
        return when (nodeType) {
            0, 1, 2, 3, 4 -> androidModelScaleFactor
            else -> 1.0f
        }
    }

    private fun matrixFromTransform(transform: ArrayList<Double>, outMatrix: FloatArray) {
        if (transform.size < 16) {
            Matrix.setIdentityM(outMatrix, 0)
            return
        }
        for (i in 0 until 16) {
            outMatrix[i] = transform[i].toFloat()
        }
    }

    private fun transformNode(name: String, transform: ArrayList<Double>) {
        val node = nodesByName[name] ?: return
        val epsilon = if (node.worldLocked && !isPanning && !isRotating) 2e-3 else 1e-5
        if (transformationsApproximatelyEqual(node.transformation, transform, epsilon)) return

        node.transformation = transform
        dirtyTransformNodes.add(name)
    }

    private fun transformationsApproximatelyEqual(
        a: ArrayList<Double>,
        b: ArrayList<Double>,
        epsilon: Double = 1e-5,
    ): Boolean {
        if (a.size < 16 || b.size < 16) return false
        for (i in 0 until 16) {
            if (kotlin.math.abs(a[i] - b[i]) > epsilon) return false
        }
        return true
    }

    private fun queueTap(motionEvent: MotionEvent) {
        synchronized(tapLock) {
            queuedTap?.recycle()
            queuedTap = MotionEvent.obtain(motionEvent)
        }
    }

    private fun cancelQueuedTap() {
        synchronized(tapLock) {
            queuedTap?.recycle()
            queuedTap = null
        }
    }

    private fun handleGestureTouch(motionEvent: MotionEvent?): Boolean {
        if (motionEvent == null) return false
        if (!enablePans && !enableRotation) return false

        val frame = currentFrame ?: return false
        when (motionEvent.actionMasked) {
            MotionEvent.ACTION_DOWN -> {
                activeGestureNodeName = null
                isPanning = false
                isRotating = false
                panPending = false
                lastRotationAngle = 0f

                // Only prepare drag gestures for world-anchored nodes; preview nodes
                // must receive taps for plane placement.
                if (enablePans) {
                    val anchored = findNearestAnchoredNodeToCamera(frame)
                    if (anchored != null) {
                        activeGestureNodeName = anchored.name
                        panStartX = motionEvent.x
                        panStartY = motionEvent.y
                        panPending = true
                        return true
                    }
                }
                return false
            }
            MotionEvent.ACTION_POINTER_DOWN -> {
                if (!enableRotation || motionEvent.pointerCount < 2) {
                    return panPending || isPanning
                }
                val anchored = findNearestAnchoredNodeToCamera(frame) ?: return false
                activeGestureNodeName = anchored.name
                isRotating = true
                isPanning = false
                panPending = false
                cancelQueuedTap()
                lastRotationAngle = rotationAngle(motionEvent)
                objectManagerChannel.invokeMethod("onRotationStart", anchored.name)
                return true
            }
            MotionEvent.ACTION_MOVE -> {
                val nodeName = activeGestureNodeName

                if (panPending && enablePans && nodeName != null) {
                    val dx = motionEvent.x - panStartX
                    val dy = motionEvent.y - panStartY
                    if (dx * dx + dy * dy > touchSlop * touchSlop) {
                        panPending = false
                        isPanning = true
                        cancelQueuedTap()
                        objectManagerChannel.invokeMethod("onPanStart", nodeName)
                    } else {
                        return true
                    }
                }

                val activeName = activeGestureNodeName ?: return false
                val node = nodesByName[activeName] ?: return false

                if (isRotating && enableRotation && motionEvent.pointerCount >= 2) {
                    val currentAngle = rotationAngle(motionEvent)
                    val delta = currentAngle - lastRotationAngle
                    lastRotationAngle = currentAngle

                    rotateNode(node, delta)
                    objectManagerChannel.invokeMethod("onRotationChange", node.name)
                    return true
                }

                if (isPanning && enablePans) {
                    val hitPose = hitTestPlaneOrPoint(frame, motionEvent) ?: return false
                    moveNodeToPose(node, hitPose, smooth = true)
                    return true
                }
                return panPending
            }
            MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                val nodeName = activeGestureNodeName
                if (nodeName != null) {
                    val node = nodesByName[nodeName]
                    val transform = node?.transformation
                    if (isPanning && transform != null) {
                        objectManagerChannel.invokeMethod(
                            "onPanEnd",
                            mapOf("name" to nodeName, "transform" to transform)
                        )
                    }
                    if (isRotating && transform != null) {
                        objectManagerChannel.invokeMethod(
                            "onRotationEnd",
                            mapOf("name" to nodeName, "transform" to transform)
                        )
                    }
                }
                activeGestureNodeName = null
                isPanning = false
                isRotating = false
                panPending = false
                lastRotationAngle = 0f
                return false
            }
            else -> return false
        }
    }

    private fun hitTestPlaneOrPoint(frame: Frame, motionEvent: MotionEvent): Pose? {
        val hitResults = frame.hitTest(motionEvent)
        val hit = hitResults.firstOrNull { result ->
            when (val trackable = result.trackable) {
                is Plane -> trackable.trackingState == TrackingState.TRACKING &&
                        trackable.isPoseInPolygon(result.hitPose)
                is Point -> trackable.trackingState == TrackingState.TRACKING
                else -> false
            }
        }
        return hit?.hitPose
    }

    private fun findNearestNode(hitPose: Pose): SimpleNode? {
        if (nodesByName.isEmpty()) return null
        var nearest: SimpleNode? = null
        var minDist = Float.MAX_VALUE
        val hitX = hitPose.tx()
        val hitY = hitPose.ty()
        val hitZ = hitPose.tz()

        nodesByName.values.forEach { node ->
            val pos = getNodeWorldPosition(node)
            val dx = pos[0] - hitX
            val dy = pos[1] - hitY
            val dz = pos[2] - hitZ
            val dist = dx * dx + dy * dy + dz * dz
            if (dist < minDist) {
                minDist = dist
                nearest = node
            }
        }
        return nearest
    }

    private fun findNearestAnchoredNodeToCamera(frame: Frame): SimpleNode? {
        if (nodesByName.isEmpty()) return null
        val cameraPose = frame.camera.pose
        val camX = cameraPose.tx()
        val camY = cameraPose.ty()
        val camZ = cameraPose.tz()

        var nearest: SimpleNode? = null
        var minDist = Float.MAX_VALUE
        nodesByName.values.forEach { node ->
            if (node.anchorName == null) return@forEach
            val pos = getNodeWorldPosition(node)
            val dx = pos[0] - camX
            val dy = pos[1] - camY
            val dz = pos[2] - camZ
            val dist = dx * dx + dy * dy + dz * dz
            if (dist < minDist) {
                minDist = dist
                nearest = node
            }
        }
        return nearest
    }

    private fun reportPlaneDetectedIfNeeded(frame: Frame) {
        if (hasReportedPlaneDetection) return
        planeDetectionFrameSkip++
        if (planeDetectionFrameSkip < 6) return
        planeDetectionFrameSkip = 0
        val session = session ?: return
        val planes = session.getAllTrackables(Plane::class.java)
        val hasUsablePlane = planes.any { plane ->
            plane.trackingState == TrackingState.TRACKING &&
                    plane.type == Plane.Type.HORIZONTAL_UPWARD_FACING &&
                    plane.extentX >= 0.2f &&
                    plane.extentZ >= 0.2f
        }
        if (!hasUsablePlane) return
        hasReportedPlaneDetection = true
        activity.runOnUiThread {
            sessionManagerChannel.invokeMethod("onPlaneDetected", null)
        }
    }

    private fun getNodeWorldPosition(node: SimpleNode): FloatArray {
        val modelMatrix = computeWorldMatrixForNode(node)
        return floatArrayOf(modelMatrix[12], modelMatrix[13], modelMatrix[14])
    }

    private fun moveNodeToPose(node: SimpleNode, hitPose: Pose, smooth: Boolean = false) {
        val hitMatrix = FloatArray(16)
        hitPose.toMatrix(hitMatrix, 0)

        val targetX: Double
        val targetY: Double
        val targetZ: Double

        if (node.anchorName != null) {
            val stableAnchorMatrix = anchorTransformsByName[node.anchorName]
            if (stableAnchorMatrix != null) {
                val invAnchor = FloatArray(16)
                val localMatrix = FloatArray(16)
                Matrix.invertM(invAnchor, 0, stableAnchorMatrix, 0)
                Matrix.multiplyMM(localMatrix, 0, invAnchor, 0, hitMatrix, 0)
                targetX = localMatrix[12].toDouble()
                targetY = localMatrix[13].toDouble()
                targetZ = localMatrix[14].toDouble()
            } else {
                val anchor = anchorsByName[node.anchorName]
                val targetPose = if (anchor != null && anchor.trackingState != TrackingState.STOPPED) {
                    anchor.pose.inverse().compose(hitPose)
                } else {
                    hitPose
                }
                targetX = targetPose.tx().toDouble()
                targetY = targetPose.ty().toDouble()
                targetZ = targetPose.tz().toDouble()
            }
        } else {
            targetX = hitPose.tx().toDouble()
            targetY = hitPose.ty().toDouble()
            targetZ = hitPose.tz().toDouble()
        }

        val transform = node.transformation
        if (transform.size < 16) return

        val smoothFactor = 0.32

        if (node.anchorName != null) {
            transform[12] = if (smooth) {
                transform[12] + (targetX - transform[12]) * smoothFactor
            } else targetX
            transform[14] = if (smooth) {
                transform[14] + (targetZ - transform[14]) * smoothFactor
            } else targetZ
        } else {
            transform[12] = if (smooth) {
                transform[12] + (targetX - transform[12]) * smoothFactor
            } else targetX
            transform[13] = if (smooth) {
                transform[13] + (targetY - transform[13]) * smoothFactor
            } else targetY
            transform[14] = if (smooth) {
                transform[14] + (targetZ - transform[14]) * smoothFactor
            } else targetZ
        }
        node.transformation = transform
        dirtyTransformNodes.add(node.name)
    }

    private fun rotateNode(node: SimpleNode, deltaRadians: Float) {
        val transform = node.transformation
        if (transform.size < 16) return

        val matrix = FloatArray(16)
        matrixFromTransform(transform, matrix)
        val deltaDegrees = Math.toDegrees(deltaRadians.toDouble()).toFloat()
        Matrix.rotateM(matrix, 0, deltaDegrees, 0f, 1f, 0f)

        val updated = ArrayList<Double>(16)
        for (i in 0 until 16) {
            updated.add(matrix[i].toDouble())
        }
        node.transformation = updated
        dirtyTransformNodes.add(node.name)
    }

    private fun rotationAngle(event: MotionEvent): Float {
        if (event.pointerCount < 2) return 0f
        val dx = event.getX(1) - event.getX(0)
        val dy = event.getY(1) - event.getY(0)
        return kotlin.math.atan2(dy, dx)
    }

    private fun motionEventMidpoint(event: MotionEvent): MotionEvent? {
        if (event.pointerCount < 2) return null
        val x = (event.getX(0) + event.getX(1)) / 2f
        val y = (event.getY(0) + event.getY(1)) / 2f
        val downTime = event.downTime
        val eventTime = event.eventTime
        return MotionEvent.obtain(downTime, eventTime, MotionEvent.ACTION_DOWN, x, y, 0)
    }

    private fun pickBestPlaneHit(hits: List<HitResult>): HitResult? {
        val planeHits = hits.filter { hit ->
            val trackable = hit.trackable
            trackable is Plane &&
                trackable.type == Plane.Type.HORIZONTAL_UPWARD_FACING &&
                trackable.trackingState == TrackingState.TRACKING &&
                trackable.isPoseInPolygon(hit.hitPose)
        }
        if (planeHits.isEmpty()) {
            return hits.firstOrNull { hit ->
                val trackable = hit.trackable
                trackable is Point && trackable.trackingState == TrackingState.TRACKING
            }
        }
        return planeHits.minByOrNull { it.distance }
    }

    private fun createAnchorForPlacement(
        session: Session,
        frame: Frame?,
        transform: ArrayList<Double>,
    ): Anchor {
        val recentTap = SystemClock.uptimeMillis() - lastTapAtMs <= 750L
        val tapX = if (recentTap) lastTapX else null
        val tapY = if (recentTap) lastTapY else null
        val width = textureView.width
        val height = textureView.height
        val x = tapX ?: (width / 2f)
        val y = tapY ?: (height / 2f)

        if (frame != null && width > 0 && height > 0) {
            val hit = pickBestPlaneHit(frame.hitTest(x, y))
            if (hit != null) {
                // World-fixed pose from the hit — do NOT use hit.createAnchor() which
                // stays tied to plane refinement and causes visible vibration.
                return session.createAnchor(hit.hitPose)
            }
        }

        return session.createAnchor(poseFromTransformMatrix(transform))
    }

    private fun addPlaneAnchor(transform: ArrayList<Double>, name: String): Boolean {
        val session = session ?: return false

        return try {
            val frame = currentFrame
            val anchor = createAnchorForPlacement(session, frame, transform)
            anchorsByName[name] = anchor
            anchorChildren.putIfAbsent(name, mutableListOf())
            val anchorMatrix = FloatArray(16)
            anchor.pose.toMatrix(anchorMatrix, 0)
            anchorTransformsByName[name] = anchorMatrix.clone()
            true
        } catch (e: Exception) {
            false
        }
    }

    private fun removeAnchor(name: String) {
        val childNodes = anchorChildren.remove(name) ?: emptyList()
        childNodes.forEach { child ->
            cachedWorldMatrices.remove(child)
            dirtyTransformNodes.remove(child)
        }
        val anchor = anchorsByName.remove(name)
        anchor?.detach()
        anchorTransformsByName.remove(name)
    }

    private fun serializePlaneAndPointHits(
        allHitResults: List<HitResult>
    ): ArrayList<HashMap<String, Any>> {
        val planeAndPointHitResults = allHitResults.filter { hit ->
            when (val trackable = hit.trackable) {
                is Plane -> trackable.trackingState == TrackingState.TRACKING &&
                        trackable.isPoseInPolygon(hit.hitPose)
                is Point -> trackable.trackingState == TrackingState.TRACKING
                else -> false
            }
        }
        return ArrayList(planeAndPointHitResults.map { serializeHitResult(it) })
    }

    private fun handleQueuedTap(frame: Frame) {
        val tap = synchronized(tapLock) {
            val value = queuedTap
            queuedTap = null
            value
        } ?: return

        try {
            lastTapX = tap.x
            lastTapY = tap.y
            lastTapAtMs = SystemClock.uptimeMillis()
            val serialized = serializePlaneAndPointHits(frame.hitTest(tap))
            activity.runOnUiThread {
                sessionManagerChannel.invokeMethod("onPlaneOrPointTap", serialized)
            }
        } finally {
            tap.recycle()
        }
    }

    private inner class cloudAnchorUploadedListener: CloudAnchorHandler.CloudAnchorListener {
        override fun onCloudTaskComplete(anchorName: String?, anchor: Anchor?) {
            val cloudState = anchor!!.cloudAnchorState
            if (cloudState.isError) {
                Log.e(TAG, "Error uploading anchor, state $cloudState")
                sessionManagerChannel.invokeMethod("onError", listOf("Error uploading anchor, state $cloudState"))
                return
            }
            // Swap old and new anchor for the name
            if (anchorName != null) {
                val oldAnchor = anchorsByName[anchorName]
                anchorsByName[anchorName] = anchor!!
                oldAnchor?.detach()
            }

            val args = HashMap<String, String?>()
            args["name"] = anchorName
            args["cloudanchorid"] = anchor.cloudAnchorId
            anchorManagerChannel.invokeMethod("onCloudAnchorUploaded", args)
        }
    }

    private inner class cloudAnchorDownloadedListener: CloudAnchorHandler.CloudAnchorListener {
        override fun onCloudTaskComplete(anchorName: String?, anchor: Anchor?) {
            val cloudState = anchor!!.cloudAnchorState
            if (cloudState.isError) {
                Log.e(TAG, "Error downloading anchor, state $cloudState")
                sessionManagerChannel.invokeMethod("onError", listOf("Error downloading anchor, state $cloudState"))
                return
            }
            val anchorIdName = anchorName ?: ""
            anchorsByName[anchorIdName] = anchor!!
            anchorChildren.putIfAbsent(anchorIdName, mutableListOf())
            // Register new anchor on the Flutter side of the plugin
            anchorManagerChannel.invokeMethod(
                "onAnchorDownloadSuccess",
                serializeAnchor(anchorIdName, anchor, anchorChildren[anchorIdName] ?: emptyList()),
                object: MethodChannel.Result {
                override fun success(result: Any?) {
                    val registeredName = result.toString()
                    if (registeredName.isNotEmpty() && registeredName != anchorIdName) {
                        val existing = anchorsByName.remove(anchorIdName)
                        if (existing != null) {
                            anchorsByName[registeredName] = existing
                        }
                        val children = anchorChildren.remove(anchorIdName)
                        if (children != null) {
                            anchorChildren[registeredName] = children
                        }
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    sessionManagerChannel.invokeMethod("onError", listOf("Error while registering downloaded anchor at the AR Flutter plugin: $errorMessage"))
                }

                override fun notImplemented() {
                    sessionManagerChannel.invokeMethod("onError", listOf("Error while registering downloaded anchor at the AR Flutter plugin"))
                }
            })
        }
    }

    private fun checkForTrackedImages() {
        val frame = currentFrame ?: return
        
        val updatedAugmentedImages = frame.getUpdatedTrackables(AugmentedImage::class.java)
        
        val now = SystemClock.uptimeMillis()
        for (augmentedImage in updatedAugmentedImages) {
            when (augmentedImage.trackingState) {
                TrackingState.TRACKING -> {
                    if (augmentedImage.trackingMethod == AugmentedImage.TrackingMethod.FULL_TRACKING) {
                        val imageName = augmentedImage.name ?: "unknown"
                        val centerPose = augmentedImage.centerPose
                        val transformation = serializePose(centerPose)
                        val shouldEmit = if (continuousImageTracking) {
                            val lastUpdate = lastAugmentedImageUpdateMs[imageName] ?: 0L
                            now - lastUpdate >= imageTrackingUpdateIntervalMs
                        } else {
                            !activeAugmentedImages.contains(imageName)
                        }

                        if (shouldEmit) {
                            emitImageDetection(imageName, transformation)
                            if (continuousImageTracking) {
                                lastAugmentedImageUpdateMs[imageName] = now
                            }
                        }

                        activeAugmentedImages.add(imageName)
                    }
                }
                TrackingState.PAUSED -> Unit
                TrackingState.STOPPED -> {
                    augmentedImage.name?.let { name ->
                        activeAugmentedImages.remove(name)
                        lastAugmentedImageUpdateMs.remove(name)
                    }
                }
            }
        }
    }

    private fun emitImageDetection(imageName: String, transformation: DoubleArray) {
        val arguments = HashMap<String, Any>()
        arguments["imageName"] = imageName
        arguments["transformation"] = transformation

        activity.runOnUiThread {
            sessionManagerChannel.invokeMethod("onImageDetected", arguments)
        }
    }

    private fun applyImageTrackingSettings(
        imagePaths: List<String>?,
        continuous: Boolean?,
        intervalMs: Number?
    ) {
        if (continuous != null) {
            continuousImageTracking = continuous
        }
        if (intervalMs != null) {
            imageTrackingUpdateIntervalMs = intervalMs.toLong()
        }
        if (imagePaths != null) {
            if (imagePaths.isEmpty()) {
                imageTrackingEnabled = false
            } else {
                setupImageTrackingAsync(imagePaths)
            }
        }
    }

    private fun imageCacheKey(imagePaths: List<String>): String {
        return imagePaths.joinToString("|")
    }

    private fun buildImageDatabase(session: Session, imagePaths: List<String>): Pair<AugmentedImageDatabase, Boolean> {
        val imageDatabase = AugmentedImageDatabase(session)
        var success = true

        for (imagePath in imagePaths) {
            try {
                val loader = FlutterInjector.instance().flutterLoader()
                val key = loader.getLookupKeyForAsset(imagePath)

                val inputStream = viewContext.assets.open(key)
                val bitmap = android.graphics.BitmapFactory.decodeStream(inputStream)
                inputStream.close()

                if (bitmap != null) {
                    val imageName = imagePath.substringAfterLast("/").substringBeforeLast(".")
                    val physicalWidth = 0.2f // 20cm - adjust based on your actual printed image size
                    val index = imageDatabase.addImage(imageName, bitmap, physicalWidth)

                    if (index == -1) {
                        Log.e(TAG, "Failed to add image to database: $imageName")
                        success = false
                    }
                } else {
                    Log.e(TAG, "Failed to load bitmap for: $imagePath")
                    success = false
                }
            } catch (e: Exception) {
                success = false
                when (e.javaClass.simpleName) {
                    "ImageInsufficientQualityException" -> {
                        activity.runOnUiThread {
                            sessionManagerChannel.invokeMethod(
                                "onError",
                                listOf("Image '$imagePath' has insufficient quality for AR tracking. Use images with more visual features like high contrast, corners, and varied textures.")
                            )
                        }
                    }
                    else -> {
                        Log.e(TAG, "Error loading image $imagePath: ${e.message}")
                    }
                }
                e.printStackTrace()
            }
        }

        return Pair(imageDatabase, success)
    }

    private fun serializeImageDatabase(imageDatabase: AugmentedImageDatabase): ByteArray {
        val outputStream = ByteArrayOutputStream()
        imageDatabase.serialize(outputStream)
        return outputStream.toByteArray()
    }

    private fun setupImageTrackingAsync(imagePaths: List<String>) {
        val session = session ?: return
        imageTrackingExecutor.execute {
            try {
                val cacheKey = imageCacheKey(imagePaths)
                val cachedBytes = cachedImageDatabaseBytes[cacheKey]
                if (cachedBytes != null) {
                    activity.runOnUiThread {
                        try {
                            val config = session.config
                            val inputStream = ByteArrayInputStream(cachedBytes)
                            val imageDatabase = AugmentedImageDatabase.deserialize(session, inputStream)
                            config.augmentedImageDatabase = imageDatabase
                            session.configure(config)
                            imageTrackingEnabled = true
                            sessionManagerChannel.invokeMethod(
                                "onImageTrackingConfigured",
                                mapOf("success" to true, "cached" to true)
                            )
                        } catch (e: Exception) {
                            Log.e(TAG, "Error applying cached image database: ${e.message}")
                            sessionManagerChannel.invokeMethod(
                                "onError",
                                listOf("Error applying cached image database: ${e.message}")
                            )
                            sessionManagerChannel.invokeMethod(
                                "onImageTrackingConfigured",
                                mapOf("success" to false)
                            )
                        }
                    }
                    return@execute
                }

                val (imageDatabase, success) = buildImageDatabase(session, imagePaths)
                val bytes = serializeImageDatabase(imageDatabase)
                cachedImageDatabaseBytes[cacheKey] = bytes

                activity.runOnUiThread {
                    try {
                        val config = session.config
                        config.augmentedImageDatabase = imageDatabase
                        session.configure(config)
                        imageTrackingEnabled = true
                        sessionManagerChannel.invokeMethod(
                            "onImageTrackingConfigured",
                            mapOf("success" to success)
                        )
                    } catch (e: Exception) {
                        Log.e(TAG, "Error setting up image tracking: ${e.message}")
                        sessionManagerChannel.invokeMethod(
                            "onError",
                            listOf("Error setting up image tracking: ${e.message}")
                        )
                        sessionManagerChannel.invokeMethod(
                            "onImageTrackingConfigured",
                            mapOf("success" to false)
                        )
                    }
                }
            } catch (e: Exception) {
                activity.runOnUiThread {
                    Log.e(TAG, "Error setting up image tracking: ${e.message}")
                    sessionManagerChannel.invokeMethod(
                        "onError",
                        listOf("Error setting up image tracking: ${e.message}")
                    )
                    sessionManagerChannel.invokeMethod(
                        "onImageTrackingConfigured",
                        mapOf("success" to false)
                    )
                }
            }
        }
    }

    private fun handleArCoreFrame(frame: Frame) {
        currentFrame = frame
        handleQueuedTap(frame)
        onFrameUpdateListener?.invoke(frame.timestamp)

        val camera = frame.camera
        val cameraTrackingState = camera.trackingState
        val trackingFailureReason = if (cameraTrackingState == TrackingState.PAUSED) {
            camera.trackingFailureReason
        } else {
            com.google.ar.core.TrackingFailureReason.NONE
        }

        if (lastTrackingState != cameraTrackingState ||
            lastTrackingFailureReason != trackingFailureReason) {
            lastTrackingState = cameraTrackingState
            lastTrackingFailureReason = trackingFailureReason
            sessionManagerChannel.invokeMethod(
                "onTrackingState",
                mapOf(
                    "state" to cameraTrackingState.name,
                    "reason" to trackingFailureReason.name,
                ),
            )
        }

        if (showWorldOrigin) {
            val cameraTracking = frame.camera.trackingState == TrackingState.TRACKING
            if (cameraTracking) {
                stableTrackingFrames++
                nonTrackingFrames = 0
            } else {
                stableTrackingFrames = 0
                nonTrackingFrames++
                if (nonTrackingFrames >= nonTrackingResetThreshold) {
                    worldOriginAnchor?.detach()
                    worldOriginAnchor = null
                    lastWorldOriginMatrix = null
                }
            }

            if (worldOriginAnchor == null && stableTrackingFrames >= requiredStableTrackingFrames) {
                worldOriginAnchor = session?.createAnchor(Pose.IDENTITY)
            }
        }

        updateModelTransforms()
        onFrame(frame.timestamp)
    }

    private data class SimpleNode(
        val name: String,
        var transformation: ArrayList<Double>,
        val type: Int,
        val uri: String,
        var anchorName: String?,
        val worldLocked: Boolean = false,
    )

}


