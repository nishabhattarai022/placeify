package tech.graaf.franz.ar_flutter_plugin_plus

import android.app.Activity
import android.app.Application
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Rect
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.opengl.Matrix
import android.util.Log
import android.view.MotionEvent
import android.view.PixelCopy
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

        /** Log frozen-vs-live anchor delta every N frames (diagnostic). */
        private const val ANCHOR_DRIFT_LOG_INTERVAL_FRAMES = 30
        /** Fraction of live anchor pose blended per frame (2–5% avoids plane-refinement jitter). */
        private const val ANCHOR_RESYNC_ALPHA = 0.03f
        /** Faster catch-up when relocalization produces a large jump. */
        private const val ANCHOR_RESYNC_LARGE_DRIFT_ALPHA = 0.12f
        /** Positional delta below this is ignored (sub-millimeter noise). */
        private const val ANCHOR_RESYNC_MIN_DELTA_M = 0.002f
        /** Above this, treat as relocalization and use accelerated lerp. */
        private const val ANCHOR_RESYNC_LARGE_DELTA_M = 0.05f
        /** Require this many consecutive TRACKING frames before re-syncing. */
        private const val ANCHOR_RESYNC_STABLE_FRAMES_REQUIRED = 5
        /** Prefer planes at least this wide/deep for initial placement. */
        private const val MIN_PLACEMENT_PLANE_EXTENT_M = 0.15f
        /** Warn when placing before the session has this much stable tracking. */
        private const val PREFERRED_SESSION_STABLE_FRAMES_FOR_PLACEMENT = 15
        /** Min distance from a single wall plane surface while dragging (prevents half-in-wall). */
        private const val MIN_WALL_CLEARANCE_FACE_M = 0.12f
        /** Relaxed clearance at floor corners where two walls meet. */
        private const val MIN_WALL_CLEARANCE_CORNER_M = 0.04f
        /** Count vertical walls within this distance of the snap point as a corner. */
        private const val WALL_CORNER_DETECT_RANGE_M = 0.35f
        /** Polygon edge distance — diagnostics only (not used for drag rejection). */
        private const val MIN_PLANE_EDGE_MARGIN_M = 0.06f
        /** Max |plane.centerY - referenceFloorY| for a plane to be treated as the placement floor. */
        private const val MAX_DRAG_PLANE_HEIGHT_BAND_M = 0.15f
        /** Cap per-frame drag displacement; larger jumps are clamped instead of rejected. */
        private const val MAX_DRAG_JUMP_M = 0.25f
        /** Interpolation factor for smooth drag follow (higher = snappier). */
        private const val DRAG_SMOOTH_FACTOR = 0.45f
        /** Matches [ArFurnitureGestureConfig.rotationSensitivity] on Flutter. */
        private const val ROTATION_SENSITIVITY = 0.85f
        /** Matches [ArFurnitureGestureConfig.rotationSmoothFactor] on Flutter. */
        private const val ROTATION_SMOOTH_FACTOR = 0.52f
        /** Matches [ArFurnitureGestureConfig.rotationDeadZoneRadians] on Flutter. */
        private const val ROTATION_DEAD_ZONE_RADIANS = 0.004f
        /** Max horizontal world distance from hit to node center for twist start. */
        private const val ROTATION_HIT_MAX_HORIZONTAL_DISTANCE_M = 0.8f
        /** Screen-space fallback radius when plane hit test misses the model. */
        private const val ROTATION_SCREEN_HIT_RADIUS_PX = 220f
        /** Max floor distance (m) from a touch ray to a node for gesture targeting. */
        private const val GESTURE_HIT_MAX_HORIZONTAL_DISTANCE_M = 0.8f
        /**
         * Screen-space radius (px) for associating a touch with a node.
         * Large enough that tapping a chair backrest still hits the node whose
         * origin sits on the floor (feet project lower than the finger).
         */
        private const val GESTURE_SCREEN_HIT_RADIUS_PX = 280f
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
    private var pendingRotationDelta = 0f
    private var hasReportedPlaneDetection = false
    /// Y-height of the floor plane at initial placement; drag hits must stay within tolerance.
    private var referenceFloorY: Float? = null
    /// World pose at placement — defines the "room interior" side of vertical wall planes.
    private var placementInteriorPose: Pose? = null
    private val floorHeightToleranceM = 0.05f
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
    /** Consecutive TRACKING frames for the session (independent of showWorldOrigin). */
    private var sessionStableTrackingFrames = 0
    private val activeAugmentedImages: MutableSet<String> = mutableSetOf()
    private val lastAugmentedImageUpdateMs: MutableMap<String, Long> = mutableMapOf()
    private var continuousImageTracking = false
    private var imageTrackingUpdateIntervalMs: Long = 100

    private val nonTrackingResetThreshold = 30
    private val modelIoExecutor = Executors.newFixedThreadPool(2)
    private val imageTrackingExecutor = Executors.newSingleThreadExecutor()
    private var androidModelScaleFactor: Float = 1.0f
    // Setting defaults
    private var enableRotation = false
    private var enablePans = false

    // Logical scene state (ARCore-only, no rendering)
    private val nodesByName: MutableMap<String, SimpleNode> = mutableMapOf()
    private val anchorsByName: MutableMap<String, Anchor> = mutableMapOf()
    private val anchorChildren: MutableMap<String, MutableList<String>> = mutableMapOf()
    private val anchorTransformsByName: MutableMap<String, FloatArray> = mutableMapOf()
    /** Consecutive TRACKING frames per anchor before drift re-sync is applied. */
    private val anchorStableTrackingFrames: MutableMap<String, Int> = mutableMapOf()
    private var anchorDriftLogFrameCounter = 0

    private val scratchLiveAnchorMatrix = FloatArray(16)
    private val scratchNodeMatrix = FloatArray(16)
    private val scratchAnchorMatrix = FloatArray(16)
    private val scratchModelMatrix = FloatArray(16)
    private val scratchScaleMatrix = FloatArray(16)
    private val scratchScaledModelMatrix = FloatArray(16)
    private val scratchHitMatrix = FloatArray(16)
    private val scratchInvAnchor = FloatArray(16)
    private val scratchLocalMatrix = FloatArray(16)
    private val scratchGestureMatrix = FloatArray(16)
    private val scratchQFrozen = FloatArray(4)
    private val scratchQLive = FloatArray(4)
    private val scratchQBlended = FloatArray(4)
    private val scratchWorldPosition = FloatArray(3)
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
                        "setDepthOcclusionEnabled" -> {
                            val enabled = call.argument<Boolean>("enabled") == true
                            filamentRenderer.depthOcclusionEnabled = enabled
                            Log.d(TAG, "Depth occlusion rendering ${if (enabled) "enabled" else "disabled"} (runtime toggle)")
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
                        "hitTestNormalized" -> {
                            val frame = currentFrame
                            val width = textureView.width
                            val height = textureView.height
                            if (frame == null || width <= 0 || height <= 0) {
                                result.success(ArrayList<HashMap<String, Any>>())
                                return
                            }
                            val nx = (call.argument<Double>("x") ?: 0.5).toFloat()
                            val ny = (call.argument<Double>("y") ?: 0.5).toFloat()
                            result.success(
                                serializePlaneAndPointHits(
                                    frame.hitTest(width * nx, height * ny)
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
                            captureArSnapshot(result)
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
                            val targetHeight = call.argument<Double>("targetHeightMeters")
                            if (targetHeight != null && targetHeight > 0) {
                                filamentRenderer.setTargetHeightMeters(targetHeight.toFloat())
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

    private fun captureArSnapshot(result: MethodChannel.Result) {
        val view = textureView
        val width = view.width
        val height = view.height
        if (width <= 0 || height <= 0) {
            result.error("SNAPSHOT_FAILED", "View has invalid dimensions", null)
            return
        }
        view.post {
            val captured = view.bitmap
            if (captured != null) {
                sendJpegSnapshot(result, captured, width, height)
                return@post
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                val origin = IntArray(2)
                view.getLocationInWindow(origin)
                val rect =
                        Rect(
                                origin[0],
                                origin[1],
                                origin[0] + width,
                                origin[1] + height,
                        )
                PixelCopy.request(
                        activity.window,
                        rect,
                        bitmap,
                        { copyResult ->
                            if (copyResult == PixelCopy.SUCCESS) {
                                sendJpegSnapshotFromBitmap(result, bitmap)
                            } else {
                                bitmap.recycle()
                                result.error(
                                        "SNAPSHOT_FAILED",
                                        "PixelCopy result code: $copyResult",
                                        null,
                                )
                            }
                        },
                        Handler(Looper.getMainLooper()),
                )
            } else {
                result.error("SNAPSHOT_FAILED", "Could not read AR view bitmap", null)
            }
        }
    }

    private fun sendJpegSnapshot(
            result: MethodChannel.Result,
            captured: Bitmap,
            width: Int,
            height: Int,
    ) {
        try {
            val bitmap =
                    if (captured.width == width && captured.height == height) {
                        captured
                    } else {
                        Bitmap.createScaledBitmap(captured, width, height, true).also {
                            if (it !== captured) captured.recycle()
                        }
                    }
            sendJpegSnapshotFromBitmap(result, bitmap)
        } catch (e: Exception) {
            result.error("SNAPSHOT_FAILED", e.message, null)
        }
    }

    private fun sendJpegSnapshotFromBitmap(result: MethodChannel.Result, bitmap: Bitmap) {
        try {
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 85, stream)
            bitmap.recycle()
            result.success(stream.toByteArray())
        } catch (e: Exception) {
            result.error("SNAPSHOT_FAILED", e.message, null)
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
        config.depthMode = if (session!!.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
            Log.d(TAG, "ARCore AUTOMATIC depth available (rendering occlusion disabled by default)")
            Config.DepthMode.AUTOMATIC
        } else {
            Log.d(TAG, "ARCore depth not supported")
            Config.DepthMode.DISABLED
        }
        filamentRenderer.depthOcclusionEnabled = false
        config.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
        config.focusMode = Config.FocusMode.AUTO
        config.lightEstimationMode = Config.LightEstimationMode.ENVIRONMENTAL_HDR
        session!!.configure(config)
        configureBestCameraConfig(session!!)
        filamentRenderer.environmentalLightEstimationEnabled = true

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
     * Picks a 30 fps camera mode at or below 1280x720 to leave headroom for depth + Filament.
     */
    private fun configureBestCameraConfig(session: Session) {
        val maxWidth = 1280
        val maxHeight = 720
        try {
            val filter30 = CameraConfigFilter(session)
                .setTargetFps(EnumSet.of(CameraConfig.TargetFps.TARGET_FPS_30))
            val configs30 = session.getSupportedCameraConfigs(filter30)
            if (configs30.isEmpty()) {
                Log.w(TAG, "No 30fps camera configs available; using ARCore default")
                return
            }

            fun resolutionPixels(config: CameraConfig): Long {
                val size = config.imageSize
                return size.width.toLong() * size.height.toLong()
            }

            val withinCap = configs30.filter { config ->
                val size = config.imageSize
                size.width <= maxWidth && size.height <= maxHeight
            }

            val selected = withinCap.maxByOrNull(::resolutionPixels)
                ?: configs30.minByOrNull { config ->
                    val size = config.imageSize
                    kotlin.math.max(0, size.width - maxWidth) +
                        kotlin.math.max(0, size.height - maxHeight)
                }

            if (selected != null) {
                session.cameraConfig = selected
                val size = selected.imageSize
                Log.d(
                    TAG,
                    "AR camera config: ${size.width}x${size.height}, fps=${selected.fpsRange}, " +
                        "depthMode=${session.config.depthMode} (capped <= ${maxWidth}x$maxHeight @30fps)",
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
                targetHeightMeters = when (val raw = dict_node["targetHeightMeters"]) {
                    is Number -> raw.toFloat().takeIf { it.isFinite() && it > 0f }
                    else -> null
                },
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
                        filamentRenderer.loadGltf(
                            node.name,
                            gltfBytes,
                            resourceMap,
                            node.targetHeightMeters,
                        )
                    }
                    1 -> { // localGLB
                        val glbBytes = readFlutterAssetBytes(node.uri)
                        filamentRenderer.loadGlb(node.name, glbBytes, node.targetHeightMeters)
                    }
                    2 -> { // webGLB
                        val glbBytes = readUrlBytes(node.uri)
                        filamentRenderer.loadGlb(node.name, glbBytes, node.targetHeightMeters)
                    }
                    3 -> { // fileSystemAppFolderGLB
                        val glbBytes = readFileBytes(node.uri)
                        filamentRenderer.loadGlb(node.name, glbBytes, node.targetHeightMeters)
                    }
                    4 -> { // fileSystemAppFolderGLTF2
                        val gltfBytes = readFileBytes(node.uri)
                        val basePath = File(node.uri).parent ?: ""
                        val resourceMap = loadGltfResourcesFromFile(gltfBytes, basePath)
                        filamentRenderer.loadGltf(
                            node.name,
                            gltfBytes,
                            resourceMap,
                            node.targetHeightMeters,
                        )
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

    private fun translationDeltaM(a: FloatArray, b: FloatArray): Float {
        val dx = b[12] - a[12]
        val dy = b[13] - a[13]
        val dz = b[14] - a[14]
        return kotlin.math.sqrt(dx * dx + dy * dy + dz * dz)
    }

    /** Minimum distance from (px, pz) to the line segment (x1,z1)-(x2,z2) in the XZ plane. */
    private fun pointToSegmentDist(
        px: Float,
        pz: Float,
        x1: Float,
        z1: Float,
        x2: Float,
        z2: Float,
    ): Float {
        val dx = x2 - x1
        val dz = z2 - z1
        val lenSq = dx * dx + dz * dz
        if (lenSq < 1e-10f) {
            val dpx = px - x1
            val dpz = pz - z1
            return kotlin.math.sqrt(dpx * dpx + dpz * dpz)
        }
        var t = ((px - x1) * dx + (pz - z1) * dz) / lenSq
        t = t.coerceIn(0f, 1f)
        val projX = x1 + t * dx
        val projZ = z1 + t * dz
        val dpx = px - projX
        val dpz = pz - projZ
        return kotlin.math.sqrt(dpx * dpx + dpz * dpz)
    }

    /**
     * Distance from [hitPose] to the nearest edge of [plane]'s convex polygon,
     * measured in the plane's local XZ coordinates.
     */
    private fun distanceToPolygonEdge(plane: Plane, hitPose: Pose): Float {
        val localPose = plane.centerPose.inverse().compose(hitPose)
        val px = localPose.tx()
        val pz = localPose.tz()

        val polygon = plane.polygon
        val limit = polygon.limit()
        if (limit < 4) return Float.MAX_VALUE

        val vertexCount = limit / 2
        var minDist = Float.MAX_VALUE
        for (i in 0 until vertexCount) {
            val x1 = polygon.get(i * 2)
            val z1 = polygon.get(i * 2 + 1)
            val next = (i + 1) % vertexCount
            val x2 = polygon.get(next * 2)
            val z2 = polygon.get(next * 2 + 1)
            val dist = pointToSegmentDist(px, pz, x1, z1, x2, z2)
            if (dist < minDist) minDist = dist
        }
        return minDist
    }

    private fun isTrackingFloorPlane(plane: Plane): Boolean {
        return plane.type == Plane.Type.HORIZONTAL_UPWARD_FACING &&
            plane.trackingState == TrackingState.TRACKING
    }

    private fun planeHeightDeltaFromReference(plane: Plane, referenceFloorY: Float): Float {
        return kotlin.math.abs(plane.centerPose.ty() - referenceFloorY)
    }

    private fun snapPoseToReferenceFloorY(pose: Pose, referenceFloorY: Float): Pose {
        return Pose.makeTranslation(pose.tx(), referenceFloorY, pose.tz())
    }

    private fun findBestFloorPlaneForSnapPose(worldPose: Pose, referenceFloorY: Float): Plane? {
        val session = session ?: return null
        var bestPlane: Plane? = null
        var bestHeightDelta = Float.MAX_VALUE
        for (plane in session.getAllTrackables(Plane::class.java)) {
            if (!isTrackingFloorPlane(plane)) continue
            if (!plane.isPoseInPolygon(worldPose)) continue
            val heightDelta = planeHeightDeltaFromReference(plane, referenceFloorY)
            if (heightDelta < bestHeightDelta) {
                bestHeightDelta = heightDelta
                bestPlane = plane
            }
        }
        return if (bestHeightDelta <= MAX_DRAG_PLANE_HEIGHT_BAND_M) bestPlane else null
    }

    /** Signed distance along the plane normal (+Z for vertical walls, +Y for floor). */
    private fun signedDistanceToPlaneNormal(plane: Plane, worldPose: Pose): Float {
        val local = plane.centerPose.inverse().compose(worldPose)
        return when (plane.type) {
            Plane.Type.VERTICAL -> local.tz()
            Plane.Type.HORIZONTAL_UPWARD_FACING -> local.ty()
            else -> Float.MAX_VALUE
        }
    }

    private fun countNearbyVerticalWalls(snapPose: Pose, referenceFloorY: Float): Int {
        val session = session ?: return 0
        var count = 0
        for (trackable in session.getAllTrackables(Plane::class.java)) {
            val wall = trackable as? Plane ?: continue
            if (wall.type != Plane.Type.VERTICAL || wall.trackingState != TrackingState.TRACKING) {
                continue
            }
            if (kotlin.math.abs(snapPose.ty() - referenceFloorY) > MAX_DRAG_PLANE_HEIGHT_BAND_M) {
                continue
            }
            if (kotlin.math.abs(signedDistanceToPlaneNormal(wall, snapPose)) < WALL_CORNER_DETECT_RANGE_M) {
                count++
            }
        }
        return count
    }

    private fun requiredWallClearance(snapPose: Pose, referenceFloorY: Float): Float {
        return if (countNearbyVerticalWalls(snapPose, referenceFloorY) >= 2) {
            MIN_WALL_CLEARANCE_CORNER_M
        } else {
            MIN_WALL_CLEARANCE_FACE_M
        }
    }

    private fun hasTrackedVerticalWalls(): Boolean {
        val session = session ?: return false
        for (trackable in session.getAllTrackables(Plane::class.java)) {
            val wall = trackable as? Plane ?: continue
            if (wall.type == Plane.Type.VERTICAL && wall.trackingState == TrackingState.TRACKING) {
                return true
            }
        }
        return false
    }

    /**
     * Validates a drag snap pose: must lie on a reference-height floor plane and must not
     * cross or penetrate tracked vertical wall planes (corners use relaxed clearance).
     */
    private fun validateDragSnapPose(snapPose: Pose, referenceFloorY: Float): Boolean {
        val floorPlane = findBestFloorPlaneForSnapPose(snapPose, referenceFloorY) ?: return false

        if (!hasTrackedVerticalWalls()) {
            if (distanceToPolygonEdge(floorPlane, snapPose) <= MIN_PLANE_EDGE_MARGIN_M) {
                return false
            }
            return true
        }

        val interior = placementInteriorPose ?: return true
        val session = session ?: return true

        val clearance = requiredWallClearance(snapPose, referenceFloorY)
        for (trackable in session.getAllTrackables(Plane::class.java)) {
            val wall = trackable as? Plane ?: continue
            if (wall.type != Plane.Type.VERTICAL || wall.trackingState != TrackingState.TRACKING) {
                continue
            }
            if (kotlin.math.abs(snapPose.ty() - referenceFloorY) > MAX_DRAG_PLANE_HEIGHT_BAND_M) {
                continue
            }

            val snapDist = signedDistanceToPlaneNormal(wall, snapPose)
            val interiorDist = signedDistanceToPlaneNormal(wall, interior)
            if (snapDist * interiorDist < 0f) return false

            if (kotlin.math.abs(snapDist) < clearance) return false
        }
        return true
    }

    /** Returns [snapPose] when it passes floor and wall validation. */
    private fun acceptDragSnapPose(snapPose: Pose, referenceFloorY: Float): Pose? {
        return if (validateDragSnapPose(snapPose, referenceFloorY)) snapPose else null
    }

    /**
     * Picks the best floor hit for dragging — prefers planes whose center Y is closest to the
     * placement floor, among in-polygon hits within [MAX_DRAG_PLANE_HEIGHT_BAND_M].
     */
    private fun pickBestDragPlaneHit(hits: List<HitResult>, referenceFloorY: Float?): HitResult? {
        if (referenceFloorY == null) {
            return hits.firstOrNull { result ->
                val plane = result.trackable as? Plane ?: return@firstOrNull false
                isTrackingFloorPlane(plane) && plane.isPoseInPolygon(result.hitPose)
            }
        }

        data class Candidate(val hit: HitResult, val planeHeightDelta: Float, val edgeDist: Float)

        val candidates = hits.mapNotNull { result ->
            val plane = result.trackable as? Plane ?: return@mapNotNull null
            if (!isTrackingFloorPlane(plane)) return@mapNotNull null
            if (!plane.isPoseInPolygon(result.hitPose)) return@mapNotNull null
            val snapPose = snapPoseToReferenceFloorY(result.hitPose, referenceFloorY)
            if (!plane.isPoseInPolygon(snapPose)) return@mapNotNull null
            if (!validateDragSnapPose(snapPose, referenceFloorY)) return@mapNotNull null
            val edgeDist = distanceToPolygonEdge(plane, snapPose)
            Candidate(result, planeHeightDeltaFromReference(plane, referenceFloorY), edgeDist)
        }
        if (candidates.isEmpty()) return null

        val inBand = candidates.filter { it.planeHeightDelta <= MAX_DRAG_PLANE_HEIGHT_BAND_M }
        val pool = inBand.ifEmpty {
            listOf(candidates.minBy { it.planeHeightDelta })
        }
        return pool.maxWithOrNull(
            compareBy<Candidate> { it.planeHeightDelta }.thenByDescending { it.edgeDist },
        )?.hit
    }

    /** Uses in-polygon plane hit XZ snapped to the reference floor Y. */
    private fun fallbackSnapPoseFromPlaneHits(
        hits: List<HitResult>,
        referenceFloorY: Float,
    ): Pose? {
        data class PlaneSnap(val snapPose: Pose, val planeHeightDelta: Float, val edgeDist: Float)

        val snaps = hits.mapNotNull { result ->
            val plane = result.trackable as? Plane ?: return@mapNotNull null
            if (!isTrackingFloorPlane(plane)) return@mapNotNull null
            if (!plane.isPoseInPolygon(result.hitPose)) return@mapNotNull null
            val snapPose = snapPoseToReferenceFloorY(result.hitPose, referenceFloorY)
            if (!plane.isPoseInPolygon(snapPose)) return@mapNotNull null
            if (!validateDragSnapPose(snapPose, referenceFloorY)) return@mapNotNull null
            val edgeDist = distanceToPolygonEdge(plane, snapPose)
            PlaneSnap(snapPose, planeHeightDeltaFromReference(plane, referenceFloorY), edgeDist)
        }
        if (snaps.isEmpty()) return null

        val inBand = snaps.filter { it.planeHeightDelta <= MAX_DRAG_PLANE_HEIGHT_BAND_M }
        val pool = inBand.ifEmpty { listOf(snaps.minBy { it.planeHeightDelta }) }
        return pool.maxWithOrNull(
            compareBy<PlaneSnap> { it.planeHeightDelta }.thenByDescending { it.edgeDist },
        )?.snapPose
    }

    /**
     * When ARCore returns no direct floor hit (e.g. ray over open floor but hits an elevated plane
     * first), project the touch ray onto the reference floor Y and validate against tracked planes.
     */
    private fun fallbackSnapPoseFromRay(
        frame: Frame,
        screenX: Float,
        screenY: Float,
        referenceFloorY: Float,
    ): Pose? {
        val viewWidth = textureView.width
        val viewHeight = textureView.height
        if (viewWidth <= 0 || viewHeight <= 0) return null

        val rayPose = intersectScreenRayWithHorizontalPlane(
            frame,
            screenX,
            screenY,
            viewWidth,
            viewHeight,
            referenceFloorY,
        ) ?: return null

        return acceptDragSnapPose(rayPose, referenceFloorY)
    }

    /**
     * Fallback using feature/depth hit XZ snapped to the reference floor height.
     */
    private fun fallbackSnapPoseFromFeatureHits(
        hits: List<HitResult>,
        referenceFloorY: Float,
    ): Pose? {
        for (result in hits) {
            when (result.trackable) {
                is Point, is DepthPoint -> {
                    val snapPose = Pose.makeTranslation(
                        result.hitPose.tx(),
                        referenceFloorY,
                        result.hitPose.tz(),
                    )
                    acceptDragSnapPose(snapPose, referenceFloorY)?.let { return it }
                }
            }
        }
        return null
    }

    /** Intersects the camera ray through [screenX]/[screenY] with horizontal plane y=[planeY]. */
    private fun intersectScreenRayWithHorizontalPlane(
        frame: Frame,
        screenX: Float,
        screenY: Float,
        viewWidth: Int,
        viewHeight: Int,
        planeY: Float,
    ): Pose? {
        val camera = frame.camera
        val viewMatrix = FloatArray(16)
        val projMatrix = FloatArray(16)
        camera.getViewMatrix(viewMatrix, 0)
        camera.getProjectionMatrix(projMatrix, 0, 0.1f, 100f)

        val vpMatrix = FloatArray(16)
        Matrix.multiplyMM(vpMatrix, 0, projMatrix, 0, viewMatrix, 0)
        val invVp = FloatArray(16)
        if (!Matrix.invertM(invVp, 0, vpMatrix, 0)) return null

        val ndcX = (screenX / viewWidth) * 2f - 1f
        val ndcY = 1f - (screenY / viewHeight) * 2f

        fun unproject(ndcZ: Float): FloatArray {
            val ndc = floatArrayOf(ndcX, ndcY, ndcZ, 1f)
            val world = FloatArray(4)
            Matrix.multiplyMV(world, 0, invVp, 0, ndc, 0)
            if (kotlin.math.abs(world[3]) > 1e-6f) {
                world[0] /= world[3]
                world[1] /= world[3]
                world[2] /= world[3]
            }
            return world
        }

        val near = unproject(-1f)
        val far = unproject(1f)
        val dx = far[0] - near[0]
        val dy = far[1] - near[1]
        val dz = far[2] - near[2]
        if (kotlin.math.abs(dy) < 1e-6f) return null

        val t = (planeY - near[1]) / dy
        if (t < 0f) return null

        val hitX = near[0] + dx * t
        val hitZ = near[2] + dz * t
        return Pose.makeTranslation(hitX, planeY, hitZ)
    }

    /** Limits per-frame displacement and locks Y to the reference floor for anchored drags. */
    private fun finalizeDragHitPose(
        currentMatrix: FloatArray,
        hitPose: Pose,
        referenceFloorY: Float?,
    ): Pose {
        var pose = if (referenceFloorY != null) {
            snapPoseToReferenceFloorY(hitPose, referenceFloorY)
        } else {
            hitPose
        }

        pose.toMatrix(scratchHitMatrix, 0)
        val jumpM = translationDeltaM(currentMatrix, scratchHitMatrix)
        if (jumpM <= MAX_DRAG_JUMP_M) return pose

        val t = MAX_DRAG_JUMP_M / jumpM
        val cx = currentMatrix[12]
        val cy = currentMatrix[13]
        val cz = currentMatrix[14]
        val tx = scratchHitMatrix[12]
        val ty = scratchHitMatrix[13]
        val tz = scratchHitMatrix[14]
        val clampedX = cx + (tx - cx) * t
        val clampedY = referenceFloorY ?: (cy + (ty - cy) * t)
        val clampedZ = cz + (tz - cz) * t
        if (BuildConfig.DEBUG) {
            Log.d(
                TAG,
                "dragHit: clamped jump ${"%.3f".format(jumpM)}m -> ${"%.3f".format(MAX_DRAG_JUMP_M)}m",
            )
        }
        val clampedPose = Pose.makeTranslation(clampedX, clampedY, clampedZ)
        if (referenceFloorY != null && !validateDragSnapPose(clampedPose, referenceFloorY)) {
            return Pose.makeTranslation(cx, referenceFloorY, cz)
        }
        return clampedPose
    }

    private fun rotationMatrixToQuaternion(m: FloatArray, out: FloatArray) {
        val trace = m[0] + m[5] + m[10]
        when {
            trace > 0f -> {
                val s = kotlin.math.sqrt(trace + 1f) * 2f
                out[3] = 0.25f * s
                out[0] = (m[9] - m[6]) / s
                out[1] = (m[2] - m[8]) / s
                out[2] = (m[4] - m[1]) / s
            }
            m[0] > m[5] && m[0] > m[10] -> {
                val s = kotlin.math.sqrt(1f + m[0] - m[5] - m[10]) * 2f
                out[3] = (m[9] - m[6]) / s
                out[0] = 0.25f * s
                out[1] = (m[1] + m[4]) / s
                out[2] = (m[2] + m[8]) / s
            }
            m[5] > m[10] -> {
                val s = kotlin.math.sqrt(1f + m[5] - m[0] - m[10]) * 2f
                out[3] = (m[2] - m[8]) / s
                out[0] = (m[1] + m[4]) / s
                out[1] = 0.25f * s
                out[2] = (m[6] + m[9]) / s
            }
            else -> {
                val s = kotlin.math.sqrt(1f + m[10] - m[0] - m[5]) * 2f
                out[3] = (m[4] - m[1]) / s
                out[0] = (m[2] + m[8]) / s
                out[1] = (m[6] + m[9]) / s
                out[2] = 0.25f * s
            }
        }
        val length = kotlin.math.sqrt(out[0] * out[0] + out[1] * out[1] + out[2] * out[2] + out[3] * out[3])
        if (length > 0f) {
            out[0] /= length
            out[1] /= length
            out[2] /= length
            out[3] /= length
        }
    }

    private fun slerpQuaternion(a: FloatArray, b: FloatArray, t: Float, out: FloatArray) {
        var bx = b[0]
        var by = b[1]
        var bz = b[2]
        var bw = b[3]
        var dot = a[0] * bx + a[1] * by + a[2] * bz + a[3] * bw
        if (dot < 0f) {
            dot = -dot
            bx = -bx
            by = -by
            bz = -bz
            bw = -bw
        }
        if (dot > 0.9995f) {
            out[0] = a[0] + t * (bx - a[0])
            out[1] = a[1] + t * (by - a[1])
            out[2] = a[2] + t * (bz - a[2])
            out[3] = a[3] + t * (bw - a[3])
            val length = kotlin.math.sqrt(
                out[0] * out[0] + out[1] * out[1] + out[2] * out[2] + out[3] * out[3],
            )
            if (length > 0f) {
                out[0] /= length
                out[1] /= length
                out[2] /= length
                out[3] /= length
            }
            return
        }
        val theta0 = kotlin.math.acos(dot.coerceIn(-1f, 1f))
        val theta = theta0 * t
        val sinTheta = kotlin.math.sin(theta)
        val sinTheta0 = kotlin.math.sin(theta0)
        val s0 = kotlin.math.cos(theta) - dot * sinTheta / sinTheta0
        val s1 = sinTheta / sinTheta0
        out[0] = s0 * a[0] + s1 * bx
        out[1] = s0 * a[1] + s1 * by
        out[2] = s0 * a[2] + s1 * bz
        out[3] = s0 * a[3] + s1 * bw
    }

    private fun applyQuaternionToRotationMatrix(matrix: FloatArray, q: FloatArray) {
        val x = q[0]
        val y = q[1]
        val z = q[2]
        val w = q[3]
        matrix[0] = 1f - 2f * (y * y + z * z)
        matrix[1] = 2f * (x * y + z * w)
        matrix[2] = 2f * (x * z - y * w)
        matrix[4] = 2f * (x * y - z * w)
        matrix[5] = 1f - 2f * (x * x + z * z)
        matrix[6] = 2f * (y * z + x * w)
        matrix[8] = 2f * (x * z + y * w)
        matrix[9] = 2f * (y * z - x * w)
        matrix[10] = 1f - 2f * (x * x + y * y)
    }

    /** Slowly blend the frozen anchor matrix toward the live ARCore anchor pose. */
    private fun lerpAnchorTransformTowardLive(frozen: FloatArray, live: FloatArray, alpha: Float) {
        frozen[12] += (live[12] - frozen[12]) * alpha
        frozen[13] += (live[13] - frozen[13]) * alpha
        frozen[14] += (live[14] - frozen[14]) * alpha
        rotationMatrixToQuaternion(frozen, scratchQFrozen)
        rotationMatrixToQuaternion(live, scratchQLive)
        slerpQuaternion(scratchQFrozen, scratchQLive, alpha, scratchQBlended)
        applyQuaternionToRotationMatrix(frozen, scratchQBlended)
    }

    private fun logAnchorDriftDiagnostics() {
        if (anchorTransformsByName.isEmpty()) return
        anchorDriftLogFrameCounter++
        if (anchorDriftLogFrameCounter % ANCHOR_DRIFT_LOG_INTERVAL_FRAMES != 0) return

        for ((name, frozen) in anchorTransformsByName) {
            val anchor = anchorsByName[name]
            if (anchor == null) {
                Log.d(TAG, "AnchorDrift[$name]: anchor missing")
                continue
            }
            val tracking = anchor.trackingState
            if (tracking != TrackingState.TRACKING) {
                Log.d(
                    TAG,
                    "AnchorDrift[$name]: tracking=$tracking " +
                        "stableFrames=${anchorStableTrackingFrames[name] ?: 0}",
                )
                continue
            }
            anchor.pose.toMatrix(scratchLiveAnchorMatrix, 0)
            val dx = scratchLiveAnchorMatrix[12] - frozen[12]
            val dy = scratchLiveAnchorMatrix[13] - frozen[13]
            val dz = scratchLiveAnchorMatrix[14] - frozen[14]
            val deltaM = translationDeltaM(frozen, scratchLiveAnchorMatrix)
            Log.d(
                TAG,
                "AnchorDrift[$name]: delta=${"%.4f".format(deltaM)}m " +
                    "d=(${String.format("%.3f", dx)},${String.format("%.3f", dy)},${String.format("%.3f", dz)}) " +
                    "frozenY=${String.format("%.3f", frozen[13])} liveY=${String.format("%.3f", scratchLiveAnchorMatrix[13])} " +
                    "sessionStable=$sessionStableTrackingFrames " +
                    "anchorStable=${anchorStableTrackingFrames[name] ?: 0}",
            )
        }
    }

    /**
     * Re-sync frozen anchor transforms toward live [Anchor.pose] so relocalization
     * corrections are not opted out of. Uses confidence-gated exponential smoothing
     * to avoid the frame-to-frame jitter that motivated the original hard freeze.
     */
    private fun resyncFrozenAnchorsToLivePose() {
        if (anchorTransformsByName.isEmpty()) return

        var anyAnchorMoved = false
        for ((anchorName, frozen) in anchorTransformsByName) {
            val anchor = anchorsByName[anchorName] ?: continue
            when (anchor.trackingState) {
                TrackingState.TRACKING -> {
                    val stable = (anchorStableTrackingFrames[anchorName] ?: 0) + 1
                    anchorStableTrackingFrames[anchorName] = stable
                    if (stable < ANCHOR_RESYNC_STABLE_FRAMES_REQUIRED) continue

                    anchor.pose.toMatrix(scratchLiveAnchorMatrix, 0)
                    val deltaM = translationDeltaM(frozen, scratchLiveAnchorMatrix)
                    if (deltaM < ANCHOR_RESYNC_MIN_DELTA_M) continue

                    val alpha = if (deltaM >= ANCHOR_RESYNC_LARGE_DELTA_M) {
                        Log.i(
                            TAG,
                            "AnchorResync[$anchorName]: large drift ${"%.3f".format(deltaM)}m, " +
                                "accelerated lerp",
                        )
                        ANCHOR_RESYNC_LARGE_DRIFT_ALPHA
                    } else {
                        ANCHOR_RESYNC_ALPHA
                    }
                    lerpAnchorTransformTowardLive(frozen, scratchLiveAnchorMatrix, alpha)
                    anyAnchorMoved = true
                }
                else -> anchorStableTrackingFrames[anchorName] = 0
            }
        }

        if (anyAnchorMoved) {
            for ((_, childNodes) in anchorChildren) {
                childNodes.forEach { dirtyTransformNodes.add(it) }
            }
        }
    }

    private fun computeWorldMatrixForNode(node: SimpleNode): FloatArray {
        matrixFromTransform(node.transformation, scratchNodeMatrix)
        val anchorName = node.anchorName
        if (anchorName != null) {
            val stableAnchor = anchorTransformsByName[anchorName]
            if (stableAnchor != null) {
                System.arraycopy(stableAnchor, 0, scratchAnchorMatrix, 0, 16)
                Matrix.multiplyMM(scratchModelMatrix, 0, scratchAnchorMatrix, 0, scratchNodeMatrix, 0)
            } else {
                val anchor = anchorsByName[anchorName]
                if (anchor != null && anchor.trackingState == TrackingState.TRACKING) {
                    anchor.pose.toMatrix(scratchAnchorMatrix, 0)
                    Matrix.multiplyMM(scratchModelMatrix, 0, scratchAnchorMatrix, 0, scratchNodeMatrix, 0)
                } else {
                    System.arraycopy(scratchNodeMatrix, 0, scratchModelMatrix, 0, 16)
                }
            }
        } else {
            System.arraycopy(scratchNodeMatrix, 0, scratchModelMatrix, 0, 16)
        }
        return scratchModelMatrix
    }

    private fun updateModelTransforms() {
        if (nodesByName.isEmpty()) return

        // Recompute only when a node is dirty (gesture) or anchor re-sync marked it dirty.
        if (dirtyTransformNodes.isEmpty()) {
            return
        }

        val dirtyNames = dirtyTransformNodes.toList()
        dirtyNames.forEach { nodeName ->
            val node = nodesByName[nodeName] ?: return@forEach
            val modelMatrix = computeWorldMatrixForNode(node)
            cachedWorldMatrices[node.name] = modelMatrix.clone()

            val modelScaleFactor = getModelScaleFactor(node.type)
            if (modelScaleFactor != 1.0f) {
                Matrix.setIdentityM(scratchScaleMatrix, 0)
                Matrix.scaleM(scratchScaleMatrix, 0, modelScaleFactor, modelScaleFactor, modelScaleFactor)
                Matrix.multiplyMM(scratchScaledModelMatrix, 0, modelMatrix, 0, scratchScaleMatrix, 0)
                filamentRenderer.updateTransformIfChanged(node.name, scratchScaledModelMatrix)
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
                pendingRotationDelta = 0f

                // Target the anchored node under / nearest the touch — never the
                // camera-nearest node (that breaks multi-item drag/rotate).
                if (enablePans) {
                    val anchored = findNearestAnchoredNodeAtScreen(
                        frame,
                        motionEvent.x,
                        motionEvent.y,
                    )
                    if (anchored != null) {
                        activeGestureNodeName = anchored.name
                        panStartX = motionEvent.x
                        panStartY = motionEvent.y
                        panPending = true
                        // Select immediately so the next gesture / scale slider
                        // targets this node without waiting for touch-slop.
                        objectManagerChannel.invokeMethod(
                            "onNodeTap",
                            listOf(anchored.name),
                        )
                        return true
                    }
                }
                return false
            }
            MotionEvent.ACTION_POINTER_DOWN -> {
                if (!enableRotation || motionEvent.pointerCount < 2) {
                    return panPending || isPanning
                }
                cancelQueuedTap()
                cancelActivePanGesture()

                val midpoint = motionEventMidpoint(motionEvent) ?: return false
                try {
                    val anchored = findNearestAnchoredNodeAtScreen(
                        frame,
                        midpoint.x,
                        midpoint.y,
                    ) ?: return false
                    if (!isTwoFingerTouchNearNode(frame, motionEvent, anchored)) {
                        return panPending || isPanning
                    }

                    activeGestureNodeName = anchored.name
                    isRotating = true
                    isPanning = false
                    panPending = false
                    pendingRotationDelta = 0f
                    lastRotationAngle = rotationAngle(motionEvent)
                    objectManagerChannel.invokeMethod("onRotationStart", anchored.name)
                    return true
                } finally {
                    midpoint.recycle()
                }
            }
            MotionEvent.ACTION_MOVE -> {
                val nodeName = activeGestureNodeName

                if (panPending && enablePans && nodeName != null && motionEvent.pointerCount < 2) {
                    val dx = motionEvent.x - panStartX
                    val dy = motionEvent.y - panStartY
                    if (dx * dx + dy * dy > touchSlop * touchSlop) {
                        // Re-resolve at the current finger position so a slight
                        // slide onto a different chair doesn't keep the previous
                        // ACTION_DOWN target locked in.
                        val retargeted = findNearestAnchoredNodeAtScreen(
                            frame,
                            motionEvent.x,
                            motionEvent.y,
                        )
                        if (retargeted != null) {
                            activeGestureNodeName = retargeted.name
                        }
                        val activeName = activeGestureNodeName ?: return false
                        panPending = false
                        isPanning = true
                        cancelQueuedTap()
                        objectManagerChannel.invokeMethod("onPanStart", activeName)
                    } else {
                        return true
                    }
                }

                val activeName = activeGestureNodeName ?: return false
                val node = nodesByName[activeName] ?: return false

                if (isRotating && enableRotation && motionEvent.pointerCount >= 2) {
                    val currentAngle = rotationAngle(motionEvent)
                    var delta = normalizeAngleDelta(currentAngle - lastRotationAngle)
                    lastRotationAngle = currentAngle

                    applyRotationDelta(node, delta)
                    objectManagerChannel.invokeMethod("onRotationChange", node.name)
                    return true
                }

                if (isPanning && enablePans && motionEvent.pointerCount < 2) {
                    val hitPose = hitTestPlaneOrPoint(frame, motionEvent, node)
                    if (hitPose != null) {
                        moveNodeToPose(node, hitPose, smooth = true)
                    }
                    return true
                }
                return panPending || isRotating
            }
            MotionEvent.ACTION_POINTER_UP -> {
                if (isRotating && motionEvent.pointerCount - 1 < 2) {
                    finishRotationGesture()
                    return true
                }
                return panPending || isPanning || isRotating
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
                        flushPendingRotation(node)
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
                pendingRotationDelta = 0f
                return false
            }
            else -> return false
        }
    }

    private fun cancelActivePanGesture() {
        if (!isPanning && !panPending) return
        val nodeName = activeGestureNodeName
        if (isPanning && nodeName != null) {
            val node = nodesByName[nodeName]
            val transform = node?.transformation
            if (transform != null) {
                objectManagerChannel.invokeMethod(
                    "onPanEnd",
                    mapOf("name" to nodeName, "transform" to transform)
                )
            }
        }
        isPanning = false
        panPending = false
    }

    private fun finishRotationGesture() {
        val nodeName = activeGestureNodeName
        if (nodeName != null) {
            val node = nodesByName[nodeName]
            if (node != null) {
                flushPendingRotation(node)
                val transform = node.transformation
                objectManagerChannel.invokeMethod(
                    "onRotationEnd",
                    mapOf("name" to nodeName, "transform" to transform)
                )
            }
        }
        isRotating = false
        pendingRotationDelta = 0f
        lastRotationAngle = 0f
    }

    private fun isTwoFingerTouchNearNode(
        frame: Frame,
        motionEvent: MotionEvent,
        node: SimpleNode,
    ): Boolean {
        val midpoint = motionEventMidpoint(motionEvent) ?: return false
        try {
            val midX = midpoint.x
            val midY = midpoint.y
            val hits = frame.hitTest(midpoint)
            val floorY = referenceFloorY
            val viewWidth = textureView.width
            val viewHeight = textureView.height

            val hitPose = if (floorY != null && viewWidth > 0 && viewHeight > 0) {
                fallbackSnapPoseFromRay(frame, midX, midY, floorY)
                    ?: pickBestDragPlaneHit(hits, floorY)?.hitPose
                    ?: hits.firstOrNull()?.hitPose
            } else {
                hits.firstOrNull()?.hitPose
            }

            if (hitPose != null) {
                val nearest = findNearestNode(hitPose)
                if (nearest?.name == node.name) {
                    val pos = getNodeWorldPosition(node)
                    val dx = hitPose.tx() - pos[0]
                    val dz = hitPose.tz() - pos[2]
                    val horizontalDistSq = dx * dx + dz * dz
                    if (horizontalDistSq <=
                        ROTATION_HIT_MAX_HORIZONTAL_DISTANCE_M * ROTATION_HIT_MAX_HORIZONTAL_DISTANCE_M
                    ) {
                        return true
                    }
                }
            }

            val touchMidX = (motionEvent.getX(0) + motionEvent.getX(1)) / 2f
            val touchMidY = (motionEvent.getY(0) + motionEvent.getY(1)) / 2f
            val screenDist = minScreenDistanceToNode(frame, node, touchMidX, touchMidY)
                ?: return false
            return screenDist <=
                ROTATION_SCREEN_HIT_RADIUS_PX * ROTATION_SCREEN_HIT_RADIUS_PX
        } finally {
            midpoint.recycle()
        }
    }

    private fun projectWorldToScreen(frame: Frame, worldPos: FloatArray): FloatArray? {
        val viewWidth = textureView.width
        val viewHeight = textureView.height
        if (viewWidth <= 0 || viewHeight <= 0) return null

        val camera = frame.camera
        val viewMatrix = FloatArray(16)
        val projMatrix = FloatArray(16)
        camera.getViewMatrix(viewMatrix, 0)
        camera.getProjectionMatrix(projMatrix, 0, 0.1f, 100f)

        val vpMatrix = FloatArray(16)
        Matrix.multiplyMM(vpMatrix, 0, projMatrix, 0, viewMatrix, 0)

        val world = floatArrayOf(worldPos[0], worldPos[1], worldPos[2], 1f)
        val clip = FloatArray(4)
        Matrix.multiplyMV(clip, 0, vpMatrix, 0, world, 0)
        if (kotlin.math.abs(clip[3]) < 1e-6f) return null

        val ndcX = clip[0] / clip[3]
        val ndcY = clip[1] / clip[3]
        if (ndcX < -1f || ndcX > 1f || ndcY < -1f || ndcY > 1f) return null

        val screenX = (ndcX + 1f) * 0.5f * viewWidth
        val screenY = (1f - ndcY) * 0.5f * viewHeight
        return floatArrayOf(screenX, screenY)
    }

    private fun normalizeAngleDelta(delta: Float): Float {
        var normalized = delta
        if (normalized > Math.PI) normalized -= (2 * Math.PI).toFloat()
        if (normalized < -Math.PI) normalized += (2 * Math.PI).toFloat()
        return normalized
    }

    private fun applyRotationDelta(node: SimpleNode, deltaRadians: Float) {
        if (kotlin.math.abs(deltaRadians) < ROTATION_DEAD_ZONE_RADIANS) return
        pendingRotationDelta += deltaRadians * ROTATION_SENSITIVITY
        stepRotationSmoothing(node)
    }

    private fun stepActiveRotationSmoothing() {
        if (!isRotating) return
        val nodeName = activeGestureNodeName ?: return
        val node = nodesByName[nodeName] ?: return
        stepRotationSmoothing(node)
    }

  /** Applies pending twist each frame so rotation stays smooth between touch events. */
    private fun stepRotationSmoothing(node: SimpleNode) {
        if (kotlin.math.abs(pendingRotationDelta) < ROTATION_DEAD_ZONE_RADIANS) return
        val step = pendingRotationDelta * ROTATION_SMOOTH_FACTOR
        pendingRotationDelta -= step
        if (kotlin.math.abs(step) < ROTATION_DEAD_ZONE_RADIANS) return
        rotateNode(node, -step)
    }

    private fun flushPendingRotation(node: SimpleNode) {
        if (kotlin.math.abs(pendingRotationDelta) < ROTATION_DEAD_ZONE_RADIANS) {
            pendingRotationDelta = 0f
            return
        }
        rotateNode(node, -pendingRotationDelta)
        pendingRotationDelta = 0f
    }

    private fun hitTestPlaneOrPoint(
        frame: Frame,
        motionEvent: MotionEvent,
        node: SimpleNode,
    ): Pose? {
        val hitResults = frame.hitTest(motionEvent)
        val currentMatrix = computeWorldMatrixForNode(node)
        logDragHitDiagnostics(hitResults)

        val floorY = referenceFloorY
        var hitPose: Pose? = null
        if (floorY != null) {
            // Ray-to-floor first: works in open areas and room corners without polygon edge rejection.
            hitPose = fallbackSnapPoseFromRay(frame, motionEvent.x, motionEvent.y, floorY)
                ?: pickBestDragPlaneHit(hitResults, floorY)?.hitPose
                ?: fallbackSnapPoseFromPlaneHits(hitResults, floorY)
                ?: fallbackSnapPoseFromFeatureHits(hitResults, floorY)
        } else {
            hitPose = pickBestDragPlaneHit(hitResults, null)?.hitPose
        }

        if (hitPose == null) return null
        val finalPose = finalizeDragHitPose(currentMatrix, hitPose, floorY)
        if (floorY != null && !validateDragSnapPose(finalPose, floorY)) return null
        return finalPose
    }

    /**
     * Temporary diagnostic logging — remove after confirming wall-drag mechanism.
     * Logs every hit result during pan drags to verify seam polygon growth.
     */
    private fun logDragHitDiagnostics(hitResults: List<HitResult>) {
        if (!BuildConfig.DEBUG) return
        if (hitResults.isEmpty()) {
            Log.d(TAG, "dragHit: no hit results")
            return
        }
        val floorY = referenceFloorY
        hitResults.forEachIndexed { index, result ->
            val trackable = result.trackable
            val typeStr = when (trackable) {
                is Plane -> "Plane(${trackable.type})"
                is Point -> "Point"
                else -> trackable.javaClass.simpleName
            }
            val hitY = result.hitPose.ty()
            val stateStr = trackable.trackingState.name

            var extra = ""
            if (trackable is Plane) {
                val planeY = trackable.centerPose.ty()
                val deltaFromPlane = hitY - planeY
                extra += " planeY=$planeY hitDeltaFromPlane=$deltaFromPlane" +
                    " extentX=${trackable.extentX} extentZ=${trackable.extentZ}"
                if (floorY != null) {
                    extra += " deltaFromRefFloor=${hitY - floorY}"
                }

                val polygon = trackable.polygon
                val polyLimit = polygon.limit()
                if (polyLimit >= 6) {
                    var minX = Float.MAX_VALUE
                    var maxX = -Float.MAX_VALUE
                    var minZ = Float.MAX_VALUE
                    var maxZ = -Float.MAX_VALUE
                    for (i in 0 until polyLimit step 2) {
                        val px = polygon.get(i)
                        val pz = polygon.get(i + 1)
                        minX = minOf(minX, px)
                        maxX = maxOf(maxX, px)
                        minZ = minOf(minZ, pz)
                        maxZ = maxOf(maxZ, pz)
                    }
                    val spanX = maxX - minX
                    val spanZ = maxZ - minZ
                    extra += " polySpanX=$spanX polySpanZ=$spanZ polyVerts=${polyLimit / 2}"
                    if (kotlin.math.abs(deltaFromPlane) > 0.3f) {
                        extra += " ABNORMAL_HIT_DELTA"
                    }
                    if (spanX > 10f || spanZ > 10f) {
                        extra += " LARGE_POLYGON"
                    }
                }
            }

            val passesFloorPlane = trackable is Plane &&
                isTrackingFloorPlane(trackable) &&
                trackable.isPoseInPolygon(result.hitPose)
            val passesHeight = floorY == null ||
                kotlin.math.abs(hitY - floorY) < floorHeightToleranceM
            val planeHeightDelta = if (trackable is Plane && floorY != null) {
                planeHeightDeltaFromReference(trackable, floorY)
            } else {
                null
            }
            val passesPlaneHeightBand = planeHeightDelta == null ||
                planeHeightDelta <= MAX_DRAG_PLANE_HEIGHT_BAND_M
            var wallStr = ""
            if (floorY != null && trackable is Plane && isTrackingFloorPlane(trackable)) {
                val snapPose = snapPoseToReferenceFloorY(result.hitPose, floorY)
                val edgeDist = distanceToPolygonEdge(trackable, snapPose)
                val passesDrag = validateDragSnapPose(snapPose, floorY)
                val clearance = requiredWallClearance(snapPose, floorY)
                wallStr = " planeHeightDelta=${"%.3f".format(planeHeightDelta)}" +
                    " passesPlaneHeightBand=$passesPlaneHeightBand edgeDist=${"%.3f".format(edgeDist)}" +
                    " wallClearance=${"%.3f".format(clearance)} passesDrag=$passesDrag"
                if (!passesDrag) {
                    wallStr += " REJECTED_WALL_OR_FLOOR"
                }
            }
            Log.d(
                TAG,
                "dragHit[$index] type=$typeStr state=$stateStr hitY=$hitY" +
                    " passesFloorPlane=$passesFloorPlane passesHeight=$passesHeight$wallStr$extra",
            )
        }
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

    /**
     * Picks the anchored furniture node that a screen touch should control.
     *
     * Screen proximity wins over floor-ray distance: users tap the visible
     * mesh (seat/backrest), while the node origin sits on the floor. Preferring
     * the floor hit first made the previous chair steal the first gesture after
     * switching targets.
     */
    private fun findNearestAnchoredNodeAtScreen(
        frame: Frame,
        screenX: Float,
        screenY: Float,
    ): SimpleNode? {
        if (nodesByName.isEmpty()) return null

        var nearestScreen: SimpleNode? = null
        var minScreenDist = Float.MAX_VALUE
        val maxScreenSq = GESTURE_SCREEN_HIT_RADIUS_PX * GESTURE_SCREEN_HIT_RADIUS_PX
        for (node in nodesByName.values) {
            if (node.anchorName == null) continue
            val dist = minScreenDistanceToNode(frame, node, screenX, screenY) ?: continue
            if (dist <= maxScreenSq && dist < minScreenDist) {
                minScreenDist = dist
                nearestScreen = node
            }
        }
        if (nearestScreen != null) return nearestScreen

        val floorY = referenceFloorY
        val viewWidth = textureView.width
        val viewHeight = textureView.height
        val hitPose = if (floorY != null && viewWidth > 0 && viewHeight > 0) {
            val hits = frame.hitTest(screenX, screenY)
            fallbackSnapPoseFromRay(frame, screenX, screenY, floorY)
                ?: pickBestDragPlaneHit(hits, floorY)?.hitPose
                ?: hits.firstOrNull()?.hitPose
        } else {
            frame.hitTest(screenX, screenY).firstOrNull()?.hitPose
        } ?: return null

        var nearest: SimpleNode? = null
        var minDist = Float.MAX_VALUE
        val maxDistSq =
            GESTURE_HIT_MAX_HORIZONTAL_DISTANCE_M * GESTURE_HIT_MAX_HORIZONTAL_DISTANCE_M
        for (node in nodesByName.values) {
            if (node.anchorName == null) continue
            val pos = getNodeWorldPosition(node)
            val dx = pos[0] - hitPose.tx()
            val dz = pos[2] - hitPose.tz()
            val dist = dx * dx + dz * dz
            if (dist <= maxDistSq && dist < minDist) {
                minDist = dist
                nearest = node
            }
        }
        return nearest
    }

    /**
     * Squared screen distance from [screenX]/[screenY] to the closest of the
     * node's floor origin, mid-height, and near-top samples (catalog height when
     * known). Touching a tall chair's backrest still associates with that node.
     */
    private fun minScreenDistanceToNode(
        frame: Frame,
        node: SimpleNode,
        screenX: Float,
        screenY: Float,
    ): Float? {
        val origin = getNodeWorldPosition(node)
        val x = origin[0]
        val y = origin[1]
        val z = origin[2]
        val height = node.targetHeightMeters?.takeIf { it > 0.1f } ?: 0.75f
        val sampleYs = floatArrayOf(y, y + height * 0.45f, y + height * 0.85f)

        var minDist: Float? = null
        val sample = FloatArray(3)
        for (sampleY in sampleYs) {
            sample[0] = x
            sample[1] = sampleY
            sample[2] = z
            val screen = projectWorldToScreen(frame, sample) ?: continue
            val dx = screen[0] - screenX
            val dy = screen[1] - screenY
            val dist = dx * dx + dy * dy
            if (minDist == null || dist < minDist) {
                minDist = dist
            }
        }
        return minDist
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
        scratchWorldPosition[0] = modelMatrix[12]
        scratchWorldPosition[1] = modelMatrix[13]
        scratchWorldPosition[2] = modelMatrix[14]
        return scratchWorldPosition
    }

    private fun moveNodeToPose(node: SimpleNode, hitPose: Pose, smooth: Boolean = false) {
        hitPose.toMatrix(scratchHitMatrix, 0)

        val targetX: Double
        val targetY: Double
        val targetZ: Double

        if (node.anchorName != null) {
            val stableAnchorMatrix = anchorTransformsByName[node.anchorName]
            if (stableAnchorMatrix != null) {
                Matrix.invertM(scratchInvAnchor, 0, stableAnchorMatrix, 0)
                Matrix.multiplyMM(scratchLocalMatrix, 0, scratchInvAnchor, 0, scratchHitMatrix, 0)
                targetX = scratchLocalMatrix[12].toDouble()
                targetY = scratchLocalMatrix[13].toDouble()
                targetZ = scratchLocalMatrix[14].toDouble()
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

        val smoothFactor = if (smooth) DRAG_SMOOTH_FACTOR else 1.0f

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

        matrixFromTransform(transform, scratchGestureMatrix)
        val deltaDegrees = Math.toDegrees(deltaRadians.toDouble()).toFloat()
        Matrix.rotateM(scratchGestureMatrix, 0, deltaDegrees, 0f, 1f, 0f)

        val updated = ArrayList<Double>(16)
        for (i in 0 until 16) {
            updated.add(scratchGestureMatrix[i].toDouble())
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
                isTrackingFloorPlane(trackable) &&
                trackable.isPoseInPolygon(hit.hitPose)
        }
        if (planeHits.isEmpty()) {
            return hits.firstOrNull { hit ->
                val trackable = hit.trackable
                trackable is Point && trackable.trackingState == TrackingState.TRACKING
            }
        }

        val qualityPlanes = planeHits.filter { hit ->
            val plane = hit.trackable as Plane
            plane.extentX >= MIN_PLACEMENT_PLANE_EXTENT_M &&
                plane.extentZ >= MIN_PLACEMENT_PLANE_EXTENT_M
        }
        val candidates = qualityPlanes.ifEmpty {
            Log.w(
                TAG,
                "Placement: no plane >= ${MIN_PLACEMENT_PLANE_EXTENT_M}m extent; " +
                    "using closest of ${planeHits.size} smaller plane(s)",
            )
            planeHits
        }
        return candidates.minByOrNull { it.distance }
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
                val plane = hit.trackable as? Plane
                if (sessionStableTrackingFrames < PREFERRED_SESSION_STABLE_FRAMES_FOR_PLACEMENT) {
                    Log.w(
                        TAG,
                        "Placement with limited tracking convergence: " +
                            "sessionStable=$sessionStableTrackingFrames " +
                            "(prefer >= $PREFERRED_SESSION_STABLE_FRAMES_FOR_PLACEMENT)",
                    )
                }
                // Lock drag hit-testing to the floor height established at placement.
                referenceFloorY = hit.hitPose.ty()
                placementInteriorPose = hit.hitPose
                filamentRenderer.setReferenceFloorY(referenceFloorY)
                Log.d(
                    TAG,
                    "Placement anchor: hitY=${hit.hitPose.ty()} tx=${hit.hitPose.tx()} " +
                        "tz=${hit.hitPose.tz()} referenceFloorY=$referenceFloorY " +
                        "planeExtent=${plane?.extentX ?: 0f}x${plane?.extentZ ?: 0f} " +
                        "sessionStable=$sessionStableTrackingFrames " +
                        "depthMode=${session.config.depthMode}",
                )
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
            anchor.pose.toMatrix(scratchAnchorMatrix, 0)
            anchorTransformsByName[name] = scratchAnchorMatrix.clone()
            anchorStableTrackingFrames[name] = 0
            anchorDriftLogFrameCounter = 0
            Log.d(
                TAG,
                "Anchor placed[$name]: frozen at tx=${scratchAnchorMatrix[12]} ty=${scratchAnchorMatrix[13]} " +
                    "tz=${scratchAnchorMatrix[14]} sessionStable=$sessionStableTrackingFrames",
            )
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
        anchorStableTrackingFrames.remove(name)
        if (anchorsByName.isEmpty()) {
            referenceFloorY = null
            placementInteriorPose = null
            filamentRenderer.setReferenceFloorY(null)
        }
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

        if (cameraTrackingState == TrackingState.TRACKING) {
            sessionStableTrackingFrames++
        } else {
            sessionStableTrackingFrames = 0
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

        logAnchorDriftDiagnostics()
        resyncFrozenAnchorsToLivePose()
        stepActiveRotationSmoothing()
        updateModelTransforms()
    }

    private data class SimpleNode(
        val name: String,
        var transformation: ArrayList<Double>,
        val type: Int,
        val uri: String,
        var anchorName: String?,
        val worldLocked: Boolean = false,
        val targetHeightMeters: Float? = null,
    )

}


