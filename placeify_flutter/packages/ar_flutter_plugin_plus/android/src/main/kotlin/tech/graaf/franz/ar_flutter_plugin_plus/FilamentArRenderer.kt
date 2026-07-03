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
    private var lightingConfigured = false

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
            }
            Log.d(tag, "Loaded GLB $name (${asset.entities.size} entities)")
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
            }
        }
    }

    fun updateTransform(name: String, modelMatrix: FloatArray) {
        val matrixCopy = modelMatrix.clone()
        mainHandler.post {
            pendingTransforms[name] = matrixCopy
            val asset = modelAssets[name] ?: return@post
            applyTransform(name, asset, matrixCopy)
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
            cameraBackground = CameraBackgroundRenderer(context, engine, scene, textureIds)
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
        val viewMatrix = FloatArray(16)
        val projectionMatrix = FloatArray(16)
        arCamera.getViewMatrix(viewMatrix, 0)
        arCamera.getProjectionMatrix(projectionMatrix, 0, 0.1f, 100.0f)

        val inverseView = FloatArray(16)
        GlMatrix.invertM(inverseView, 0, viewMatrix, 0)
        camera.setModelMatrix(inverseView)

        val projectionDouble = DoubleArray(16) { projectionMatrix[it].toDouble() }
        camera.setCustomProjection(projectionDouble, 0.1, 100.0)

        cameraBackground?.update(frame)

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
        view!!.isPostProcessingEnabled = false
        view!!.colorGrading = ColorGrading.Builder()
            .toneMapping(ColorGrading.ToneMapping.LINEAR)
            .exposure(1.0f)
            .build(createdEngine)

        setupStudioLighting(createdEngine)
        ensureCameraBackground(createdEngine, scene!!)
    }

    private fun setupStudioLighting(engine: Engine) {
        if (lightingConfigured) return

        if (lightEntity == 0) {
            lightEntity = EntityManager.get().create()
            LightManager.Builder(LightManager.Type.DIRECTIONAL)
                .direction(0.3f, -1.0f, -0.2f)
                .color(1.0f, 1.0f, 1.0f)
                .intensity(55_000.0f)
                .build(engine, lightEntity)
            scene?.addEntity(lightEntity)
        }

        if (fillLightEntity == 0) {
            fillLightEntity = EntityManager.get().create()
            LightManager.Builder(LightManager.Type.DIRECTIONAL)
                .direction(-0.4f, -0.6f, 0.5f)
                .color(0.98f, 0.98f, 1.0f)
                .intensity(25_000.0f)
                .build(engine, fillLightEntity)
            scene?.addEntity(fillLightEntity)
        }

        val lightManager = engine.lightManager
        val scale = lightIntensityMultiplier
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
        view?.setShadowingEnabled(false)
        lightingConfigured = true
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

        val correction = FloatArray(16)
        GlMatrix.setIdentityM(correction, 0)
        val floorSinkM = 0.002f
        if (kotlin.math.abs(minY) >= 1e-4f) {
            GlMatrix.translateM(correction, 0, 0f, -minY - floorSinkM, 0f)
        } else {
            GlMatrix.translateM(correction, 0, 0f, -floorSinkM, 0f)
        }
        rootOffsetCorrections[name] = correction
    }

    private fun applyTransform(name: String, asset: FilamentAsset, modelMatrix: FloatArray) {
        val engine = engine ?: return
        val transformManager = engine.transformManager
        val instance = transformManager.getInstance(asset.root)
        if (instance == 0) return

        val offset = rootOffsetCorrections[name]
        if (offset != null) {
            val composed = FloatArray(16)
            GlMatrix.multiplyMM(composed, 0, modelMatrix, 0, offset, 0)
            transformManager.setTransform(instance, composed)
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
