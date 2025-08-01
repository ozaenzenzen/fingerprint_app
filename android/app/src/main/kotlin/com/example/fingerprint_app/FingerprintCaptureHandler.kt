package com.example.fingerprint_app

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log

import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.ByteArrayOutputStream

import com.digitalpersona.uareu.Fid
import com.digitalpersona.uareu.Quality
import com.digitalpersona.uareu.Reader
import com.digitalpersona.uareu.Reader.Priority
import com.digitalpersona.uareu.UareUException
import com.digitalpersona.uareu.jni.DpfjQuality

class FingerprintCaptureHandler(private val context: Context) {
    private var reader: Reader? = null
    private var dpi: Int = 0
    private var currentBitmap: Bitmap? = null
    private var isCapturing = false
    private var captureJob: Job? = null
    private var captureResult: Reader.CaptureResult? = null
    private var padEnabled = false
    private var currentImageProcessing = Reader.ImageProcessing.IMG_PROC_DEFAULT

    private val imageProcessingMap = mapOf(
        "DEFAULT" to Reader.ImageProcessing.IMG_PROC_DEFAULT,
        "PIV" to Reader.ImageProcessing.IMG_PROC_PIV,
        "ENHANCED" to Reader.ImageProcessing.IMG_PROC_ENHANCED,
        "ENHANCED_2" to Reader.ImageProcessing.IMG_PROC_ENHANCED_2
    )

    fun startCapture(
        deviceName: String,
        imageProcessing: String,
        padEnabled: Boolean,
        result: MethodChannel.Result
    ) {
        if (isCapturing) {
            result.error("ALREADY_CAPTURING", "Capture is already in progress", null)
            return
        }

        try {
            // Initialize reader
            System.out.println("deviceName1: $deviceName")
            reader = Globals().getReader(deviceName, context)
            reader?.let { r ->
                r.Open(Reader.Priority.EXCLUSIVE)
                dpi = getFirstDPI(r)

                // Set image processing mode
                setImageProcessingMode(imageProcessing)

                // Set PAD if supported
                setPadEnabled(padEnabled, result)

                // Start capture loop
                startCaptureLoop()

                isCapturing = true
                result.success(true)
            } ?: run {
                result.error("READER_ERROR", "Failed to initialize reader", null)
            }
        } catch (e: Exception) {
            Log.e("FingerprintCapture", "Error starting capture", e)
            result.error("START_ERROR", "Failed to start capture: ${e.message}", null)
        }
    }

    fun stopCapture(result: MethodChannel.Result) {
        try {
            isCapturing = false
            captureJob?.cancel()

            reader?.let { r ->
                try {
                    r.CancelCapture()
                } catch (e: Exception) {
                    println("[stopCapture] e: $e");
                    // Ignore cancel errors
                }
                r.Close()
            }
            reader = null

            result.success(true)
        } catch (e: Exception) {
            Log.e("FingerprintCapture", "Error stopping capture", e)
            result.error("STOP_ERROR", "Failed to stop capture: ${e.message}", null)
        }
    }

    fun getLatestImage(result: MethodChannel.Result) {
        try {
            currentBitmap?.let { bitmap ->
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                result.success(stream.toByteArray())
            } ?: run {
                result.success(null)
            }
        } catch (e: Exception) {
            result.error("IMAGE_ERROR", "Failed to get image: ${e.message}", null)
        }
    }

    fun getCaptureResult(result: MethodChannel.Result) {
        try {
            captureResult?.let { capResult ->
                val quality = DpfjQuality()
                var nfiqScore = 0
                var qualityString = ""

                capResult.image?.let { image ->
                    val imageView = image.views[0]
                    nfiqScore = quality.nfiq_raw(
                        imageView.imageData,
                        imageView.width,
                        imageView.height,
                        dpi,
                        image.bpp,
                        Quality.QualityAlgorithm.QUALITY_NFIQ_NIST
                    )
                }

                qualityString = qualityToString(capResult)

                val resultMap = mapOf(
                    "nfiqScore" to nfiqScore,
                    "qualityString" to qualityString,
                    "status" to "Captured successfully"
                )

                result.success(resultMap)
            } ?: run {
                result.success(
                    mapOf(
                        "nfiqScore" to 0,
                        "qualityString" to "No capture result",
                        "status" to "Waiting for capture..."
                    )
                )
            }
        } catch (e: Exception) {
            result.error("RESULT_ERROR", "Failed to get capture result: ${e.message}", null)
        }
    }

    fun setImageProcessing(mode: String, result: MethodChannel.Result) {
        try {
            setImageProcessingMode(mode)

            // Cancel current capture to apply new settings
            reader?.let { r ->
                try {
                    r.CancelCapture()
                } catch (e: Exception) {
                    // Ignore cancel errors
                }
            }

            result.success(true)
        } catch (e: Exception) {
            result.error("PROCESSING_ERROR", "Failed to set image processing: ${e.message}", null)
        }
    }

    fun setPadEnabled(enabled: Boolean, result: MethodChannel.Result) {
        try {
            reader?.let { r ->
                val params = ByteArray(1)
                params[0] = if (enabled) 1.toByte() else 0.toByte()

                r.SetParameter(Reader.ParamId.DPFPDD_PARMID_PAD_ENABLE, params)
                padEnabled = enabled
                result.success(true)
            } ?: run {
                result.error("NO_READER", "Reader not initialized", null)
            }
        } catch (e: Exception) {
            Log.e("FingerprintCapture", "Error setting PAD", e)
            result.error("PAD_ERROR", "Failed to set PAD: ${e.message}", null)
        }
    }

    fun getImageProcessingModes(deviceName: String, result: MethodChannel.Result) {
        try {
            val modes = getAvailableProcessingModes(deviceName)
            System.out.println("modes: $modes");
            result.success(modes)
        } catch (e: Exception) {
            result.error("MODES_ERROR", "Failed to get processing modes: ${e.message}", null)
        }
    }

    private fun setImageProcessingMode(mode: String) {
        currentImageProcessing = imageProcessingMap[mode] ?: Reader.ImageProcessing.IMG_PROC_DEFAULT
        Globals.DefaultImageProcessing = currentImageProcessing
    }

    private fun getAvailableProcessingModes(deviceName: String): List<String> {
        return try {
            val tempReader = Globals().getReader(deviceName, context)
            val vid = tempReader?.GetDescription()?.id?.vendor_id
            val pid = tempReader?.GetDescription()?.id?.product_id

            when {
                vid == 0x05ba && pid == 0x000a -> listOf("DEFAULT")
                vid == 0x05ba && pid == 0x000b -> listOf("DEFAULT", "PIV", "ENHANCED")
                vid == 0x05ba && pid == 0x000c -> listOf("DEFAULT")
                vid == 0x05ba && pid == 0x000d -> listOf("DEFAULT", "PIV", "ENHANCED", "ENHANCED_2")
                vid == 0x05ba && pid == 0x000e -> listOf("DEFAULT", "PIV", "ENHANCED", "ENHANCED_2")
                (vid == 0x080b && (pid == 0x010b || pid == 0x0109)) || (vid == 0x05ba && pid == 0x7340) ->
                    listOf("DEFAULT", "PIV", "ENHANCED")

                else -> listOf("DEFAULT")
            }
        } catch (e: Exception) {
            listOf("DEFAULT")
        }
    }

    private fun startCaptureLoop() {
        captureJob = CoroutineScope(Dispatchers.IO).launch {
            try {
                while (isCapturing) {
                    reader?.let { r ->
                        try {
                            // Synchronous capture
                            val result = r.Capture(
                                Fid.Format.ANSI_381_2004,
                                currentImageProcessing,
                                dpi,
                                -1
                            )

                            if (result != null) {
                                captureResult = result

                                result.image?.let { image ->
                                    val imageView = image.views[0]
                                    currentBitmap = getBitmapFromRaw(
                                        imageView.imageData,
                                        imageView.width,
                                        imageView.height
                                    )
                                } ?: run {
                                    // No image captured, use black bitmap
                                    currentBitmap = createBlackBitmap()
                                }
                            }
                        } catch (e: Exception) {
                            if (isCapturing) {
                                Log.e("FingerprintCapture", "Error during capture", e)
                            }
                        }
                    }

                    // Small delay to prevent excessive CPU usage
                    delay(100)
                }
            } catch (e: CancellationException) {
                // Capture was cancelled, this is expected
            } catch (e: Exception) {
                Log.e("FingerprintCapture", "Unexpected error in capture loop", e)
            }
        }
    }

    private fun getFirstDPI(reader: Reader): Int {
        return try {
            val capabilities = reader.GetCapabilities()
            capabilities.resolutions[0]
        } catch (e: Exception) {
            500 // Default DPI
        }
    }

    private fun getBitmapFromRaw(imageData: ByteArray, width: Int, height: Int): Bitmap {
        // Convert raw image data to bitmap
        // This is a simplified version - you may need to adjust based on your SDK
        val pixels = IntArray(width * height)
        for (i in imageData.indices) {
            val gray = imageData[i].toInt() and 0xFF
            pixels[i] = (0xFF shl 24) or (gray shl 16) or (gray shl 8) or gray
        }

        return Bitmap.createBitmap(pixels, width, height, Bitmap.Config.ARGB_8888)
    }

    private fun createBlackBitmap(): Bitmap {
        return Bitmap.createBitmap(300, 400, Bitmap.Config.ARGB_8888).apply {
            eraseColor(android.graphics.Color.BLACK)
        }
    }

    private fun qualityToString(result: Reader.CaptureResult): String {
        return try {
            when (result.quality) {
                Reader.CaptureQuality.GOOD -> "Good Quality"
                Reader.CaptureQuality.TIMED_OUT -> "Timed Out"
                Reader.CaptureQuality.CANCELED -> "Canceled"
                Reader.CaptureQuality.NO_FINGER -> "No Finger Detected"
                Reader.CaptureQuality.FAKE_FINGER -> "Fake Finger Detected"
                Reader.CaptureQuality.FINGER_TOO_LEFT -> "Finger Too Left"
                Reader.CaptureQuality.FINGER_TOO_RIGHT -> "Finger Too Right"
                Reader.CaptureQuality.FINGER_TOO_HIGH -> "Finger Too High"
                Reader.CaptureQuality.FINGER_TOO_LOW -> "Finger Too Low"
                Reader.CaptureQuality.FINGER_OFF_CENTER -> "Finger Off Center"
                Reader.CaptureQuality.SCAN_SKEWED -> "Scan Skewed"
                Reader.CaptureQuality.SCAN_TOO_SHORT -> "Scan Too Short"
                Reader.CaptureQuality.SCAN_TOO_LONG -> "Scan Too Long"
                Reader.CaptureQuality.SCAN_TOO_SLOW -> "Scan Too Slow"
                Reader.CaptureQuality.SCAN_TOO_FAST -> "Scan Too Fast"
                Reader.CaptureQuality.SCAN_WRONG_DIRECTION -> "Scan Wrong Direction"
                else -> "Unknown Quality"
            }
        } catch (e: Exception) {
            "Quality Unknown"
        }
    }
}