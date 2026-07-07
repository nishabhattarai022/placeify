package tech.graaf.franz.ar_flutter_plugin_plus

import android.content.Context
import android.opengl.Matrix
import android.util.Log
import com.google.android.filament.Engine
import com.google.android.filament.EntityManager
import com.google.android.filament.IndexBuffer
import com.google.android.filament.Material
import com.google.android.filament.MaterialInstance
import com.google.android.filament.RenderableManager
import com.google.android.filament.Scene
import com.google.android.filament.Texture
import com.google.android.filament.VertexBuffer
import com.google.ar.core.Coordinates2d
import com.google.ar.core.Frame
import com.google.ar.core.Session
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import java.nio.ShortBuffer

/**
 * Renders the ARCore camera feed as a Filament fullscreen quad behind scene content.
 *
 * When [depthOcclusionEnabled] is true and a depth image is available, switches to a material
 * that writes real-world depth via [gl_FragDepth] while compositing the camera (hello_ar_filament
 * pattern). Virtual geometry can then depth-test against the background pass.
 */
internal class CameraBackgroundRenderer(
    private val context: Context,
    private val engine: Engine,
    private val scene: Scene,
    val textureIds: IntArray,
) {
    companion object {
        const val TEXTURE_COUNT = 6
        private const val TAG = "CameraBackgroundRenderer"
        private const val CAMERA_PRIORITY_BACKGROUND = 7
        /** Push trusted real-world depth away from camera to reduce false interior holes. */
        const val DEFAULT_OCCLUSION_BIAS_MM = 55f
        /** Ignore depth pixels below this confidence (0..1). */
        const val DEFAULT_MIN_CONFIDENCE = 0.38f
        private const val FLOAT_SIZE_BYTES = 4
        private const val POSITION_BUFFER_INDEX = 0
        private const val UV_BUFFER_INDEX = 1
        private const val VERTEX_COUNT = 3

        private val CAMERA_VERTICES = floatArrayOf(
            -1.0f, 1.0f, 1.0f,
            -1.0f, -3.0f, 1.0f,
            3.0f, 1.0f, 1.0f,
        )

        private val CAMERA_UVS = floatArrayOf(
            0.0f, 0.0f,
            0.0f, 2.0f,
            2.0f, 0.0f,
        )

        private val INDICES = shortArrayOf(0, 1, 2)
    }

    private val entity = EntityManager.get().create()
    private val cameraTextures: Map<Int, Texture>
    private var activeCameraTexture: Texture
    private val flatMaterial: Material
    private val flatMaterialInstance: MaterialInstance
    private var depthMaterial: Material? = null
    private var depthMaterialInstance: MaterialInstance? = null
    private var arDepthTexture: ArDepthTexture? = null
    private val vertexBuffer: VertexBuffer
    private val indexBuffer: IndexBuffer
    private val uvTransform = FloatArray(16)
    private var renderableInstance = 0
    private var usingDepthMaterial = false

    var depthOcclusionEnabled = false
    var occlusionBiasMm = DEFAULT_OCCLUSION_BIAS_MM
    var minConfidence = DEFAULT_MIN_CONFIDENCE

    private val uvCoordinates: FloatBuffer =
        ByteBuffer.allocateDirect(CAMERA_UVS.size * FLOAT_SIZE_BYTES)
            .order(ByteOrder.nativeOrder())
            .asFloatBuffer()
            .apply {
                put(CAMERA_UVS)
                rewind()
            }

    private var transformedUvCoordinates: FloatBuffer? = null

    init {
        require(textureIds.isNotEmpty()) { "textureIds must not be empty" }
        OpenGL.validateExternalTextureIds(textureIds)
        Matrix.setIdentityM(uvTransform, 0)

        cameraTextures = textureIds.associateWith { textureId ->
            Texture.Builder()
                .sampler(Texture.Sampler.SAMPLER_EXTERNAL)
                .format(Texture.InternalFormat.RGB16F)
                .importTexture(textureId.toLong())
                .build(engine)
        }
        activeCameraTexture = cameraTextures.getValue(textureIds[0])

        val materialBuffer = context.assets.open("materials/camera_stream_flat.filamat").use { input ->
            val bytes = input.readBytes()
            ByteBuffer.allocateDirect(bytes.size).apply {
                put(bytes)
                rewind()
            }
        }
        flatMaterial = Material.Builder()
            .payload(materialBuffer, materialBuffer.remaining())
            .build(engine)
        flatMaterialInstance = flatMaterial.createInstance().apply {
            setParameter("uvTransform", MaterialInstance.FloatElement.MAT4, uvTransform, 0, 1)
            setParameter("cameraTexture", activeCameraTexture, CameraTextureSampler())
        }

        vertexBuffer = VertexBuffer.Builder()
            .vertexCount(VERTEX_COUNT)
            .bufferCount(2)
            .attribute(
                VertexBuffer.VertexAttribute.POSITION,
                POSITION_BUFFER_INDEX,
                VertexBuffer.AttributeType.FLOAT3,
                0,
                3 * FLOAT_SIZE_BYTES,
            )
            .attribute(
                VertexBuffer.VertexAttribute.UV0,
                UV_BUFFER_INDEX,
                VertexBuffer.AttributeType.FLOAT2,
                0,
                2 * FLOAT_SIZE_BYTES,
            )
            .build(engine)
            .apply {
                setBufferAt(
                    engine,
                    POSITION_BUFFER_INDEX,
                    FloatBuffer.wrap(CAMERA_VERTICES),
                )
                setBufferAt(engine, UV_BUFFER_INDEX, uvCoordinates)
            }

        indexBuffer = IndexBuffer.Builder()
            .indexCount(INDICES.size)
            .bufferType(IndexBuffer.Builder.IndexType.USHORT)
            .build(engine)
            .apply {
                setBuffer(engine, ShortBuffer.wrap(INDICES))
            }

        RenderableManager.Builder(1)
            .castShadows(false)
            .receiveShadows(false)
            .culling(false)
            .priority(CAMERA_PRIORITY_BACKGROUND)
            .geometry(
                0,
                RenderableManager.PrimitiveType.TRIANGLES,
                vertexBuffer,
                indexBuffer,
            )
            .material(0, flatMaterialInstance)
            .build(engine, entity)

        renderableInstance = engine.renderableManager.getInstance(entity)
        scene.addEntity(entity)
        Log.d(TAG, "Created camera background with ${textureIds.size} external textures")
    }

    fun bindSession(session: Session) {
        OpenGL.validateExternalTextureIds(textureIds)
        try {
            session.setCameraTextureNames(textureIds)
            Log.d(TAG, "Bound ARCore camera textures: ${textureIds.joinToString()}")
        } catch (e: Exception) {
            Log.e(TAG, "setCameraTextureNames failed", e)
            throw e
        }
    }

    fun update(frame: Frame) {
        cameraTextures[frame.cameraTextureName]?.let { texture ->
            if (texture !== activeCameraTexture) {
                activeCameraTexture = texture
                flatMaterialInstance.setParameter("cameraTexture", texture, CameraTextureSampler())
                depthMaterialInstance?.setParameter("cameraTexture", texture, CameraTextureSampler())
            }
        }

        updateUvCoordinates(frame)

        if (depthOcclusionEnabled) {
            val depthUploader = ensureDepthMaterial()
            depthUploader?.update(frame)
            if (depthUploader?.hasValidDepth == true) {
                val depthTexture = depthUploader.getTexture()
                if (depthTexture != null) {
                    switchToDepthMaterial(depthTexture, depthUploader)
                } else {
                    switchToFlatMaterial()
                }
            } else {
                switchToFlatMaterial()
            }
        } else if (usingDepthMaterial) {
            switchToFlatMaterial()
        }
    }

    fun destroy() {
        scene.removeEntity(entity)
        engine.destroyEntity(entity)
        engine.destroyMaterialInstance(flatMaterialInstance)
        engine.destroyMaterial(flatMaterial)
        depthMaterialInstance?.let { engine.destroyMaterialInstance(it) }
        depthMaterial?.let { engine.destroyMaterial(it) }
        arDepthTexture?.destroy()
        engine.destroyVertexBuffer(vertexBuffer)
        engine.destroyIndexBuffer(indexBuffer)
        cameraTextures.values.forEach { engine.destroyTexture(it) }
    }

    private fun updateUvCoordinates(frame: Frame) {
        if (transformedUvCoordinates != null && !frame.hasDisplayGeometryChanged()) {
            return
        }

        val transformed = transformedUvCoordinates ?: uvCoordinates.duplicate().also {
            transformedUvCoordinates = it
        }
        transformed.position(0)

        frame.transformCoordinates2d(
            Coordinates2d.VIEW_NORMALIZED,
            uvCoordinates,
            Coordinates2d.TEXTURE_NORMALIZED,
            transformed,
        )
        transformed.position(0)

        for (i in 1 until VERTEX_COUNT * 2 step 2) {
            transformed.put(i, 1.0f - transformed.get(i))
        }
        transformed.position(0)
        vertexBuffer.setBufferAt(engine, UV_BUFFER_INDEX, transformed)
    }

    private fun ensureDepthMaterial(): ArDepthTexture? {
        if (arDepthTexture != null) {
            return arDepthTexture
        }

        return try {
            val depthMaterialBuffer =
                context.assets.open("materials/camera_stream_depth.filamat").use { input ->
                    val bytes = input.readBytes()
                    ByteBuffer.allocateDirect(bytes.size).apply {
                        put(bytes)
                        rewind()
                    }
                }
            val createdDepthMaterial = Material.Builder()
                .payload(depthMaterialBuffer, depthMaterialBuffer.remaining())
                .build(engine)
            val createdDepthInstance = createdDepthMaterial.createInstance().apply {
                setParameter("uvTransform", MaterialInstance.FloatElement.MAT4, uvTransform, 0, 1)
                setParameter("cameraTexture", activeCameraTexture, CameraTextureSampler())
                setParameter("depthTextureInvSize", 1f, 1f)
                setParameter("occlusionBiasMm", occlusionBiasMm)
                setParameter("minConfidence", minConfidence)
            }
            depthMaterial = createdDepthMaterial
            depthMaterialInstance = createdDepthInstance
            ArDepthTexture(engine).also { arDepthTexture = it }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize depth camera material", e)
            null
        }
    }

    private fun switchToDepthMaterial(depthTexture: Texture, depthUploader: ArDepthTexture) {
        val depthInstance = depthMaterialInstance ?: return
        if (renderableInstance == 0) return

        val invSize = depthUploader.textureInvSize
        depthInstance.setParameter("depthTexture", depthTexture, DepthTextureSampler())
        depthInstance.setParameter("depthTextureInvSize", invSize[0], invSize[1])
        depthInstance.setParameter("occlusionBiasMm", occlusionBiasMm)
        depthInstance.setParameter("minConfidence", minConfidence)
        if (!usingDepthMaterial) {
            engine.renderableManager.setMaterialInstanceAt(renderableInstance, 0, depthInstance)
            usingDepthMaterial = true
        }
    }

    private fun switchToFlatMaterial() {
        if (renderableInstance == 0 || !usingDepthMaterial) return
        engine.renderableManager.setMaterialInstanceAt(renderableInstance, 0, flatMaterialInstance)
        usingDepthMaterial = false
    }

    private class CameraTextureSampler : com.google.android.filament.TextureSampler(
        MinFilter.LINEAR,
        MagFilter.LINEAR,
        WrapMode.CLAMP_TO_EDGE,
    )

    private class DepthTextureSampler : com.google.android.filament.TextureSampler(
        MinFilter.LINEAR,
        MagFilter.LINEAR,
        WrapMode.CLAMP_TO_EDGE,
    )
}
