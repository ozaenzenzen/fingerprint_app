package com.example.fingerprint_app

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import androidx.core.content.ContextCompat
import com.digitalpersona.uareu.*
import com.digitalpersona.uareu.dpfpddusbhost.DPFPDDUsbHost
import com.digitalpersona.uareu.dpfpddusbhost.DPFPDDUsbException
import com.digitalpersona.uareu.jni.DpfjQuality
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

//class FingerprintPlugin(private val context: Context, flutterEngine: FlutterEngine) : MethodCallHandler {
//
//    companion object {
//        private const val CHANNEL = "fingerprint_scanner"
//        private const val ACTION_USB_PERMISSION = "com.digitalpersona.uareu.dpfpddusbhost.USB_PERMISSION"
//    }
//
//    private val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//    private var reader: Reader? = null
//    private var isStreaming = false
//    private var streamingJob: Job? = null
//    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
//
//    private var currentResult: Result? = null
//    private var deviceName: String = ""
//    private var padEnabled = false
//
//    init {
//        channel.setMethodCallHandler(this)
//        // Enable tracing for debugging
//        System.setProperty("DPTRACE_ON", "1")
//    }
//
//    override fun onMethodCall(call: MethodCall, result: Result) {
//        when (call.method) {
//            "checkAvailability" -> checkAvailability(result)
//            "startStream" -> startStream(result)
//            "stopStream" -> stopStream(result)
//            "captureImage" -> captureImage(result)
//            "getDeviceInfo" -> getDeviceInfo(result)
//            "enablePAD" -> enablePAD(call.argument<Boolean>("enable") ?: false, result)
//            else -> result.notImplemented()
//        }
//    }
//
//    private fun checkAvailability(result: Result) {
//        scope.launch {
//            try {
//                val readers = withContext(Dispatchers.IO) {
//                    UareUGlobal.GetReaderCollection(context).apply { GetReaders() }
//                }
//
//                if (readers.size == 0) {
//                    result.success(mapOf(
//                        "available" to false,
//                        "message" to "No fingerprint readers found"
//                    ))
//                    return@launch
//                }
//
//                // Auto-select first available reader
//                val selectedReader = readers[0]
//                deviceName = selectedReader.GetDescription().name
//                reader = selectedReader
//
//                // Request USB permissions if needed
//                requestUsbPermission(selectedReader) { granted ->
//                    if (granted) {
//                        result.success(mapOf(
//                            "available" to true,
//                            "deviceName" to deviceName,
//                            "message" to "Fingerprint reader ready"
//                        ))
//                    } else {
//                        result.success(mapOf(
//                            "available" to false,
//                            "message" to "USB permission denied"
//                        ))
//                    }
//                }
//
//            } catch (e: Exception) {
//                result.error("AVAILABILITY_ERROR", e.message, null)
//            }
//        }
//    }
//
//    private fun startStream(result: Result) {
//        if (reader == null) {
//            result.error("NO_READER", "No reader available. Call checkAvailability first.", null)
//            return
//        }
//
//        if (isStreaming) {
//            result.error("ALREADY_STREAMING", "Stream is already active", null)
//            return
//        }
//
//        currentResult = result
//        isStreaming = true
//
//        streamingJob = scope.launch {
//            try {
//                withContext(Dispatchers.IO) {
//                    reader?.let { reader ->
//                        reader.Open(Reader.Priority.EXCLUSIVE)
//                        val dpi = reader.GetCapabilities().resolutions[0]
//
//                        while (isStreaming && !Thread.currentThread().isInterrupted) {
//                            try {
//                                val captureResult = reader.Capture(
//                                    Fid.Format.ANSI_381_2004,
//                                    Reader.ImageProcessing.IMG_PROC_DEFAULT,
//                                    dpi,
//                                    -1
//                                )
//
//                                captureResult?.let { result ->
//                                    val data = processCaptureResult(result, dpi)
//
//                                    withContext(Dispatchers.Main) {
//                                        channel.invokeMethod("onImageCaptured", data)
//                                    }
//                                }
//
//                            } catch (e: UareUException) {
//                                if (isStreaming) {
//                                    withContext(Dispatchers.Main) {
//                                        channel.invokeMethod("onError", mapOf(
//                                            "error" to "CAPTURE_ERROR",
//                                            "message" to e.message
//                                        ))
//                                    }
//                                }
//                                break
//                            }
//                        }
//
//                        reader.Close()
//                    }
//                }
//
//            } catch (e: Exception) {
//                withContext(Dispatchers.Main) {
//                    currentResult?.error("STREAM_ERROR", e.message, null)
//                    currentResult = null
//                }
//            }
//        }
//
//        result.success(mapOf("streaming" to true))
//    }
//
//    private fun stopStream(result: Result) {
//        isStreaming = false
//        streamingJob?.cancel()
//        println("[stopStream] here")
//
//        try {
//            reader?.CancelCapture()
//        } catch (e: Exception) {
//            println("[stopStream] e: $e")
//            result.error("STOP_STREAM", "Failed Stop Stream $e", null)
//            // Ignore cancellation errors
//        }
//        reader?.Close()
//        result.success(mapOf("streaming" to false))
//    }
//
//    private fun captureImage(result: Result) {
//        if (reader == null) {
//            result.error("NO_READER", "No reader available", null)
//            return
//        }
//
//        scope.launch {
//            try {
//                val data = withContext(Dispatchers.IO) {
//                    reader?.let { reader ->
//                        reader.Open(Reader.Priority.EXCLUSIVE)
//                        val dpi = reader.GetCapabilities().resolutions[0]
//
//                        val captureResult = reader.Capture(
//                            Fid.Format.ANSI_381_2004,
//                            Reader.ImageProcessing.IMG_PROC_DEFAULT,
//                            dpi,
//                            -1
//                        )
//
//                        val data = processCaptureResult(captureResult, dpi)
//                        reader.Close()
//                        data
//                    }
//                }
//
//                result.success(data)
//
//            } catch (e: Exception) {
//                result.error("CAPTURE_ERROR", e.message, null)
//            }
//        }
//    }
//
//    private fun getDeviceInfo(result: Result) {
//        if (reader == null) {
//            result.error("NO_READER", "No reader available", null)
//            return
//        }
//
//        scope.launch {
//            try {
//                val info = withContext(Dispatchers.IO) {
//                    reader?.let { reader ->
//                        reader.Open(Reader.Priority.COOPERATIVE)
//                        val description = reader.GetDescription()
//                        val capabilities = reader.GetCapabilities()
//                        reader.Close()
//
//                        mapOf(
//                            "name" to description.name,
//                            "serialNumber" to description.serial_number,
//                            "vendorId" to description.id.vendor_id,
//                            "productId" to description.id.product_id,
//                            "vendorName" to description.id.vendor_name,
//                            "productName" to description.id.product_name,
//                            "firmwareVersion" to "${description.version.firmware_version.major}.${description.version.firmware_version.minor}.${description.version.firmware_version.maintenance}",
//                            "hardwareVersion" to "${description.version.hardware_version.major}.${description.version.hardware_version.minor}.${description.version.hardware_version.maintenance}",
//                            "canCapture" to capabilities.can_capture,
//                            "canStream" to capabilities.can_stream,
//                            "resolutions" to capabilities.resolutions.toList(),
//                            "pivCompliant" to capabilities.piv_compliant
//                        )
//                    }
//                }
//
//                result.success(info)
//
//            } catch (e: Exception) {
//                result.error("INFO_ERROR", e.message, null)
//            }
//        }
//    }
//
//    private fun enablePAD(enable: Boolean, result: Result) {
//        if (reader == null) {
//            result.error("NO_READER", "No reader available", null)
//            return
//        }
//
//        scope.launch {
//            try {
//                withContext(Dispatchers.IO) {
//                    reader?.let { reader ->
//                        reader.Open(Reader.Priority.COOPERATIVE)
//                        val params = byteArrayOf(if (enable) 1 else 0)
//                        reader.SetParameter(Reader.ParamId.DPFPDD_PARMID_PAD_ENABLE, params)
//                        padEnabled = enable
//                        reader.Close()
//                    }
//                }
//
//                result.success(mapOf("padEnabled" to padEnabled))
//
//            } catch (e: Exception) {
//                result.error("PAD_ERROR", e.message, null)
//            }
//        }
//    }
//
//    private fun processCaptureResult(captureResult: Reader.CaptureResult, dpi: Int): Map<String, Any?> {
//        val data = mutableMapOf<String, Any?>()
//
//        // Quality status
//        data["quality"] = qualityToString(captureResult.quality)
//        data["qualityCode"] = captureResult.quality?.name
//
//        if (captureResult.image != null) {
//            val imageView = captureResult.image.getViews()[0]
//            val imageData = imageView.getImageData()
//            val width = imageView.getWidth()
//            val height = imageView.getHeight()
//
//            // Convert raw image to bitmap
//            val bitmap = getBitmapFromRaw(imageData, width, height)
//
//            // Convert bitmap to base64
//            val outputStream = ByteArrayOutputStream()
//            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
//            val base64Image = android.util.Base64.encodeToString(
//                outputStream.toByteArray(),
//                android.util.Base64.DEFAULT
//            )
//
//            // Calculate NFIQ score
//            val quality = DpfjQuality()
//            val nfiqScore = quality.nfiq_raw(
//                imageData,
//                width,
//                height,
//                dpi,
//                captureResult.image.getBpp(),
//                Quality.QualityAlgorithm.QUALITY_NFIQ_NIST
//            )
//
//            data["image"] = base64Image
//            data["width"] = width
//            data["height"] = height
//            data["dpi"] = dpi
//            data["nfiqScore"] = nfiqScore
//            data["hasImage"] = true
//        } else {
//            data["hasImage"] = false
//        }
//
//        return data
//    }
//
//    private fun getBitmapFromRaw(src: ByteArray, width: Int, height: Int): Bitmap {
//        val bits = ByteArray(src.size * 4)
//
//        for (i in src.indices) {
//            bits[i * 4] = src[i]     // Blue
//            bits[i * 4 + 1] = src[i] // Green
//            bits[i * 4 + 2] = src[i] // Red
//            bits[i * 4 + 3] = -1     // Alpha (255)
//        }
//
//        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
//        bitmap.copyPixelsFromBuffer(ByteBuffer.wrap(bits))
//        return bitmap
//    }
//
//    private fun qualityToString(quality: Reader.CaptureQuality?): String {
//        return when (quality) {
//            Reader.CaptureQuality.FAKE_FINGER -> "Fake finger"
//            Reader.CaptureQuality.NO_FINGER -> "No finger"
//            Reader.CaptureQuality.CANCELED -> "Capture cancelled"
//            Reader.CaptureQuality.TIMED_OUT -> "Capture timed out"
//            Reader.CaptureQuality.FINGER_TOO_LEFT -> "Finger too left"
//            Reader.CaptureQuality.FINGER_TOO_RIGHT -> "Finger too right"
//            Reader.CaptureQuality.FINGER_TOO_HIGH -> "Finger too high"
//            Reader.CaptureQuality.FINGER_TOO_LOW -> "Finger too low"
//            Reader.CaptureQuality.FINGER_OFF_CENTER -> "Finger off center"
//            Reader.CaptureQuality.SCAN_SKEWED -> "Scan skewed"
//            Reader.CaptureQuality.SCAN_TOO_SHORT -> "Scan too short"
//            Reader.CaptureQuality.SCAN_TOO_LONG -> "Scan too long"
//            Reader.CaptureQuality.SCAN_TOO_SLOW -> "Scan too slow"
//            Reader.CaptureQuality.SCAN_TOO_FAST -> "Scan too fast"
//            Reader.CaptureQuality.SCAN_WRONG_DIRECTION -> "Wrong direction"
//            Reader.CaptureQuality.READER_DIRTY -> "Reader dirty"
//            Reader.CaptureQuality.GOOD -> "Image acquired"
//            else -> "An error occurred"
//        }
//    }
//
//    private fun requestUsbPermission(reader: Reader, callback: (Boolean) -> Unit) {
//        try {
//            val permissionIntent = PendingIntent.getBroadcast(
//                context, 0, Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE
//            )
//
//            val filter = IntentFilter(ACTION_USB_PERMISSION)
//            val receiver = object : BroadcastReceiver() {
//                override fun onReceive(context: Context, intent: Intent) {
//                    val action = intent.action
//                    if (ACTION_USB_PERMISSION == action) {
//                        synchronized(this) {
//                            val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
//                            val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
//                            callback(granted && device != null)
//                        }
//                    }
//                }
//            }
//
//            ContextCompat.registerReceiver(context, receiver, filter, ContextCompat.RECEIVER_NOT_EXPORTED)
//
//            if (DPFPDDUsbHost.DPFPDDUsbCheckAndRequestPermissions(context, permissionIntent, deviceName)) {
//                callback(true)
//            }
//
//        } catch (e: DPFPDDUsbException) {
//            callback(false)
//        }
//    }
//
//    fun dispose() {
//        stopStream(object : Result {
//            override fun success(result: Any?) {}
//            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
//            override fun notImplemented() {}
//        })
//        scope.cancel()
//    }
//}

class FingerprintPlugin(private val context: Context, flutterEngine: FlutterEngine) :
    MethodCallHandler {

    companion object {
        private const val CHANNEL = "fingerprint_scanner"
        private const val ACTION_USB_PERMISSION =
            "com.digitalpersona.uareu.dpfpddusbhost.USB_PERMISSION"
    }

    private val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    private var reader: Reader? = null
    private var isStreaming = false
    private var streamingJob: Job? = null
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    private var currentResult: Result? = null
    private var deviceName: String = ""
    private var padEnabled = false

    init {
        channel.setMethodCallHandler(this)
        // Enable tracing for debugging
        System.setProperty("DPTRACE_ON", "1")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "checkAvailability" -> checkAvailability(result)
            "startStream" -> startStream(result)
            "stopStream" -> stopStream(result)
            "captureImage" -> captureImage(result)
            "getDeviceInfo" -> getDeviceInfo(result)
            "enablePAD" -> enablePAD(call.argument<Boolean>("enable") ?: false, result)
            else -> result.notImplemented()
        }
    }

    private fun checkAvailability(result: Result) {
        scope.launch {
            try {
                val readers = withContext(Dispatchers.IO) {
                    UareUGlobal.GetReaderCollection(context).apply { GetReaders() }
                }

                if (readers.size == 0) {
                    result.success(
                        mapOf(
                            "available" to false,
                            "message" to "No fingerprint readers found"
                        )
                    )
                    return@launch
                }

                // Auto-select first available reader
                val selectedReader = readers[0]
                deviceName = selectedReader.GetDescription().name
                reader = selectedReader

                // Request USB permissions if needed
                requestUsbPermission(selectedReader) { granted ->
                    if (granted) {
                        result.success(
                            mapOf(
                                "available" to true,
                                "deviceName" to deviceName,
                                "message" to "Fingerprint reader ready"
                            )
                        )
                    } else {
                        result.success(
                            mapOf(
                                "available" to false,
                                "message" to "USB permission denied"
                            )
                        )
                    }
                }

            } catch (e: Exception) {
                result.error("AVAILABILITY_ERROR", e.message, null)
            }
        }
    }

    private fun startStream(result: Result) {
        if (reader == null) {
            result.error("NO_READER", "No reader available. Call checkAvailability first.", null)
            return
        }

        if (isStreaming) {
            result.error("ALREADY_STREAMING", "Stream is already active", null)
            return
        }

        currentResult = result
        isStreaming = true

        streamingJob = scope.launch {
            var readerOpened = false
            try {
                withContext(Dispatchers.IO) {
                    reader?.let { reader ->
                        // Open reader with exclusive access
                        reader.Open(Reader.Priority.EXCLUSIVE)
                        readerOpened = true
                        val dpi = reader.GetCapabilities().resolutions[0]

                        while (isStreaming && !Thread.currentThread().isInterrupted) {
                            try {
                                // Check if reader is still valid before capture
                                if (!isReaderValid(reader)) {
                                    withContext(Dispatchers.Main) {
                                        channel.invokeMethod(
                                            "onError", mapOf(
                                                "error" to "READER_DISCONNECTED",
                                                "message" to "Fingerprint reader disconnected"
                                            )
                                        )
                                    }
                                    break
                                }

                                val captureResult = reader.Capture(
                                    Fid.Format.ANSI_381_2004,
                                    Reader.ImageProcessing.IMG_PROC_DEFAULT,
                                    dpi,
                                    -1
                                )

                                captureResult?.let { result ->
                                    val data = processCaptureResult(result, dpi)

                                    withContext(Dispatchers.Main) {
                                        channel.invokeMethod("onImageCaptured", data)
                                    }
                                }

                            } catch (e: UareUException) {
                                if (isStreaming) {
                                    // Check if it's a reader handle error
                                    if (e.code == UareUException.URU_E_INVALID_DEVICE ||
                                        e.message?.contains("Reader handle is not valid") == true
                                    ) {
                                        withContext(Dispatchers.Main) {
                                            channel.invokeMethod(
                                                "onError", mapOf(
                                                    "error" to "READER_DISCONNECTED",
                                                    "message" to "Fingerprint reader disconnected"
                                                )
                                            )
                                        }
                                        break
                                    } else {
                                        withContext(Dispatchers.Main) {
                                            channel.invokeMethod(
                                                "onError", mapOf(
                                                    "error" to "CAPTURE_ERROR",
                                                    "message" to e.message
                                                )
                                            )
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                }

            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    currentResult?.error("STREAM_ERROR", e.message, null)
                    currentResult = null
                }
            } finally {
                // Ensure reader is closed properly
                if (readerOpened) {
                    try {
                        reader?.Close()
                    } catch (e: Exception) {
                        android.util.Log.w(
                            "FingerprintPlugin",
                            "Error closing reader: ${e.message}"
                        )
                    }
                }
                isStreaming = false
            }
        }

        result.success(mapOf("streaming" to true))
    }

    private fun stopStream(result: Result) {
        isStreaming = false
        streamingJob?.cancel()

        // Check if reader is still valid before canceling capture
        try {
            reader?.let { reader ->
                // Check if reader is open and valid
                if (isReaderValid(reader)) {
                    reader.CancelCapture()
                }
            }
        } catch (e: UareUException) {
            // Log the error but don't fail the stop operation
            android.util.Log.w("FingerprintPlugin", "Error canceling capture: ${e.message}")
        } catch (e: Exception) {
            // Ignore other cancellation errors
            android.util.Log.w("FingerprintPlugin", "General error during stop: ${e.message}")
        }

        result.success(mapOf("streaming" to false))
    }

    private fun isReaderValid(reader: Reader): Boolean {
        return try {
            // Try to get reader status to check if it's still valid
            reader.GetStatus()
            true
        } catch (e: UareUException) {
            // Reader is not valid if we can't get status
            false
        } catch (e: Exception) {
            false
        }
    }

    private fun captureImage(result: Result) {
        if (reader == null) {
            result.error("NO_READER", "No reader available", null)
            return
        }

        scope.launch {
            try {
                val data = withContext(Dispatchers.IO) {
                    reader?.let { reader ->
                        reader.Open(Reader.Priority.EXCLUSIVE)
                        val dpi = reader.GetCapabilities().resolutions[0]

                        val captureResult = reader.Capture(
                            Fid.Format.ANSI_381_2004,
                            Reader.ImageProcessing.IMG_PROC_DEFAULT,
                            dpi,
                            -1
                        )

                        val data = processCaptureResult(captureResult, dpi)
                        reader.Close()
                        data
                    }
                }

                result.success(data)

            } catch (e: Exception) {
                result.error("CAPTURE_ERROR", e.message, null)
            }
        }
    }

    private fun getDeviceInfo(result: Result) {
        if (reader == null) {
            result.error("NO_READER", "No reader available", null)
            return
        }

        scope.launch {
            try {
                val info = withContext(Dispatchers.IO) {
                    reader?.let { reader ->
                        reader.Open(Reader.Priority.COOPERATIVE)
                        val description = reader.GetDescription()
                        val capabilities = reader.GetCapabilities()
                        reader.Close()

                        mapOf(
                            "name" to description.name,
                            "serialNumber" to description.serial_number,
                            "vendorId" to description.id.vendor_id,
                            "productId" to description.id.product_id,
                            "vendorName" to description.id.vendor_name,
                            "productName" to description.id.product_name,
                            "firmwareVersion" to "${description.version.firmware_version.major}.${description.version.firmware_version.minor}.${description.version.firmware_version.maintenance}",
                            "hardwareVersion" to "${description.version.hardware_version.major}.${description.version.hardware_version.minor}.${description.version.hardware_version.maintenance}",
                            "canCapture" to capabilities.can_capture,
                            "canStream" to capabilities.can_stream,
                            "resolutions" to capabilities.resolutions.toList(),
                            "pivCompliant" to capabilities.piv_compliant
                        )
                    }
                }

                result.success(info)

            } catch (e: Exception) {
                result.error("INFO_ERROR", e.message, null)
            }
        }
    }

    private fun enablePAD(enable: Boolean, result: Result) {
        if (reader == null) {
            result.error("NO_READER", "No reader available", null)
            return
        }

        scope.launch {
            try {
                withContext(Dispatchers.IO) {
                    reader?.let { reader ->
                        reader.Open(Reader.Priority.COOPERATIVE)
                        val params = byteArrayOf(if (enable) 1 else 0)
                        reader.SetParameter(Reader.ParamId.DPFPDD_PARMID_PAD_ENABLE, params)
                        padEnabled = enable
                        reader.Close()
                    }
                }

                result.success(mapOf("padEnabled" to padEnabled))

            } catch (e: Exception) {
                result.error("PAD_ERROR", e.message, null)
            }
        }
    }

    private fun processCaptureResult(
        captureResult: Reader.CaptureResult,
        dpi: Int
    ): Map<String, Any?> {
        val data = mutableMapOf<String, Any?>()

        // Quality status
        data["quality"] = qualityToString(captureResult.quality)
        data["qualityCode"] = captureResult.quality?.name

        if (captureResult.image != null) {
            val imageView = captureResult.image.getViews()[0]
            val imageData = imageView.getImageData()
            val width = imageView.getWidth()
            val height = imageView.getHeight()

            // Convert raw image to bitmap
            val bitmap = getBitmapFromRaw(imageData, width, height)

            // Convert bitmap to base64
            val outputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
            val base64Image = android.util.Base64.encodeToString(
                outputStream.toByteArray(),
                android.util.Base64.NO_WRAP
            )

            // Calculate NFIQ score
            val quality = DpfjQuality()
            val nfiqScore = quality.nfiq_raw(
                imageData,
                width,
                height,
                dpi,
                captureResult.image.getBpp(),
                Quality.QualityAlgorithm.QUALITY_NFIQ_NIST
            )

            data["image"] = base64Image
            data["width"] = width
            data["height"] = height
            data["dpi"] = dpi
            data["nfiqScore"] = nfiqScore
            data["hasImage"] = true
        } else {
            data["hasImage"] = false
        }

        return data
    }

    private fun getBitmapFromRaw(src: ByteArray, width: Int, height: Int): Bitmap {
        val bits = ByteArray(src.size * 4)

        for (i in src.indices) {
            bits[i * 4] = src[i]     // Blue
            bits[i * 4 + 1] = src[i] // Green
            bits[i * 4 + 2] = src[i] // Red
            bits[i * 4 + 3] = -1     // Alpha (255)
        }

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        bitmap.copyPixelsFromBuffer(ByteBuffer.wrap(bits))
        return bitmap
    }

    private fun qualityToString(quality: Reader.CaptureQuality?): String {
        return when (quality) {
            Reader.CaptureQuality.FAKE_FINGER -> "Fake finger"
            Reader.CaptureQuality.NO_FINGER -> "No finger"
            Reader.CaptureQuality.CANCELED -> "Capture cancelled"
            Reader.CaptureQuality.TIMED_OUT -> "Capture timed out"
            Reader.CaptureQuality.FINGER_TOO_LEFT -> "Finger too left"
            Reader.CaptureQuality.FINGER_TOO_RIGHT -> "Finger too right"
            Reader.CaptureQuality.FINGER_TOO_HIGH -> "Finger too high"
            Reader.CaptureQuality.FINGER_TOO_LOW -> "Finger too low"
            Reader.CaptureQuality.FINGER_OFF_CENTER -> "Finger off center"
            Reader.CaptureQuality.SCAN_SKEWED -> "Scan skewed"
            Reader.CaptureQuality.SCAN_TOO_SHORT -> "Scan too short"
            Reader.CaptureQuality.SCAN_TOO_LONG -> "Scan too long"
            Reader.CaptureQuality.SCAN_TOO_SLOW -> "Scan too slow"
            Reader.CaptureQuality.SCAN_TOO_FAST -> "Scan too fast"
            Reader.CaptureQuality.SCAN_WRONG_DIRECTION -> "Wrong direction"
            Reader.CaptureQuality.READER_DIRTY -> "Reader dirty"
            Reader.CaptureQuality.GOOD -> "Image acquired"
            else -> "An error occurred"
        }
    }

    private fun requestUsbPermission(reader: Reader, callback: (Boolean) -> Unit) {
        try {
            val permissionIntent = PendingIntent.getBroadcast(
                context, 0, Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_IMMUTABLE
            )

            val filter = IntentFilter(ACTION_USB_PERMISSION)
            val receiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context, intent: Intent) {
                    val action = intent.action
                    if (ACTION_USB_PERMISSION == action) {
                        synchronized(this) {
                            val device =
                                intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
                            val granted =
                                intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
                            callback(granted && device != null)
                        }
                    }
                }
            }

            ContextCompat.registerReceiver(
                context,
                receiver,
                filter,
                ContextCompat.RECEIVER_NOT_EXPORTED
            )

            if (DPFPDDUsbHost.DPFPDDUsbCheckAndRequestPermissions(
                    context,
                    permissionIntent,
                    deviceName
                )
            ) {
                callback(true)
            }

        } catch (e: DPFPDDUsbException) {
            callback(false)
        }
    }

    fun dispose() {
        stopStream(object : Result {
            override fun success(result: Any?) {}
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {}
            override fun notImplemented() {}
        })

        // Clean up reader resources
        cleanupReader()
        scope.cancel()
    }

    private fun cleanupReader() {
        try {
            reader?.let { reader ->
                if (isReaderValid(reader)) {
                    try {
                        reader.CancelCapture()
                    } catch (e: Exception) {
                        // Ignore
                    }

                    try {
                        reader.Close()
                    } catch (e: Exception) {
                        // Ignore
                    }
                }
            }
        } catch (e: Exception) {
            android.util.Log.w("FingerprintPlugin", "Error during cleanup: ${e.message}")
        } finally {
            reader = null
        }
    }
}
