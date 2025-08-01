package com.example.fingerprint_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private var fingerprintPlugin: FingerprintPlugin? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        fingerprintPlugin = FingerprintPlugin(this, flutterEngine)
    }

    override fun onDestroy() {
        fingerprintPlugin?.dispose()
        super.onDestroy()
    }
}

//class MainActivity : FlutterActivity() {
//    private val channel = "fingerprint_channel"
//    private lateinit var fingerprintHandler: FingerprintHandler
//    private lateinit var captureHandler: FingerprintCaptureHandler
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        fingerprintHandler = FingerprintHandler(this)
//        captureHandler = FingerprintCaptureHandler(this)
//
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            channel,
//        ).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "getReaders" -> {
//                    fingerprintHandler.getReaders(result)
//                }
//                "initReader" -> {
//                    val readerIndex = call.argument<Int>("readerIndex") ?: -1
//                    fingerprintHandler.initializeReader(readerIndex, result)
//                }
//                "getReaderInfo" -> {
//                    val readerIndex = call.argument<Int>("readerIndex") ?: -1
//                    fingerprintHandler.getReaderInfo(readerIndex, result)
//                }
//                "hasReaders" -> {
//                    fingerprintHandler.hasReaders(result)
//                }
//                "startCapture" -> {
//                    val deviceName = call.argument<String>("deviceName") ?: ""
//                    val imageProcessing = call.argument<String>("imageProcessing") ?: "DEFAULT"
//                    val padEnabled = call.argument<Boolean>("padEnabled") ?: false
//                    captureHandler.startCapture(deviceName, imageProcessing, padEnabled, result)
//                }
//                "stopCapture" -> {
//                    captureHandler.stopCapture(result)
//                }
//                "getLatestImage" -> {
//                    captureHandler.getLatestImage(result)
//                }
//                "getCaptureResult" -> {
//                    captureHandler.getCaptureResult(result)
//                }
//                "setImageProcessing" -> {
//                    val mode = call.argument<String>("mode") ?: "DEFAULT"
//                    captureHandler.setImageProcessing(mode, result)
//                }
//                "setPadEnabled" -> {
//                    val enabled = call.argument<Boolean>("enabled") ?: false
//                    captureHandler.setPadEnabled(enabled, result)
//                }
//                "getImageProcessingModes" -> {
//                    val deviceName = call.argument<String>("deviceName") ?: ""
//                    captureHandler.getImageProcessingModes(deviceName, result)
//                }
//                else -> {
//                    result.notImplemented()
//                }
//            }
//        }
//    }
//}