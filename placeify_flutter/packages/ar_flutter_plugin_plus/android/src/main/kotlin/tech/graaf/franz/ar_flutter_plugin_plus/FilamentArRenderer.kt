package tech.graaf.franz.ar_flutter_plugin_plus

import android.content.Context
import android.opengl.Matrix as GlMatrix
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import android.view.Choreographer
import android.view.Surface
import android.view.TextureView
import com.google.android.filament.*
import com.google.android.filament.android.UiHelper
import com.google.android.filament.gltfio.AssetLoader
import com.google.android.filament.gltfio.FilamentAsset
import com.google.android.filament.gltfio.Gltfio
import com.google.android.filament.gltfio.MaterialProvider
import com.google.android.filament.gltfio.ResourceLoader
import com.google.android.filament.gltfio.UbershaderProvider
import com.google.ar.core.Frame
import com.google.ar.core.LightEstimate
import com.google.ar.core.Session
import com.google.ar.core.exceptions.CameraNotAvailableException
import com.google.ar.core.exceptions.MissingGlContextException
import com.google.ar.core.exceptions.NotYetAvailableException
import com.google.ar.core.exceptions.SessionPausedException
import java.nio.ByteBuffer

/**
 * Unified Filament renderer: ARCore camera background and GLB furniture in one render loop.
 *
 * [session.update], camera matrix updates, and [Renderer.beginFrame]/[Renderer.render] all run
 * in the same Choreographer frame callback on the main thread.
 */
internal class FilamentArRenderer(
    private val context: Context,
    private val textureView: TextureView,
    private val sessionProvider: () -> Session?,
    private val isSessionResumed: () -> Boolean,
    private val onFrameAvailable: (Frame) -> Unit,
    private val onDisplayGeometryChanged: (rotation: Int, width: Int, height: Int) -> Unit,
) {
    private val tag = "FilamentArRenderer"
    private val mainHandler = Handler(Looper.getMainLooper())

    private var choreographer: Choreographer? = null
    private var frameScheduled = false
    private val frameCallback = Choreographer.FrameCallback { frameTimeNanos ->
        frameScheduled = false
        renderFrame(frameTimeNanos)
        scheduleNextFrame()
    }

    private var engine: Engine? = null
    private var renderer: Renderer? = null
    private var view: View? = null
    private var scene: Scene? = null
    private var camera: Camera? = null
    private var swapChain: SwapChain? = null
    private var swapChainSurface: Surface? = null
    private var uiHelper: UiHelper? = null
    private var sharedEglContext: SharedEglContext? = null

    private var cameraBackground: CameraBackgroundRenderer? = null
    private var engineInitFailed = false
    private var lastSessionUpdateErrorLogMs = 0L
    private var consecutiveSessionUpdateFailures = 0

    private var viewportWidth = 0
    private var viewportHeight = 0
    private var lastRotation = -1
    private var lastDisplayWidth = 0
    private var lastDisplayHeight = 0

    private var lightEntity = 0
    private var fillLightEntity = 0
    private var indirectLight: IndirectLight? = null
    private var lightIntensityMultiplier = 1.0f
    private var environmentLightScale = 1.0f
    private var shadowCatcher: ShadowCatcherRenderer? = null
    private var shadowsEnabled = false
    private var referenceFloorY: Float? = null
  /** When > 0, GLB height is normalized to this catalog size (meters), matching iOS. */
    private var targetHeightMeters: Float = 0f
    private val modelWorldCenters: MutableMap<String, FloatArray> = mutableMapOf()
    var environmentalLightEstimationEnabled = false
    var depthOcclusionEnabled = false
        set(value) {
            field = value
            cameraBackground?.depthOcclusionEnabled = value
        }
    private var lightingConfigured = false
    private var cameraDiagnosticLogged = false

    private val scratchViewMatrix = FloatArray(16)
    private val scratchProjectionMatrix = FloatArray(16)
    private val scratchInverseView = FloatArray(16)
    private val scratchProjectionDouble = DoubleArray(16)
    private val scratchComposedTransform = FloatArray(16)

    private var materialProvider: MaterialProvider? = null
    private var assetLoader: AssetLoader? = null
    private var resourceLoader: ResourceLoader? = null

    private val modelAssets: MutableMap<String, FilamentAsset> = mutableMapOf()
    private val pendingTransforms: MutableMap<String, FloatArray> = mutableMapOf()
    private val lastSentTransforms: MutableMap<String, FloatArray> = mutableMapOf()
    private val rootOffsetCorrections: MutableMap<String, FloatArray> = mutableMapOf()

    private var isAttached = false
    private var isPaused = false

    init {
        setupUiHelper()
    }

    fun attach() {
        if (isAttached) return
        if (engineInitFailed) {
            Log.e(tag, "Cannot attach: Filament engine failed to initialize")
            return
        }
        isAttached = true
        isPaused = false
        ensureEngine()
        if (engine == null) {
            isAttached = false
            return
        }
        uiHelper?.attachTo(textureView)
        scheduleNextFrame()
    }

    fun detach() {
        isPaused = true
        choreographer?.removeFrameCallback(frameCallback)
        frameScheduled = false
        uiHelper?.detach()
        isAttached = false
    }

    fun setReferenceFloorY(floorY: Float?) {
        referenceFloorY = floorY
        mainHandler.post { recomputeShadowCatcher() }
    }

    fun setTargetHeightMeters(heightMeters: Float) {
        targetHeightMeters = if (heightMeters.isFinite() && heightMeters > 0f) {
            heightMeters
        } else {
            0f
        }
    }

    fun setLightIntensityMultiplier(multiplier: Float) {
        val clamped = if (multiplier.isFinite()) multiplier else 1.0f
        lightIntensityMultiplier = if (clamped <= 0f) 0.01f else clamped
        lightingConfigured = false
        mainHandler.post {
            engine?.let { setupStudioLighting(it) }
        }
    }

    fun loadGlb(name: String, data: ByteArray) {
        mainHandler.post {
            val assetLoader = assetLoader ?: return@post
            val resourceLoader = resourceLoader ?: return@post
            val scene = scene ?: return@post

            val buffer = ByteBuffer.allocateDirect(data.size)
            buffer.put(data)
            buffer.flip()

            val asset = assetLoader.createAsset(buffer)
            if (asset == null) {
                Log.e(tag, "Failed to create GLB asset for $name")
                return@post
            }
            resourceLoader.loadResources(asset)
            asset.releaseSourceData()
            snapModelBottomToOrigin(name, asset)
            configureRenderableMaterials(asset)
            scene.addEntities(asset.entities)
            modelAssets[name] = asset
            pendingTransforms[name]?.let { transform ->
                applyTransform(name, asset, transform)
                modelWorldCenters[name] = floatArrayOf(
                    transform[12],
                    transform[13],
                    transform[14],
                )
            }
            recomputeShadowCatcher()
            val correction = rootOffsetCorrections[name]
            Log.d(
                tag,
                "Loaded GLB $name (${asset.entities.size} entities) " +
                    "rootOffsetY=${correction?.let { it[13] } ?: 0f}",
            )
        }
    }

    fun loadGltf(name: String, json: ByteArray, resources: Map<String, ByteArray>) {
        mainHandler.post {
            val assetLoader = assetLoader ?: return@post
            val resourceLoader = resourceLoader ?: return@post
            val scene = scene ?: return@post

            val jsonBuffer = ByteBuffer.allocateDirect(json.size)
            jsonBuffer.put(json)
            jsonBuffer.flip()

            val asset = assetLoader.createAsset(jsonBuffer) ?: return@post

            for ((uri, bytes) in resources) {
                val resBuffer = ByteBuffer.allocateDirect(bytes.size)
                resBuffer.put(bytes)
                resBuffer.flip()
                resourceLoader.addResourceData(uri, resBuffer)
            }

            resourceLoader.loadResources(asset)
            resourceLoader.evictResourceData()
            asset.releaseSourceData()
            snapModelBottomToOrigin(name, asset)
            configureRenderableMaterials(asset)
            scene.addEntities(asset.entities)
            modelAssets[name] = asset
            pendingTransforms[name]?.let { transform ->
                applyTransform(name, asset, transform)
                modelWorldCenters[name] = floatArrayOf(
                    transform[12],
                    transform[13],
                    transform[14],
                )
            }
            recomputeShadowCatcher()
        }
    }

    fun updateTransform(name: String, modelMatrix: FloatArray) {
        val matrixCopy = modelMatrix.clone()
        mainHandler.post {
            pendingTransforms[name] = matrixCopy
            modelWorldCenters[name] = floatArrayOf(
                matrixCopy[12],
                matrixCopy[13],
                matrixCopy[14],
            )
            val asset = modelAssets[name] ?: return@post
            applyTransform(name, asset, matrixCopy)
            recomputeShadowCatcher()
        }
    }

    fun updateTransformIfChanged(name: String, modelMatrix: FloatArray) {
        val last = lastSentTransforms[name]
        if (last != null && matricesApproximatelyEqual(last, modelMatrix)) {
            return
        }
        lastSentTransforms[name] = modelMatrix.clone()
        updateTransform(name, modelMatrix)
    }

    fun removeModel(name: String) {
        mainHandler.post {
            val scene = scene ?: return@post
            val asset = modelAssets.remove(name) ?: return@post
            scene.removeEntities(asset.entities)
            assetLoader?.destroyAsset(asset)
            pendingTransforms.remove(name)
            lastSentTransforms.remove(name)
            rootOffsetCorrections.remove(name)
            modelWorldCenters.remove(name)
            recomputeShadowCatcher()
        }
    }

    fun destroy() {
        mainHandler.post {
            detach()
            choreographer?.removeFrameCallback(frameCallback)
            frameScheduled = false

            uiHelper?.detach()
            uiHelper = null

            val engine = engine ?: return@post

            cameraBackground?.destroy()
            cameraBackground = null

            modelAssets.values.forEach { asset ->
                scene?.removeEntities(asset.entities)
                assetLoader?.destroyAsset(asset)
            }
            modelAssets.clear()
            rootOffsetCorrections.clear()
            pendingTransforms.clear()
            lastSentTransforms.clear()
            modelWorldCenters.clear()
            referenceFloorY = null

            shadowCatcher?.destroy()
            shadowCatcher = null
            shadowsEnabled = false

            resourceLoader?.destroy()
            assetLoader?.destroy()
            materialProvider?.destroy()

            renderer?.let { engine.destroyRenderer(it) }
            view?.let { engine.destroyView(it) }
            scene?.let { engine.destroyScene(it) }
            camera?.let { engine.destroyCameraComponent(it.entity) }
            if (lightEntity != 0) {
                engine.destroyEntity(lightEntity)
                lightEntity = 0
            }
            if (fillLightEntity != 0) {
                engine.destroyEntity(fillLightEntity)
                fillLightEntity = 0
            }
            indirectLight?.let { engine.destroyIndirectLight(it) }
            indirectLight = null
            destroySwapChain()

            engine.destroy()

            sharedEglContext?.destroy()
            sharedEglContext = null

            this.engine = null
            renderer = null
            view = null
            scene = null
            camera = null
            materialProvider = null
            assetLoader = null
            resourceLoader = null
            lightingConfigured = false
            arCameraTextureIds = null
            engineInitFailed = false
            consecutiveSessionUpdateFailures = 0
        }
    }

    fun bindSession(session: Session) {
        pendingSession = session
        try {
            cameraBackground?.bindSession(session)
        } catch (e: Exception) {
            Log.e(tag, "Failed to bind ARCore session to camera textures", e)
        }
    }

    private var pendingSession: Session? = null

    private fun ensureCameraBackground(engine: Engine, scene: Scene) {
        if (cameraBackground != null) return
        val textureIds = arCameraTextureIds ?: run {
            Log.e(tag, "Camera texture ids missing; engine init incomplete")
            return
        }
        try {
            cameraBackground = CameraBackgroundRenderer(context, engine, scene, textureIds).apply {
                depthOcclusionEnabled = this@FilamentArRenderer.depthOcclusionEnabled
            }
            pendingSession?.let { session ->
                cameraBackground?.bindSession(session)
            }
            Log.d(tag, "Camera background ready")
        } catch (e: Exception) {
            Log.e(tag, "Failed to create camera background renderer", e)
            cameraBackground = null
        }
    }

    private var arCameraTextureIds: IntArray? = null

    private fun setupUiHelper() {
        uiHelper = UiHelper(UiHelper.ContextErrorPolicy.DONT_CHECK).apply {
            isOpaque = true
            setRenderCallback(object : UiHelper.RendererCallback {
                override fun onNativeWindowChanged(surface: Surface) {
                    if (engine == null) return
                    createSwapChainIfNeeded(surface)
                    scheduleNextFrame()
                }

                override fun onDetachedFromSurface() {
                    destroySwapChain()
                    engine?.flushAndWait()
                }

                override fun onResized(width: Int, height: Int) {
                    viewportWidth = width
                    viewportHeight = height
                    view?.viewport = Viewport(0, 0, width, height)
                    applyDisplayGeometryIfNeeded(width, height)
                    scheduleNextFrame()
                }
            })
        }
    }

    private fun scheduleNextFrame() {
        if (isPaused || !isAttached || frameScheduled) return
        frameScheduled = true

        val existing = choreographer
        if (existing != null) {
            existing.postFrameCallback(frameCallback)
            return
        }

        val instance = Choreographer.getInstance()
        choreographer = instance
        instance.postFrameCallback(frameCallback)
    }

    private fun renderFrame(frameTimeNanos: Long) {
        if (engineInitFailed || engine == null) {
            return
        }

        if (uiHelper?.isReadyToRender != true) {
            scheduleNextFrame()
            return
        }

        val renderer = renderer ?: return
        val view = this.view ?: return
        val swapChain = this.swapChain ?: return
        val camera = this.camera ?: return
        val session = sessionProvider() ?: return

        if (!isSessionResumed()) {
            scheduleNextFrame()
            return
        }

        if (viewportWidth <= 0 || viewportHeight <= 0) {
            val width = textureView.width
            val height = textureView.height
            if (width > 0 && height > 0) {
                viewportWidth = width
                viewportHeight = height
                view.viewport = Viewport(0, 0, width, height)
                applyDisplayGeometryIfNeeded(width, height)
            } else {
                scheduleNextFrame()
                return
            }
        } else {
            applyDisplayGeometryIfNeeded(viewportWidth, viewportHeight)
        }

        val engine = engine ?: return
        val scene = scene ?: return
        if (cameraBackground == null) {
            ensureCameraBackground(engine, scene)
            if (cameraBackground == null) {
                scheduleNextFrame()
                return
            }
        }

        val frame = try {
            session.update().also {
                consecutiveSessionUpdateFailures = 0
            }
        } catch (e: SessionPausedException) {
            scheduleNextFrame()
            return
        } catch (e: NotYetAvailableException) {
            scheduleNextFrame()
            return
        } catch (e: CameraNotAvailableException) {
            logSessionUpdateFailure(e)
            scheduleNextFrame()
            return
        } catch (e: MissingGlContextException) {
            logSessionUpdateFailure(e)
            scheduleNextFrame()
            return
        } catch (e: Exception) {
            logSessionUpdateFailure(e)
            scheduleNextFrame()
            return
        }

        val arCamera = frame.camera
        arCamera.getViewMatrix(scratchViewMatrix, 0)
        arCamera.getProjectionMatrix(scratchProjectionMatrix, 0, 0.1f, 100.0f)

        GlMatrix.invertM(scratchInverseView, 0, scratchViewMatrix, 0)
        camera.setModelMatrix(scratchInverseView)

        for (i in 0 until 16) {
            scratchProjectionDouble[i] = scratchProjectionMatrix[i].toDouble()
        }
        camera.setCustomProjection(scratchProjectionDouble, 0.1, 100.0)

        logCameraDiagnosticsIfNeeded(arCamera, scratchProjectionMatrix)

        cameraBackground?.update(frame)

        updateEnvironmentalLightEstimate(frame)

        // Present using the ARCore capture timestamp so the camera image and display stay in sync.
        val presentTimeNanos = frame.timestamp
        val beganFrame = when {
            presentTimeNanos > 0L && renderer.beginFrame(swapChain, presentTimeNanos) -> true
            renderer.beginFrame(swapChain, frameTimeNanos) -> true
            else -> false
        }

        if (beganFrame) {
            renderer.render(view)
            renderer.endFrame()
        } else {
            logDroppedRenderFrame()
        }

        // Run tracking / plane / channel work after present to keep the camera path fast.
        onFrameAvailable(frame)
    }

    private var lastDroppedFrameLogMs = 0L
    private var droppedRenderFrames = 0L

    private fun logDroppedRenderFrame() {
        droppedRenderFrames++
        val now = SystemClock.uptimeMillis()
        if (now - lastDroppedFrameLogMs < 3_000L) return
        lastDroppedFrameLogMs = now
        Log.w(tag, "Filament beginFrame dropped (count=$droppedRenderFrames)")
    }

    private fun logSessionUpdateFailure(error: Exception) {
        consecutiveSessionUpdateFailures++
        val now = SystemClock.uptimeMillis()
        if (now - lastSessionUpdateErrorLogMs < 2_000L && consecutiveSessionUpdateFailures > 1) {
            return
        }
        lastSessionUpdateErrorLogMs = now
        Log.e(
            tag,
            "session.update failed (${error.javaClass.simpleName}, " +
                "consecutive=$consecutiveSessionUpdateFailures): ${error.message}",
            error,
        )
    }

    private fun applyDisplayGeometryIfNeeded(width: Int, height: Int) {
        if (width <= 0 || height <= 0) return
        val rotation = textureView.display?.rotation ?: 0
        if (lastRotation != rotation ||
            lastDisplayWidth != width ||
            lastDisplayHeight != height
        ) {
            lastRotation = rotation
            lastDisplayWidth = width
            lastDisplayHeight = height
            onDisplayGeometryChanged(rotation, width, height)
        }
    }

    private fun createSwapChainIfNeeded(surface: Surface) {
        val engine = engine ?: return
        val helper = uiHelper ?: return
        if (swapChain != null && swapChainSurface === surface) return
        swapChain?.let { engine.destroySwapChain(it) }
        swapChain = engine.createSwapChain(surface, helper.swapChainFlags)
        swapChainSurface = surface
    }

    private fun destroySwapChain() {
        val engine = engine ?: return
        swapChain?.let { engine.destroySwapChain(it) }
        swapChain = null
        swapChainSurface = null
    }

    private fun ensureEngine() {
        if (engine != null || engineInitFailed) return

        Filament.init()
        Gltfio.init()

        val eglContext = try {
            SharedEglContext.create()
        } catch (e: Exception) {
            Log.e(tag, "Failed to create shared EGL context for ARCore + Filament", e)
            engineInitFailed = true
            return
        }
        sharedEglContext = eglContext

        val textureIds = try {
            OpenGL.createExternalTextureIds(CameraBackgroundRenderer.TEXTURE_COUNT)
        } catch (e: Exception) {
            Log.e(tag, "Failed to allocate ARCore external camera textures", e)
            sharedEglContext?.destroy()
            sharedEglContext = null
            engineInitFailed = true
            return
        }
        arCameraTextureIds = textureIds

        val createdEngine = try {
            Engine.Builder()
                .sharedContext(eglContext.eglContext)
                .build()
        } catch (e: Exception) {
            Log.e(tag, "Failed to create Filament engine with shared GL context", e)
            sharedEglContext?.destroy()
            sharedEglContext = null
            arCameraTextureIds = null
            engineInitFailed = true
            return
        }

        engine = createdEngine
        renderer = createdEngine.createRenderer()
        renderer!!.clearOptions = Renderer.ClearOptions().apply {
            clear = true
            clearColor = floatArrayOf(0f, 0f, 0f, 1f)
        }
        scene = createdEngine.createScene()
        view = createdEngine.createView()
        camera = createdEngine.createCamera(EntityManager.get().create())

        materialProvider = UbershaderProvider(createdEngine)
        assetLoader = AssetLoader(createdEngine, materialProvider!!, EntityManager.get())
        resourceLoader = ResourceLoader(createdEngine)

        view!!.scene = scene
        view!!.camera = camera
        view!!.blendMode = View.BlendMode.OPAQUE
        view!!.isPostProcessingEnabled = true
        view!!.colorGrading = ColorGrading.Builder()
            .toneMapping(ColorGrading.ToneMapping.FILMIC)
            .exposure(0.98f)
            .build(createdEngine)

        setupStudioLighting(createdEngine)
        ensureCameraBackground(createdEngine, scene!!)
    }

    fun updateEnvironmentalLightEstimate(frame: Frame) {
        if (!environmentalLightEstimationEnabled) return
        val engine = engine ?: return

        val estimate = frame.lightEstimate
        val newScale = if (estimate.state == LightEstimate.State.VALID) {
            (estimate.pixelIntensity / 0.5f).coerceIn(0.50f, 1.25f)
        } else {
            1.0f
        }
        if (kotlin.math.abs(newScale - environmentLightScale) < 0.02f) return
        environmentLightScale = newScale
        applyDirectionalLightIntensities(engine)
        updateShadowAppearance()
    }

    private fun updateShadowAppearance() {
        val scale = environmentLightScale.coerceIn(0.50f, 1.25f)
        // Brighter scenes get slightly stronger contact shadows; dim rooms stay soft.
        val normalized = ((scale - 0.50f) / (1.25f - 0.50f)).coerceIn(0f, 1f)
        val alpha = 0.24f + normalized * 0.34f
        shadowCatcher?.setShadowAlpha(alpha)
    }

    private fun createKeyLightShadowOptions(normalizedLight: Float): LightManager.ShadowOptions {
        return LightManager.ShadowOptions().apply {
            mapSize = 1024
            constantBias = 0.0005f
            normalBias = 0.8f + (1f - normalizedLight) * 0.9f
            shadowFar = 18f
        }
    }

    private fun effectiveLightScale(): Float = lightIntensityMultiplier * environmentLightScale

    private fun applyDirectionalLightIntensities(engine: Engine) {
        if (lightEntity == 0 && fillLightEntity == 0) return
        val scale = effectiveLightScale()
        val lightManager = engine.lightManager
        lightManager.getInstance(lightEntity).takeIf { it != 0 }?.let { key ->
            lightManager.setIntensity(key, 55_000.0f * scale)
        }
        lightManager.getInstance(fillLightEntity).takeIf { it != 0 }?.let { fill ->
            lightManager.setIntensity(fill, 25_000.0f * scale)
        }
        indirectLight?.let { engine.destroyIndirectLight(it) }
        indirectLight = IndirectLight.Builder()
            .irradiance(3, neutralStudioSh())
            .intensity(22_000.0f * scale)
            .build(engine)
        scene?.indirectLight = indirectLight
    }

    private fun setupStudioLighting(engine: Engine) {
        if (lightingConfigured) return

        if (lightEntity == 0) {
            val normalizedLight = ((environmentLightScale.coerceIn(0.50f, 1.25f) - 0.50f) /
                (1.25f - 0.50f)).coerceIn(0f, 1f)
            lightEntity = EntityManager.get().create()
            LightManager.Builder(LightManager.Type.DIRECTIONAL)
                .direction(0.3f, -1.0f, -0.2f)
                .color(1.0f, 1.0f, 1.0f)
                .intensity(55_000.0f)
                .castShadows(true)
                .shadowOptions(createKeyLightShadowOptions(normalizedLight))
                .build(engine, lightEntity)
            scene?.addEntity(lightEntity)
        }

        if (fillLightEntity == 0) {
            fillLightEntity = EntityManager.get().create()
            LightManager.Builder(LightManager.Type.DIRECTIONAL)
                .direction(-0.4f, -0.6f, 0.5f)
                .color(0.98f, 0.98f, 1.0f)
                .intensity(25_000.0f)
                .castShadows(false)
                .build(engine, fillLightEntity)
            scene?.addEntity(fillLightEntity)
        }

        applyDirectionalLightIntensities(engine)
        updateShadowAppearance()
        lightingConfigured = true
    }

    private fun ensureShadowCatcher() {
        val engine = engine ?: return
        val scene = scene ?: return
        if (shadowCatcher != null) return
        try {
            shadowCatcher = ShadowCatcherRenderer(engine, scene)
            enableShadowing()
            updateShadowAppearance()
        } catch (e: Exception) {
            Log.e(tag, "Shadow catcher unavailable; continuing without contact shadows", e)
            shadowCatcher = null
        }
    }

    private fun enableShadowing() {
        if (shadowsEnabled) return
        view?.setShadowingEnabled(true)
        shadowsEnabled = true
        Log.d(tag, "Shadow mapping enabled for contact shadows")
    }

    private fun recomputeShadowCatcher() {
        if (modelWorldCenters.isEmpty()) {
            shadowCatcher?.setVisible(false)
            return
        }

        val floorY = referenceFloorY
            ?: modelWorldCenters.values.minOfOrNull { it[1] }
            ?: return

        var minX = Float.MAX_VALUE
        var maxX = -Float.MAX_VALUE
        var minZ = Float.MAX_VALUE
        var maxZ = -Float.MAX_VALUE
        for (center in modelWorldCenters.values) {
            minX = minOf(minX, center[0])
            maxX = maxOf(maxX, center[0])
            minZ = minOf(minZ, center[2])
            maxZ = maxOf(maxZ, center[2])
        }

        val paddingM = 1.5f
        val minExtentM = 4f
        val widthM = maxOf(minExtentM, (maxX - minX) + paddingM * 2f)
        val depthM = maxOf(minExtentM, (maxZ - minZ) + paddingM * 2f)
        val centerX = (minX + maxX) * 0.5f
        val centerZ = (minZ + maxZ) * 0.5f

        ensureShadowCatcher()
        shadowCatcher?.update(
            centerX = centerX,
            floorY = floorY + SHADOW_PLANE_LIFT_M,
            centerZ = centerZ,
            widthM = widthM,
            depthM = depthM,
        )
        shadowCatcher?.setVisible(true)
    }

    companion object {
        /** Lift above the floor plane to avoid z-fighting with the model base. */
        private const val SHADOW_PLANE_LIFT_M = 0.002f
    }

    private fun neutralStudioSh(): FloatArray {
        val sh = FloatArray(27)
        sh[0] = 0.85f
        sh[1] = 0.85f
        sh[2] = 0.85f
        sh[3] = 0.08f
        sh[4] = 0.08f
        sh[5] = 0.08f
        sh[6] = 0.08f
        sh[7] = 0.08f
        sh[8] = 0.08f
        return sh
    }

    private fun snapModelBottomToOrigin(name: String, asset: FilamentAsset) {
        val box = asset.boundingBox
        val center = box.center
        val halfExtent = box.halfExtent
        val minY = center[1] - halfExtent[1]
        val height = halfExtent[1] * 2f

        val correction = FloatArray(16)
        GlMatrix.setIdentityM(correction, 0)

        var uniformScale = 1f
        if (targetHeightMeters > 1e-4f && height > 1e-4f) {
            uniformScale = targetHeightMeters / height
            GlMatrix.scaleM(correction, 0, uniformScale, uniformScale, uniformScale)
        }

        val floorSinkM = 0.002f
        val scaledMinY = minY * uniformScale
        if (kotlin.math.abs(scaledMinY) >= 1e-4f) {
            GlMatrix.translateM(correction, 0, 0f, -scaledMinY - floorSinkM, 0f)
        } else {
            GlMatrix.translateM(correction, 0, 0f, -floorSinkM, 0f)
        }
        rootOffsetCorrections[name] = correction
        Log.d(
            tag,
            "snapModelBottomToOrigin $name: height=$height targetHeight=$targetHeightMeters " +
                "uniformScale=$uniformScale minY=$minY correctionY=${correction[13]}",
        )
    }

    private fun logCameraDiagnosticsIfNeeded(
        arCamera: com.google.ar.core.Camera,
        projectionMatrix: FloatArray,
    ) {
        if (cameraDiagnosticLogged) return
        if (arCamera.trackingState != com.google.ar.core.TrackingState.TRACKING) return

        cameraDiagnosticLogged = true
        val imageDims = arCamera.imageIntrinsics.imageDimensions
        val textureDims = arCamera.textureIntrinsics.imageDimensions
        Log.d(
            tag,
            "Camera diagnostic depthOcclusionEnabled=$depthOcclusionEnabled " +
                "colorImage=${imageDims[0]}x${imageDims[1]} " +
                "texture=${textureDims[0]}x${textureDims[1]} " +
                "proj=[${projectionMatrix[0]}, ${projectionMatrix[5]}, " +
                "${projectionMatrix[10]}, ${projectionMatrix[14]}]",
        )
    }

    private fun applyTransform(name: String, asset: FilamentAsset, modelMatrix: FloatArray) {
        val engine = engine ?: return
        val transformManager = engine.transformManager
        val instance = transformManager.getInstance(asset.root)
        if (instance == 0) return

        val offset = rootOffsetCorrections[name]
        if (offset != null) {
            GlMatrix.multiplyMM(scratchComposedTransform, 0, modelMatrix, 0, offset, 0)
            transformManager.setTransform(instance, scratchComposedTransform)
        } else {
            transformManager.setTransform(instance, modelMatrix)
        }
    }

    private fun configureRenderableMaterials(asset: FilamentAsset) {
        val engine = engine ?: return
        val renderableManager = engine.renderableManager
        val materialsToCompile = mutableSetOf<Material>()

        for (materialInstance in asset.instance.materialInstances) {
            materialInstance.setDoubleSided(true)
            materialsToCompile.add(materialInstance.material)
        }

        for (entity in asset.entities) {
            val renderableInstance = renderableManager.getInstance(entity)
            if (renderableInstance == 0) continue

            renderableManager.setCulling(renderableInstance, false)
            renderableManager.setCastShadows(renderableInstance, true)
            renderableManager.setReceiveShadows(renderableInstance, false)

            val primitiveCount = renderableManager.getPrimitiveCount(renderableInstance)
            for (primitiveIndex in 0 until primitiveCount) {
                val materialInstance =
                    renderableManager.getMaterialInstanceAt(renderableInstance, primitiveIndex)
                materialInstance.setDoubleSided(true)
                materialsToCompile.add(materialInstance.material)
            }
        }

        for (material in materialsToCompile) {
            material.compile(
                Material.CompilerPriorityQueue.HIGH,
                Material.UserVariantFilterBit.DIRECTIONAL_LIGHTING or
                    Material.UserVariantFilterBit.DYNAMIC_LIGHTING,
                null,
                null,
            )
        }
    }

    private fun matricesApproximatelyEqual(a: FloatArray, b: FloatArray, epsilon: Float = 1e-3f): Boolean {
        if (a.size < 16 || b.size < 16) return false
        for (i in 0 until 16) {
            if (kotlin.math.abs(a[i] - b[i]) > epsilon) return false
        }
        return true
    }
}
