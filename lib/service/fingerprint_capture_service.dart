import 'dart:developer';

import 'package:fam_coding_supply/logic/app_logger.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:async';

class FingerprintCaptureService {
  static const platform = MethodChannel('fingerprint_channel');

  // Get available fingerprint readers
  static Future<List<String>> getAvailableReaders() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getReaders');
      return result.cast<String>();
    } on PlatformException catch (e) {
      print("Failed to get readers: '${e.message}'");
      return [];
    }
  }

  // Initialize a specific reader by index
  static Future<bool> initializeReader(int readerIndex) async {
    try {
      final bool result = await platform.invokeMethod('initReader', {
        'readerIndex': readerIndex,
      });
      AppLoggerCS.debugLog("[initializeReader] result: $result");
      return result;
    } on PlatformException catch (e) {
      print("Failed to initialize reader: '${e.message}'");
      return false;
    }
  }

  // Get reader info by index
  static Future<Map<String, dynamic>?> getReaderInfo(int readerIndex) async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getReaderInfo', {
        'readerIndex': readerIndex,
      });
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get reader info: '${e.message}'");
      return null;
    }
  }

  // Check if readers are available
  static Future<bool> hasReaders() async {
    try {
      final bool result = await platform.invokeMethod('hasReaders');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check readers: '${e.message}'");
      return false;
    }
  }

  // Start capturing fingerprints
  static Future<bool> startCapture(
    String deviceName, {
    String imageProcessing = 'DEFAULT',
    bool padEnabled = false,
  }) async {
    try {
      final bool result = await platform.invokeMethod('startCapture', {
        'deviceName': deviceName,
        'imageProcessing': imageProcessing,
        'padEnabled': padEnabled,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to start capture: '${e.message}'");
      return false;
    }
  }

  // Stop capturing fingerprints
  static Future<bool> stopCapture() async {
    try {
      final bool result = await platform.invokeMethod('stopCapture');
      return result;
    } on PlatformException catch (e) {
      print("Failed to stop capture: '${e.message}'");
      return false;
    }
  }

  // Get the latest captured fingerprint image
  static Future<Uint8List?> getLatestImage() async {
    try {
      final Uint8List? result = await platform.invokeMethod('getLatestImage');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get latest image: '${e.message}'");
      return null;
    }
  }

  // Get capture result info
  static Future<Map<String, dynamic>?> getCaptureResult() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getCaptureResult');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get capture result: '${e.message}'");
      return null;
    }
  }

  // Change image processing mode
  static Future<bool> setImageProcessing(String mode) async {
    try {
      final bool result = await platform.invokeMethod('setImageProcessing', {
        'mode': mode,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to set image processing: '${e.message}'");
      return false;
    }
  }

  // Toggle PAD (Presentation Attack Detection)
  static Future<bool> setPadEnabled(bool enabled) async {
    try {
      final bool result = await platform.invokeMethod('setPadEnabled', {
        'enabled': enabled,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to set PAD: '${e.message}'");
      return false;
    }
  }

  // Get available image processing modes for a device
  static Future<List<String>> getAvailableImageProcessingModes(String deviceName) async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getImageProcessingModes', {
        'deviceName': deviceName,
      });
      return result.cast<String>();
    } on PlatformException catch (e) {
      print("Failed to get image processing modes: '${e.message}'");
      return ['DEFAULT'];
    }
  }
}
