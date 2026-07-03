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
 * [textureIds] must be created with [OpenGL.createExternalTextureId] while Filament's GL
 * context is current (inside [com.google.android.filament.Renderer.beginFrame]).
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
        private const val FLOAT_SIZE_BYTES = 4
        private const val POSITION_BUFFER_INDEX = 0
        private const val UV_BUFFER_INDEX = 1
        // Single large triangle (SceneView / ARCore pattern) — avoids quad winding issues
        // with Filament's device-domain camera material.
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
    private val material: Material
    private val materialInstance: MaterialInstance
    private val vertexBuffer: VertexBuffer
    private val indexBuffer: IndexBuffer
    private val uvTransform = FloatArray(16)

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
        material = Material.Builder()
            .payload(materialBuffer, materialBuffer.remaining())
            .build(engine)
        materialInstance = material.createInstance().apply {
            setParameter("uvTransform", MaterialInstance.FloatElement.MAT4, uvTransform, 0, 1)
            setParameter("cameraTexture", activeCameraTexture, TextureSampler())
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
            .material(0, materialInstance)
            .build(engine, entity)

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
                materialInstance.setParameter("cameraTexture", texture, TextureSampler())
            }
        }

        if (transformedUvCoordinates == null || frame.hasDisplayGeometryChanged()) {
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
    }

    fun destroy() {
        scene.removeEntity(entity)
        engine.destroyEntity(entity)
        engine.destroyMaterialInstance(materialInstance)
        engine.destroyMaterial(material)
        engine.destroyVertexBuffer(vertexBuffer)
        engine.destroyIndexBuffer(indexBuffer)
        cameraTextures.values.forEach { engine.destroyTexture(it) }
    }

    private class TextureSampler : com.google.android.filament.TextureSampler(
        MinFilter.LINEAR,
        MagFilter.LINEAR,
        WrapMode.CLAMP_TO_EDGE,
    )
}
