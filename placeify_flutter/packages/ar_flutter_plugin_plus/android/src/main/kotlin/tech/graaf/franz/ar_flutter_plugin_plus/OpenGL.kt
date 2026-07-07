package tech.graaf.franz.ar_flutter_plugin_plus

import android.opengl.EGL14
import android.opengl.EGLConfig
import android.opengl.EGLContext
import android.opengl.EGLDisplay
import android.opengl.EGLSurface
import android.opengl.GLES11Ext
import android.opengl.GLES20
import android.opengl.GLES30
import android.util.Log

/**
 * Shared EGL context used by both Filament and ARCore external camera textures.
 *
 * Filament must be created with [eglContext] via [com.google.android.filament.Engine.Builder.sharedContext].
 * ARCore camera texture names must be allocated while this context is current.
 */
internal class SharedEglContext private constructor(
    val eglDisplay: EGLDisplay,
    val eglContext: EGLContext,
    private val eglSurface: EGLSurface,
) {
    fun destroy() {
        if (eglDisplay == EGL14.EGL_NO_DISPLAY) return
        EGL14.eglMakeCurrent(
            eglDisplay,
            EGL14.EGL_NO_SURFACE,
            EGL14.EGL_NO_SURFACE,
            EGL14.EGL_NO_CONTEXT,
        )
        if (eglSurface != EGL14.EGL_NO_SURFACE) {
            EGL14.eglDestroySurface(eglDisplay, eglSurface)
        }
        if (eglContext != EGL14.EGL_NO_CONTEXT) {
            EGL14.eglDestroyContext(eglDisplay, eglContext)
        }
        EGL14.eglTerminate(eglDisplay)
    }

    companion object {
        private const val TAG = "SharedEglContext"
        private const val EGL_OPENGL_ES3_BIT = 0x40

        fun create(): SharedEglContext {
            val display = EGL14.eglGetDisplay(EGL14.EGL_DEFAULT_DISPLAY)
            if (display == EGL14.EGL_NO_DISPLAY) {
                throw IllegalStateException("eglGetDisplay failed: ${eglErrorString()}")
            }

            val version = IntArray(2)
            if (!EGL14.eglInitialize(display, version, 0, version, 1)) {
                throw IllegalStateException("eglInitialize failed: ${eglErrorString()}")
            }

            val configs = arrayOfNulls<EGLConfig>(1)
            val numConfig = IntArray(1)
            val attribs = intArrayOf(
                EGL14.EGL_RENDERABLE_TYPE,
                EGL_OPENGL_ES3_BIT,
                EGL14.EGL_NONE,
            )
            if (!EGL14.eglChooseConfig(display, attribs, 0, configs, 0, 1, numConfig, 0) ||
                numConfig[0] == 0 ||
                configs[0] == null
            ) {
                throw IllegalStateException("eglChooseConfig failed: ${eglErrorString()}")
            }

            val contextAttribs = intArrayOf(
                EGL14.EGL_CONTEXT_CLIENT_VERSION,
                3,
                EGL14.EGL_NONE,
            )
            val context = EGL14.eglCreateContext(
                display,
                configs[0],
                EGL14.EGL_NO_CONTEXT,
                contextAttribs,
                0,
            )
            if (context == null || context == EGL14.EGL_NO_CONTEXT) {
                throw IllegalStateException("eglCreateContext failed: ${eglErrorString()}")
            }

            val surfaceAttribs = intArrayOf(
                EGL14.EGL_WIDTH,
                1,
                EGL14.EGL_HEIGHT,
                1,
                EGL14.EGL_NONE,
            )
            val surface = EGL14.eglCreatePbufferSurface(display, configs[0], surfaceAttribs, 0)
            if (surface == null || surface == EGL14.EGL_NO_SURFACE) {
                EGL14.eglDestroyContext(display, context)
                throw IllegalStateException("eglCreatePbufferSurface failed: ${eglErrorString()}")
            }

            if (!EGL14.eglMakeCurrent(display, surface, surface, context)) {
                EGL14.eglDestroySurface(display, surface)
                EGL14.eglDestroyContext(display, context)
                throw IllegalStateException("eglMakeCurrent failed: ${eglErrorString()}")
            }

            Log.d(TAG, "Created shared EGL context (OpenGL ES ${version[0]}.${version[1]})")
            return SharedEglContext(display, context, surface)
        }

        private fun eglErrorString(): String {
            return when (val error = EGL14.eglGetError()) {
                EGL14.EGL_SUCCESS -> "EGL_SUCCESS"
                EGL14.EGL_NOT_INITIALIZED -> "EGL_NOT_INITIALIZED"
                EGL14.EGL_BAD_ACCESS -> "EGL_BAD_ACCESS"
                EGL14.EGL_BAD_ALLOC -> "EGL_BAD_ALLOC"
                EGL14.EGL_BAD_ATTRIBUTE -> "EGL_BAD_ATTRIBUTE"
                EGL14.EGL_BAD_CONTEXT -> "EGL_BAD_CONTEXT"
                EGL14.EGL_BAD_CONFIG -> "EGL_BAD_CONFIG"
                EGL14.EGL_BAD_CURRENT_SURFACE -> "EGL_BAD_CURRENT_SURFACE"
                EGL14.EGL_BAD_DISPLAY -> "EGL_BAD_DISPLAY"
                EGL14.EGL_BAD_SURFACE -> "EGL_BAD_SURFACE"
                EGL14.EGL_BAD_MATCH -> "EGL_BAD_MATCH"
                EGL14.EGL_BAD_PARAMETER -> "EGL_BAD_PARAMETER"
                EGL14.EGL_BAD_NATIVE_PIXMAP -> "EGL_BAD_NATIVE_PIXMAP"
                EGL14.EGL_BAD_NATIVE_WINDOW -> "EGL_BAD_NATIVE_WINDOW"
                EGL14.EGL_CONTEXT_LOST -> "EGL_CONTEXT_LOST"
                else -> "EGL error 0x${Integer.toHexString(error)}"
            }
        }
    }
}

internal object OpenGL {
    private const val TAG = "OpenGL"

    /**
     * Allocates [count] external OES textures on the currently bound GL context.
     *
     * @throws IllegalStateException if any generated id is 0 or GL reports an error.
     */
    fun createExternalTextureIds(count: Int): IntArray {
        require(count > 0) { "count must be positive" }

        val glVersion = GLES20.glGetString(GLES20.GL_VERSION)
        if (glVersion.isNullOrBlank()) {
            throw IllegalStateException("No GL context is current (glGetString returned null)")
        }

        val textureIds = IntArray(count) { createExternalTextureId() }
        validateExternalTextureIds(textureIds)
        Log.d(TAG, "Allocated $count external camera textures: ${textureIds.joinToString()}")
        return textureIds
    }

    fun createExternalTextureId(): Int {
        val textures = IntArray(1)
        GLES30.glGenTextures(1, textures, 0)
        val textureId = textures[0]
        if (textureId == 0) {
            throw IllegalStateException(
                "glGenTextures returned 0 (glError=${glErrorString()})",
            )
        }

        val textureTarget = GLES11Ext.GL_TEXTURE_EXTERNAL_OES
        GLES30.glBindTexture(textureTarget, textureId)
        GLES30.glTexParameteri(textureTarget, GLES30.GL_TEXTURE_WRAP_S, GLES30.GL_CLAMP_TO_EDGE)
        GLES30.glTexParameteri(textureTarget, GLES30.GL_TEXTURE_WRAP_T, GLES30.GL_CLAMP_TO_EDGE)
        GLES30.glTexParameteri(textureTarget, GLES30.GL_TEXTURE_MIN_FILTER, GLES30.GL_LINEAR)
        GLES30.glTexParameteri(textureTarget, GLES30.GL_TEXTURE_MAG_FILTER, GLES30.GL_LINEAR)
        GLES30.glBindTexture(textureTarget, 0)

        val error = GLES30.glGetError()
        if (error != GLES30.GL_NO_ERROR) {
            throw IllegalStateException(
                "OpenGL error configuring external texture $textureId: ${glErrorString(error)}",
            )
        }
        return textureId
    }

    fun validateExternalTextureIds(textureIds: IntArray) {
        val invalid = textureIds.filter { it == 0 }
        if (invalid.isNotEmpty()) {
            throw IllegalStateException(
                "Invalid ARCore camera texture ids (0): ${textureIds.joinToString()}",
            )
        }
    }

    private fun glErrorString(error: Int = GLES30.glGetError()): String {
        return when (error) {
            GLES30.GL_NO_ERROR -> "GL_NO_ERROR"
            GLES30.GL_INVALID_ENUM -> "GL_INVALID_ENUM"
            GLES30.GL_INVALID_VALUE -> "GL_INVALID_VALUE"
            GLES30.GL_INVALID_OPERATION -> "GL_INVALID_OPERATION"
            GLES30.GL_OUT_OF_MEMORY -> "GL_OUT_OF_MEMORY"
            else -> "GL error 0x${Integer.toHexString(error)}"
        }
    }
}
