package tech.graaf.franz.ar_flutter_plugin_plus

import android.media.Image
import android.util.Log
import com.google.android.filament.Engine
import com.google.android.filament.Texture
import com.google.ar.core.Frame
import com.google.ar.core.exceptions.NotYetAvailableException
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * Uploads ARCore 16-bit depth (millimeters) and per-pixel confidence into a reusable RGBA8
 * Filament texture (R/G = depth mm as U16, B = confidence 0..255, A = 255).
 *
 * Uses [Frame.acquireRawDepthImage16Bits] paired with [Frame.acquireRawDepthConfidenceImage].
 * Updates every other frame; the shader applies 3x3 smoothing.
 */
internal class ArDepthTexture(private val engine: Engine) {
    companion object {
        private const val TAG = "ArDepthTexture"
        private const val UPDATE_INTERVAL_FRAMES = 2
    }

    private var texture: Texture? = null
    private var textureWidth = 0
    private var textureHeight = 0
    private var pixelBuffer: ByteBuffer? = null
    private var loggedDimensions = false
    private var updateFrameCounter = 0

    var hasValidDepth = false
        private set

    val textureInvSize = floatArrayOf(1f, 1f)

    fun update(frame: Frame): Boolean {
        updateFrameCounter++
        if (updateFrameCounter % UPDATE_INTERVAL_FRAMES != 0 && hasValidDepth) {
            return true
        }

        val rawDepthImage = try {
            frame.acquireRawDepthImage16Bits()
        } catch (e: NotYetAvailableException) {
            null
        } catch (e: Exception) {
            Log.w(TAG, "Failed to acquire raw depth image: ${e.message}")
            null
        }

        val smoothedDepthImage = if (rawDepthImage == null) {
            try {
                frame.acquireDepthImage16Bits()
            } catch (e: NotYetAvailableException) {
                hasValidDepth = false
                return false
            } catch (e: Exception) {
                Log.w(TAG, "Failed to acquire depth image: ${e.message}")
                hasValidDepth = false
                return false
            }
        } else {
            null
        }

        val depthImage = rawDepthImage ?: smoothedDepthImage ?: run {
            hasValidDepth = false
            return false
        }

        val confidenceImage: Image? = if (rawDepthImage != null) {
            try {
                frame.acquireRawDepthConfidenceImage()
            } catch (e: NotYetAvailableException) {
                null
            } catch (e: Exception) {
                Log.w(TAG, "Raw depth confidence unavailable: ${e.message}")
                null
            }
        } else {
            null
        }

        try {
            val width = depthImage.width
            val height = depthImage.height
            if (width <= 0 || height <= 0) {
                hasValidDepth = false
                return false
            }

            ensureTexture(width, height)
            textureInvSize[0] = 1f / width.toFloat()
            textureInvSize[1] = 1f / height.toFloat()

            val depthPlane = depthImage.planes[0]
            val depthRowStride = depthPlane.rowStride
            val depthPixelStride = depthPlane.pixelStride
            val depthSrc = depthPlane.buffer
            depthSrc.rewind()

            val useConfidence = confidenceImage != null &&
                confidenceImage.width == width &&
                confidenceImage.height == height
            val confidencePlane = if (useConfidence) confidenceImage!!.planes[0] else null
            val confidenceRowStride = confidencePlane?.rowStride ?: 0
            val confidencePixelStride = confidencePlane?.pixelStride ?: 1
            val confidenceSrc = confidencePlane?.buffer
            confidenceSrc?.rewind()

            val dst = pixelBuffer ?: return false
            dst.clear()

            for (y in 0 until height) {
                val depthRowBase = y * depthRowStride
                val confidenceRowBase = y * confidenceRowStride
                for (x in 0 until width) {
                    val depthOffset = depthRowBase + x * depthPixelStride
                    val depthMm = depthSrc.getShort(depthOffset).toInt() and 0xFFFF

                    val confidenceByte = if (confidenceSrc != null) {
                        val confidenceOffset = confidenceRowBase + x * confidencePixelStride
                        confidenceSrc.get(confidenceOffset).toInt() and 0xFF
                    } else {
                        255
                    }

                    dst.put((depthMm and 0xFF).toByte())
                    dst.put(((depthMm shr 8) and 0xFF).toByte())
                    dst.put(confidenceByte.toByte())
                    dst.put(0xFF.toByte())
                }
            }
            dst.flip()

            texture?.setImage(
                engine,
                0,
                Texture.PixelBufferDescriptor(
                    dst,
                    Texture.Format.RGBA,
                    Texture.Type.UBYTE,
                ),
            )
            if (!loggedDimensions) {
                loggedDimensions = true
                Log.d(
                    TAG,
                    "Depth texture ${width}x$height RGBA8 UBYTE " +
                        "(source=${if (rawDepthImage != null) "raw" else "smoothed"}, " +
                        "rawConfidence=$useConfidence, interval=$UPDATE_INTERVAL_FRAMES)",
                )
            }
            hasValidDepth = true
            return true
        } catch (e: Exception) {
            Log.w(TAG, "Failed to upload depth texture: ${e.message}")
            hasValidDepth = false
            return false
        } finally {
            depthImage.close()
            confidenceImage?.close()
        }
    }

    fun getTexture(): Texture? = if (hasValidDepth) texture else null

    fun destroy() {
        texture?.let { engine.destroyTexture(it) }
        texture = null
        pixelBuffer = null
        textureWidth = 0
        textureHeight = 0
        hasValidDepth = false
        loggedDimensions = false
        updateFrameCounter = 0
        textureInvSize[0] = 1f
        textureInvSize[1] = 1f
    }

    private fun ensureTexture(width: Int, height: Int) {
        if (texture != null && textureWidth == width && textureHeight == height) {
            return
        }

        texture?.let { engine.destroyTexture(it) }
        textureWidth = width
        textureHeight = height
        pixelBuffer = ByteBuffer.allocateDirect(width * height * 4)
            .order(ByteOrder.nativeOrder())

        texture = Texture.Builder()
            .width(width)
            .height(height)
            .levels(1)
            .sampler(Texture.Sampler.SAMPLER_2D)
            .format(Texture.InternalFormat.RGBA8)
            .build(engine)
    }
}
