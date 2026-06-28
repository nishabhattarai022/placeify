package tech.graaf.franz.ar_flutter_plugin_plus

import android.opengl.Matrix as GlMatrix
import android.os.Handler
import android.os.Looper
import android.util.Log
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
import java.nio.ByteBuffer

/**
 * Renders GLB furniture on a transparent [TextureView] composited over the ARCore camera.
 *
 * Filament cannot reliably use the same EGL surface as [GLSurfaceView], so models render on a
 * dedicated overlay while placement uses stable anchor matrices from [AndroidARView].
 */
internal class ModelRenderer {
    private val tag = "ModelRenderer"
    private val mainHandler = Handler(Looper.getMainLooper())

    private var engine: Engine? = null
    private var renderer: Renderer? = null
    private var view: View? = null
    private var scene: Scene? = null
    private var camera: Camera? = null
    private var swapChain: SwapChain? = null
    private var swapChainSurface: Surface? = null

    private var uiHelper: UiHelper? = null
    private var textureView: TextureView? = null

    private var viewportWidth: Int = 0
    private var viewportHeight: Int = 0

    private var lightEntity: Int = 0
    private var fillLightEntity: Int = 0
    private var indirectLight: IndirectLight? = null
    private var lightIntensityMultiplier: Float = 1.0f
    private var lightingConfigured = false

    private val cameraLock = Any()
    private val cameraViewMatrix = FloatArray(16)
    private val cameraProjectionMatrix = FloatArray(16)
    private var hasCamera = false

    private var materialProvider: MaterialProvider? = null
    private var assetLoader: AssetLoader? = null
    private var resourceLoader: ResourceLoader? = null

    private val modelAssets: MutableMap<String, FilamentAsset> = mutableMapOf()
    private val pendingTransforms: MutableMap<String, FloatArray> = mutableMapOf()
    private val lastSentTransforms: MutableMap<String, FloatArray> = mutableMapOf()
    private val rootOffsetCorrections: MutableMap<String, FloatArray> = mutableMapOf()

    fun attachTextureView(textureView: TextureView) {
        if (this.textureView === textureView) return
        this.textureView = textureView
        mainHandler.post {
            ensureUiHelper()
            uiHelper?.attachTo(textureView)
        }
    }

    fun updateCamera(viewMatrix: FloatArray, projectionMatrix: FloatArray) {
        synchronized(cameraLock) {
            System.arraycopy(viewMatrix, 0, cameraViewMatrix, 0, 16)
            System.arraycopy(projectionMatrix, 0, cameraProjectionMatrix, 0, 16)
            hasCamera = true
        }
        renderFrameImmediate()
    }

    fun updateTransformIfChanged(name: String, modelMatrix: FloatArray) {
        val last = lastSentTransforms[name]
        if (last != null && matricesApproximatelyEqual(last, modelMatrix)) {
            return
        }
        lastSentTransforms[name] = modelMatrix.clone()
        updateTransform(name, modelMatrix)
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
            ensureEngine()
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
            scheduleRender()
        }
    }

    fun loadGltf(name: String, json: ByteArray, resources: Map<String, ByteArray>) {
        mainHandler.post {
            ensureEngine()
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
            scheduleRender()
        }
    }

    fun updateTransform(name: String, modelMatrix: FloatArray) {
        val matrixCopy = modelMatrix.clone()
        mainHandler.post {
            pendingTransforms[name] = matrixCopy
            val asset = modelAssets[name] ?: return@post
            applyTransform(name, asset, matrixCopy)
            scheduleRender()
        }
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
            uiHelper?.detach()
            uiHelper = null

            val engine = engine ?: return@post

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

            this.engine = null
            renderer = null
            view = null
            scene = null
            camera = null
            materialProvider = null
            assetLoader = null
            resourceLoader = null
            lightingConfigured = false
            hasCamera = false
        }
    }

    private fun createSwapChainIfNeeded(surface: Surface) {
        val engine = engine ?: return
        if (swapChain != null && swapChainSurface === surface) return
        swapChain?.let { engine.destroySwapChain(it) }
        swapChain = engine.createSwapChain(surface)
        swapChainSurface = surface
    }

    private fun destroySwapChain() {
        val engine = engine ?: return
        swapChain?.let { engine.destroySwapChain(it) }
        swapChain = null
        swapChainSurface = null
    }

    private fun ensureEngine() {
        if (engine != null) return
        Filament.init()
        Gltfio.init()
        engine = Engine.create()
        renderer = engine!!.createRenderer()
        renderer!!.clearOptions = Renderer.ClearOptions().apply {
            clear = true
            clearColor = floatArrayOf(0f, 0f, 0f, 0f)
        }
        scene = engine!!.createScene()
        view = engine!!.createView()
        camera = engine!!.createCamera(EntityManager.get().create())

        materialProvider = UbershaderProvider(engine!!)
        assetLoader = AssetLoader(engine!!, materialProvider!!, EntityManager.get())
        resourceLoader = ResourceLoader(engine!!)

        view!!.scene = scene
        view!!.camera = camera
        view!!.blendMode = View.BlendMode.TRANSLUCENT
        view!!.isPostProcessingEnabled = true
        view!!.colorGrading = ColorGrading.Builder()
            .toneMapping(ColorGrading.ToneMapping.LINEAR)
            .exposure(1.0f)
            .build(engine!!)

        setupStudioLighting(engine!!)
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
            .intensity(35_000.0f * scale)
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

    private fun scheduleRender() {
        renderFrameImmediate()
    }

    private fun renderFrameImmediate() {
        if (Looper.myLooper() == mainHandler.looper) {
            renderFrame()
        } else {
            mainHandler.postAtFrontOfQueue { renderFrame() }
        }
    }

    private fun ensureUiHelper() {
        if (uiHelper != null) return
        uiHelper = UiHelper(UiHelper.ContextErrorPolicy.DONT_CHECK)
        uiHelper?.setRenderCallback(object : UiHelper.RendererCallback {
            override fun onNativeWindowChanged(surface: Surface) {
                ensureEngine()
                createSwapChainIfNeeded(surface)
            }

            override fun onDetachedFromSurface() {
                destroySwapChain()
            }

            override fun onResized(width: Int, height: Int) {
                viewportWidth = width
                viewportHeight = height
                view?.viewport = Viewport(0, 0, width, height)
            }
        })
    }

    private fun renderFrame() {
        val renderer = renderer ?: return
        val view = this.view ?: return
        val swapChain = this.swapChain ?: return
        val camera = this.camera ?: return
        if (!hasCamera) return

        if (viewportWidth == 0 || viewportHeight == 0) {
            val tv = textureView
            val w = tv?.width ?: 0
            val h = tv?.height ?: 0
            if (w > 0 && h > 0) {
                viewportWidth = w
                viewportHeight = h
                view.viewport = Viewport(0, 0, w, h)
            }
        }

        val viewMatrix = FloatArray(16)
        val projectionMatrix = FloatArray(16)
        synchronized(cameraLock) {
            System.arraycopy(cameraViewMatrix, 0, viewMatrix, 0, 16)
            System.arraycopy(cameraProjectionMatrix, 0, projectionMatrix, 0, 16)
        }

        val inverseView = FloatArray(16)
        GlMatrix.invertM(inverseView, 0, viewMatrix, 0)
        camera.setModelMatrix(inverseView)

        val projectionDouble = DoubleArray(16) { projectionMatrix[it].toDouble() }
        camera.setCustomProjection(projectionDouble, 0.1, 100.0)

        if (renderer.beginFrame(swapChain, 0L)) {
            renderer.render(view)
            renderer.endFrame()
        }
    }

    private fun snapModelBottomToOrigin(name: String, asset: FilamentAsset) {
        val box = asset.boundingBox
        val center = box.center
        val halfExtent = box.halfExtent
        val minY = center[1] - halfExtent[1]

        val correction = FloatArray(16)
        GlMatrix.setIdentityM(correction, 0)
        if (kotlin.math.abs(minY) >= 1e-4f) {
            GlMatrix.translateM(correction, 0, 0f, -minY, 0f)
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

    private fun matricesApproximatelyEqual(a: FloatArray, b: FloatArray, epsilon: Float = 1e-5f): Boolean {
        if (a.size < 16 || b.size < 16) return false
        for (i in 0 until 16) {
            if (kotlin.math.abs(a[i] - b[i]) > epsilon) return false
        }
        return true
    }
}
