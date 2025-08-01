package com.example.fingerprint_app

import android.content.Context
import android.graphics.Bitmap
import com.digitalpersona.uareu.Reader
import com.digitalpersona.uareu.Reader.CaptureQuality
import com.digitalpersona.uareu.Reader.ImageProcessing
import com.digitalpersona.uareu.ReaderCollection
import com.digitalpersona.uareu.UareUException
import com.digitalpersona.uareu.UareUGlobal
import java.nio.ByteBuffer

class Globals {
    //public static final Reader.ImageProcessing DefaultImageProcessing = Reader.ImageProcessing.IMG_PROC_PIV;
    @Throws(UareUException::class)
    fun getReader(name: String, applContext: Context?): Reader? {
        getReaders(applContext)

        for (nCount in readers!!.indices) {
            if (readers!![nCount].GetDescription().name == name) {
                return readers!![nCount]
            }
        }
        return null
    }

    @Throws(UareUException::class)
    fun getReaders(applContext: Context?): ReaderCollection? {
        readers = UareUGlobal.GetReaderCollection(applContext)
        readers?.GetReaders()
        return readers
    }

    private var readers: ReaderCollection? = null

    companion object {
        var DefaultImageProcessing: ImageProcessing = ImageProcessing.IMG_PROC_DEFAULT

        val instance: Globals = Globals()

        private var m_lastBitmap: Bitmap? = null

        fun ClearLastBitmap() {
            m_lastBitmap = null
        }

        fun GetLastBitmap(): Bitmap? {
            return m_lastBitmap
        }

        private var m_cacheIndex = 0
        private const val m_cacheSize = 2
        private val m_cachedBitmaps = ArrayList<Bitmap>()

        @Synchronized
        fun GetBitmapFromRaw(Src: ByteArray, width: Int, height: Int): Bitmap {
            val Bits = ByteArray(Src.size * 4)
            var i = 0
            i = 0
            while (i < Src.size) {
                Bits[i * 4 + 2] = Src[i]
                Bits[i * 4 + 1] = Bits[i * 4 + 2]
                Bits[i * 4] = Bits[i * 4 + 1]
                Bits[i * 4 + 3] = -1
                i++
            }

            var bitmap: Bitmap? = null
            if (m_cachedBitmaps.size == m_cacheSize) {
                bitmap = m_cachedBitmaps[m_cacheIndex]
            }

            if (bitmap == null) {
                bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                m_cachedBitmaps.add(m_cacheIndex, bitmap)
            } else if (bitmap.width != width || bitmap.height != height) {
                bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                m_cachedBitmaps[m_cacheIndex] = bitmap
            }
            m_cacheIndex = (m_cacheIndex + 1) % m_cacheSize

            bitmap.copyPixelsFromBuffer(ByteBuffer.wrap(Bits))

            // save bitmap to history to be restored when screen orientation changes
            m_lastBitmap = bitmap
            return bitmap
        }

        fun QualityToString(result: Reader.CaptureResult?): String {
            if (result == null) {
                return ""
            }
            if (result.quality == null) {
                return "An error occurred"
            }
            return when (result.quality) {
                CaptureQuality.FAKE_FINGER -> "Fake finger"
                CaptureQuality.NO_FINGER -> "No finger"
                CaptureQuality.CANCELED -> "Capture cancelled"
                CaptureQuality.TIMED_OUT -> "Capture timed out"
                CaptureQuality.FINGER_TOO_LEFT -> "Finger too left"
                CaptureQuality.FINGER_TOO_RIGHT -> "Finger too right"
                CaptureQuality.FINGER_TOO_HIGH -> "Finger too high"
                CaptureQuality.FINGER_TOO_LOW -> "Finger too low"
                CaptureQuality.FINGER_OFF_CENTER -> "Finger off center"
                CaptureQuality.SCAN_SKEWED -> "Scan skewed"
                CaptureQuality.SCAN_TOO_SHORT -> "Scan too short"
                CaptureQuality.SCAN_TOO_LONG -> "Scan too long"
                CaptureQuality.SCAN_TOO_SLOW -> "Scan too slow"
                CaptureQuality.SCAN_TOO_FAST -> "Scan too fast"
                CaptureQuality.SCAN_WRONG_DIRECTION -> "Wrong direction"
                CaptureQuality.READER_DIRTY -> "Reader dirty"
                CaptureQuality.GOOD -> "Image acquired"
                else -> "An error occurred"
            }
        }

        fun GetFirstDPI(reader: Reader): Int {
            val caps = reader.GetCapabilities()
            return caps.resolutions[0]
        }
    }
}