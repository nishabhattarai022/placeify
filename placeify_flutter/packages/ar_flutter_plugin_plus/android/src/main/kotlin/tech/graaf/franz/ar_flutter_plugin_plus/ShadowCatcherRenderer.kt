package tech.graaf.franz.ar_flutter_plugin_plus

import android.opengl.Matrix
import android.util.Log
import com.google.android.filament.Box
import com.google.android.filament.Engine
import com.google.android.filament.EntityManager
import com.google.android.filament.IndexBuffer
import com.google.android.filament.Material
import com.google.android.filament.MaterialInstance
import com.google.android.filament.RenderableManager
import com.google.android.filament.Scene
import com.google.android.filament.VertexBuffer
import com.google.android.filament.filamat.MaterialBuilder
import java.nio.FloatBuffer
import java.nio.ShortBuffer

/**
 * Invisible floor quad that receives shadow-map contributions only (Filament shadowMultiplier).
 *
 * Material is compiled at runtime via filamat so we can tune [shadowAlpha] without shipping matc.
 * Source equivalent: assets/materials/shadow_catcher.mat
 */
internal class ShadowCatcherRenderer(
    private val engine: Engine,
    private val scene: Scene,
) {
    companion object {
        private const val TAG = "ShadowCatcherRenderer"
        private const val SHADOW_CATCHER_PRIORITY = 5
        private const val DEFAULT_SHADOW_ALPHA = 0.45f
        private const val FLOAT_SIZE_BYTES = 4
        private const val POSITION_BUFFER_INDEX = 0
        private const val TANGENT_BUFFER_INDEX = 1

        /** Unit quad on the XZ plane centered at the origin (±0.5 m). */
        private val QUAD_VERTICES = floatArrayOf(
            -0.5f, 0f, -0.5f,
            0.5f, 0f, -0.5f,
            0.5f, 0f, 0.5f,
            -0.5f, 0f, 0.5f,
        )

        /**
         * Tangent frame for an upward-facing (+Y normal) ground plane.
         * Quaternion is a -90° rotation about X (maps default +Z normal to +Y).
         */
        private val QUAD_TANGENTS = floatArrayOf(
            -0.70710677f, 0f, 0f, 0.70710677f,
            -0.70710677f, 0f, 0f, 0.70710677f,
            -0.70710677f, 0f, 0f, 0.70710677f,
            -0.70710677f, 0f, 0f, 0.70710677f,
        )

        private val QUAD_INDICES = shortArrayOf(0, 1, 2, 0, 2, 3)

        private const val SHADOW_MATERIAL = """
void material(inout MaterialInputs material) {
    prepareMaterial(material);
    material.baseColor = vec4(0.0, 0.0, 0.0, materialParams.shadowAlpha);
}
"""

        @Volatile
        private var materialBuilderInitialized = false

        private fun ensureMaterialBuilderInitialized() {
            if (materialBuilderInitialized) return
            synchronized(this) {
                if (!materialBuilderInitialized) {
                    MaterialBuilder.init()
                    materialBuilderInitialized = true
                }
            }
        }
    }

    private val entity = EntityManager.get().create()
    private val material: Material
    private val materialInstance: MaterialInstance
    private val vertexBuffer: VertexBuffer
    private val indexBuffer: IndexBuffer
    private val scratchTransform = FloatArray(16)
    private var renderableInstance = 0
    private var visible = false

    init {
        ensureMaterialBuilderInitialized()

        val materialPackage = MaterialBuilder()
            .platform(MaterialBuilder.Platform.MOBILE)
            .targetApi(MaterialBuilder.TargetApi.OPENGL)
            .name("ShadowCatcher")
            .shading(MaterialBuilder.Shading.UNLIT)
            .blending(MaterialBuilder.BlendingMode.TRANSPARENT)
            .shadowMultiplier(true)
            .doubleSided(true)
            .culling(MaterialBuilder.CullingMode.NONE)
            .uniformParameter(
                MaterialBuilder.UniformType.FLOAT,
                MaterialBuilder.ParameterPrecision.MEDIUM,
                "shadowAlpha",
            )
            .material(SHADOW_MATERIAL)
            .build(engine)

        if (!materialPackage.isValid) {
            throw IllegalStateException("Failed to compile shadow catcher material")
        }

        val payload = materialPackage.buffer
        material = Material.Builder()
            .payload(payload, payload.remaining())
            .build(engine)
        materialInstance = material.createInstance().apply {
            setParameter("shadowAlpha", DEFAULT_SHADOW_ALPHA)
        }

        vertexBuffer = VertexBuffer.Builder()
            .vertexCount(QUAD_VERTICES.size / 3)
            .bufferCount(2)
            .attribute(
                VertexBuffer.VertexAttribute.POSITION,
                POSITION_BUFFER_INDEX,
                VertexBuffer.AttributeType.FLOAT3,
                0,
                3 * FLOAT_SIZE_BYTES,
            )
            .attribute(
                VertexBuffer.VertexAttribute.TANGENTS,
                TANGENT_BUFFER_INDEX,
                VertexBuffer.AttributeType.FLOAT4,
                0,
                4 * FLOAT_SIZE_BYTES,
            )
            .build(engine)
            .apply {
                setBufferAt(
                    engine,
                    POSITION_BUFFER_INDEX,
                    FloatBuffer.wrap(QUAD_VERTICES),
                )
                setBufferAt(
                    engine,
                    TANGENT_BUFFER_INDEX,
                    FloatBuffer.wrap(QUAD_TANGENTS),
                )
            }

        indexBuffer = IndexBuffer.Builder()
            .indexCount(QUAD_INDICES.size)
            .bufferType(IndexBuffer.Builder.IndexType.USHORT)
            .build(engine)
            .apply {
                setBuffer(engine, ShortBuffer.wrap(QUAD_INDICES))
            }

        // Flat geometry has zero Y extent; Filament rejects an empty AABB on shadow receivers.
        RenderableManager.Builder(1)
            .castShadows(false)
            .receiveShadows(true)
            .culling(false)
            .priority(SHADOW_CATCHER_PRIORITY)
            .boundingBox(Box(0f, 0f, 0f, 0.5f, 0.001f, 0.5f))
            .geometry(
                0,
                RenderableManager.PrimitiveType.TRIANGLES,
                vertexBuffer,
                indexBuffer,
            )
            .material(0, materialInstance)
            .build(engine, entity)

        renderableInstance = engine.renderableManager.getInstance(entity)
        engine.renderableManager.setLayerMask(renderableInstance, 0xFF, 0xFF)
        scene.addEntity(entity)
        setVisible(false)
        Log.d(TAG, "Shadow catcher plane ready")
    }

    fun setShadowAlpha(alpha: Float) {
        val clamped = alpha.coerceIn(0.12f, 0.75f)
        materialInstance.setParameter("shadowAlpha", clamped)
    }

    fun update(centerX: Float, floorY: Float, centerZ: Float, widthM: Float, depthM: Float) {
        Matrix.setIdentityM(scratchTransform, 0)
        Matrix.translateM(scratchTransform, 0, centerX, floorY, centerZ)
        Matrix.scaleM(scratchTransform, 0, widthM, 1f, depthM)
        engine.transformManager.setTransform(
            engine.transformManager.getInstance(entity),
            scratchTransform,
        )
    }

    fun setVisible(visible: Boolean) {
        if (this.visible == visible) return
        this.visible = visible
        val renderableManager = engine.renderableManager
        val instance = renderableInstance
        if (instance == 0) return
        renderableManager.setLayerMask(
            instance,
            0xFF,
            if (visible) 0xFF else 0x00,
        )
    }

    fun destroy() {
        scene.removeEntity(entity)
        engine.destroyEntity(entity)
        renderableInstance = 0
        engine.destroyMaterialInstance(materialInstance)
        engine.destroyMaterial(material)
        engine.destroyVertexBuffer(vertexBuffer)
        engine.destroyIndexBuffer(indexBuffer)
    }
}
