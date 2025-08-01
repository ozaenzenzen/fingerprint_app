import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class FingerprintService {
  static const MethodChannel _channel = MethodChannel('fingerprint_scanner');

  // Stream controllers for real-time data
  final StreamController<FingerprintImage> _imageStreamController = StreamController<FingerprintImage>.broadcast();
  final StreamController<String> _errorStreamController = StreamController<String>.broadcast();

  // Streams for listening to fingerprint data
  Stream<FingerprintImage> get imageStream => _imageStreamController.stream;
  Stream<String> get errorStream => _errorStreamController.stream;

  bool _isInitialized = false;
  bool _isStreaming = false;

  FingerprintService() {
    _setupMethodCallHandler();
  }

  void _setupMethodCallHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onImageCaptured':
          final data = Map<String, dynamic>.from(call.arguments);
          final image = FingerprintImage.fromMap(data);
          _imageStreamController.add(image);
          break;
        case 'onError':
          final data = Map<String, dynamic>.from(call.arguments);
          _errorStreamController.add(data['message'] ?? 'Unknown error');
          break;
      }
    });
  }

  /// Check if fingerprint reader is available and ready
  Future<FingerprintAvailability> checkAvailability() async {
    try {
      final result = await _channel.invokeMethod('checkAvailability');
      final data = Map<String, dynamic>.from(result);

      _isInitialized = data['available'] ?? false;

      return FingerprintAvailability(
        available: data['available'] ?? false,
        deviceName: data['deviceName'],
        message: data['message'] ?? '',
      );
    } on PlatformException catch (e) {
      return FingerprintAvailability(
        available: false,
        message: e.message ?? 'Unknown error',
      );
    }
  }

  /// Start continuous fingerprint streaming
  Future<bool> startStream() async {
    if (!_isInitialized) {
      throw FingerprintException('Device not initialized. Call checkAvailability first.');
    }

    if (_isStreaming) {
      return true;
    }

    try {
      final result = await _channel.invokeMethod('startStream');
      final data = Map<String, dynamic>.from(result);
      _isStreaming = data['streaming'] ?? false;
      return _isStreaming;
    } on PlatformException catch (e) {
      throw FingerprintException(e.message ?? 'Failed to start stream');
    }
  }

  /// Stop fingerprint streaming
  Future<bool> stopStream() async {
    if (!_isStreaming) {
      return true;
    }

    try {
      final result = await _channel.invokeMethod('stopStream');
      final data = Map<String, dynamic>.from(result);
      _isStreaming = !(data['streaming'] ?? true);
      return !_isStreaming;
    } on PlatformException catch (e) {
      throw FingerprintException(e.message ?? 'Failed to stop stream');
    }
  }

  /// Capture a single fingerprint image
  Future<FingerprintImage> captureImage() async {
    if (!_isInitialized) {
      throw FingerprintException('Device not initialized. Call checkAvailability first.');
    }

    try {
      final result = await _channel.invokeMethod('captureImage');
      final data = Map<String, dynamic>.from(result);
      return FingerprintImage.fromMap(data);
    } on PlatformException catch (e) {
      throw FingerprintException(e.message ?? 'Failed to capture image');
    }
  }

  /// Get device information
  Future<FingerprintDeviceInfo> getDeviceInfo() async {
    if (!_isInitialized) {
      throw FingerprintException('Device not initialized. Call checkAvailability first.');
    }

    try {
      final result = await _channel.invokeMethod('getDeviceInfo');
      final data = Map<String, dynamic>.from(result);
      return FingerprintDeviceInfo.fromMap(data);
    } on PlatformException catch (e) {
      throw FingerprintException(e.message ?? 'Failed to get device info');
    }
  }

  /// Enable/disable Presentation Attack Detection (PAD)
  Future<bool> enablePAD(bool enable) async {
    if (!_isInitialized) {
      throw FingerprintException('Device not initialized. Call checkAvailability first.');
    }

    try {
      final result = await _channel.invokeMethod('enablePAD', {'enable': enable});
      final data = Map<String, dynamic>.from(result);
      return data['padEnabled'] ?? false;
    } on PlatformException catch (e) {
      throw FingerprintException(e.message ?? 'Failed to set PAD');
    }
  }

  /// Get current streaming status
  bool get isStreaming => _isStreaming;

  /// Get initialization status
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    stopStream();
    _imageStreamController.close();
    _errorStreamController.close();
  }
}

/// Fingerprint availability result
class FingerprintAvailability {
  final bool available;
  final String? deviceName;
  final String message;

  FingerprintAvailability({
    required this.available,
    this.deviceName,
    required this.message,
  });

  @override
  String toString() => 'FingerprintAvailability(available: $available, deviceName: $deviceName, message: $message)';
}

/// Fingerprint image data with quality metrics
class FingerprintImage {
  final String? base64Image;
  final int? width;
  final int? height;
  final int? dpi;
  final int? nfiqScore;
  final String quality;
  final String? qualityCode;
  final bool hasImage;

  FingerprintImage({
    this.base64Image,
    this.width,
    this.height,
    this.dpi,
    this.nfiqScore,
    required this.quality,
    this.qualityCode,
    required this.hasImage,
  });

  factory FingerprintImage.fromMap(Map<String, dynamic> map) {
    return FingerprintImage(
      base64Image: map['image'],
      width: map['width'],
      height: map['height'],
      dpi: map['dpi'],
      nfiqScore: map['nfiqScore'],
      quality: map['quality'] ?? 'Unknown',
      qualityCode: map['qualityCode'],
      hasImage: map['hasImage'] ?? false,
    );
  }

  /// Convert base64 image to bytes
  Uint8List? get imageBytes => base64Image != null ? base64Decode(base64Image!) : null;

  /// Check if the image quality is good
  bool get isGoodQuality => qualityCode == 'GOOD';

  /// Check if NFIQ score is acceptable (1-4, where 1 is best)
  bool get isAcceptableNFIQ => nfiqScore != null && nfiqScore! <= 4;

  @override
  String toString() => 'FingerprintImage(quality: $quality, nfiqScore: $nfiqScore, hasImage: $hasImage)';
}

/// Device information
class FingerprintDeviceInfo {
  final String name;
  final String serialNumber;
  final int vendorId;
  final int productId;
  final String vendorName;
  final String productName;
  final String firmwareVersion;
  final String hardwareVersion;
  final bool canCapture;
  final bool canStream;
  final List<int> resolutions;
  final bool pivCompliant;

  FingerprintDeviceInfo({
    required this.name,
    required this.serialNumber,
    required this.vendorId,
    required this.productId,
    required this.vendorName,
    required this.productName,
    required this.firmwareVersion,
    required this.hardwareVersion,
    required this.canCapture,
    required this.canStream,
    required this.resolutions,
    required this.pivCompliant,
  });

  factory FingerprintDeviceInfo.fromMap(Map<String, dynamic> map) {
    return FingerprintDeviceInfo(
      name: map['name'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      vendorId: map['vendorId'] ?? 0,
      productId: map['productId'] ?? 0,
      vendorName: map['vendorName'] ?? '',
      productName: map['productName'] ?? '',
      firmwareVersion: map['firmwareVersion'] ?? '',
      hardwareVersion: map['hardwareVersion'] ?? '',
      canCapture: map['canCapture'] ?? false,
      canStream: map['canStream'] ?? false,
      resolutions: List<int>.from(map['resolutions'] ?? []),
      pivCompliant: map['pivCompliant'] ?? false,
    );
  }

  @override
  String toString() => 'FingerprintDeviceInfo(name: $name, vendorName: $vendorName, productName: $productName)';
}

/// Custom exception for fingerprint operations
class FingerprintException implements Exception {
  final String message;

  FingerprintException(this.message);

  @override
  String toString() => 'FingerprintException: $message';
}
