import 'dart:typed_data';
import 'package:fingerprint_app/service/fingerprint_service.dart';
import 'package:flutter/material.dart';

class FingerprintDemoScreen extends StatefulWidget {
  const FingerprintDemoScreen({super.key});

  @override
  State<FingerprintDemoScreen> createState() => _FingerprintDemoScreenState();
}

class _FingerprintDemoScreenState extends State<FingerprintDemoScreen> {
  final FingerprintService _fingerprintService = FingerprintService();

  FingerprintAvailability? _availability;
  FingerprintDeviceInfo? _deviceInfo;
  FingerprintImage? _currentImage;
  Uint8List? _displayImage;
  String _status = 'Not initialized';
  bool _isStreaming = false;
  bool _padEnabled = false;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    // Listen to fingerprint images
    _fingerprintService.imageStream.listen((image) {
      setState(() {
        _currentImage = image;
        _displayImage = image.imageBytes;
        _status = '${image.quality} (NFIQ: ${image.nfiqScore ?? 'N/A'})';
      });
    });

    // Listen to errors
    _fingerprintService.errorStream.listen((error) {
      setState(() {
        _status = 'Error: $error';
      });
      _showSnackBar(error, isError: true);
    });
  }

  Future<void> _checkAvailability() async {
    setState(() => _status = 'Checking availability...');

    try {
      final availability = await _fingerprintService.checkAvailability();
      setState(() {
        _availability = availability;
        _status = availability.message;
      });

      if (availability.available) {
        _showSnackBar('Device ready: ${availability.deviceName}');
        await _getDeviceInfo();
      } else {
        _showSnackBar(availability.message, isError: true);
      }
    } catch (e) {
      setState(() => _status = 'Error: $e');
      _showSnackBar('$e', isError: true);
    }
  }

  Future<void> _getDeviceInfo() async {
    try {
      final info = await _fingerprintService.getDeviceInfo();
      setState(() => _deviceInfo = info);
    } catch (e) {
      _showSnackBar('Failed to get device info: $e', isError: true);
    }
  }

  Future<void> _startStream() async {
    if (!_fingerprintService.isInitialized) {
      _showSnackBar('Device not initialized', isError: true);
      return;
    }

    setState(() => _status = 'Starting stream...');

    try {
      final success = await _fingerprintService.startStream();
      setState(() {
        _isStreaming = success;
        _status = success ? 'Streaming active - place finger on scanner' : 'Failed to start stream';
      });

      if (success) {
        _showSnackBar('Streaming started');
      }
    } catch (e) {
      setState(() {
        _status = 'Stream error: $e';
        _isStreaming = false;
      });
      _showSnackBar('$e', isError: true);
    }
  }

  Future<void> _stopStream() async {
    setState(() => _status = 'Stopping stream...');

    try {
      final success = await _fingerprintService.stopStream();
      setState(() {
        _isStreaming = !success;
        _status = success ? 'Stream stopped' : 'Failed to stop stream';
      });

      if (success) {
        _showSnackBar('Streaming stopped');
      }
    } catch (e) {
      setState(() => _status = 'Stop error: $e');
      _showSnackBar('$e', isError: true);
    }
  }

  Future<void> _captureImage() async {
    if (!_fingerprintService.isInitialized) {
      _showSnackBar('Device not initialized', isError: true);
      return;
    }

    setState(() => _status = 'Capturing image...');

    try {
      final image = await _fingerprintService.captureImage();
      setState(() {
        _currentImage = image;
        _displayImage = image.imageBytes;
        _status = '${image.quality} (NFIQ: ${image.nfiqScore ?? 'N/A'})';
      });

      if (image.isGoodQuality) {
        _showSnackBar('Good quality image captured!');
      } else {
        _showSnackBar('Poor quality: ${image.quality}', isError: true);
      }
    } catch (e) {
      setState(() => _status = 'Capture error: $e');
      _showSnackBar('$e', isError: true);
    }
  }

  Future<void> _togglePAD() async {
    if (!_fingerprintService.isInitialized) {
      _showSnackBar('Device not initialized', isError: true);
      return;
    }

    try {
      final enabled = await _fingerprintService.enablePAD(!_padEnabled);
      setState(() => _padEnabled = enabled);
      _showSnackBar('PAD ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      _showSnackBar('PAD toggle failed: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fingerprint Scanner Demo'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status', style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(height: 8),
                      Text(_status, style: TextStyle(fontSize: 16)),
                      if (_availability?.available == true) ...[
                        SizedBox(height: 8),
                        Text('Device: ${_availability!.deviceName}', style: TextStyle(color: Colors.green)),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Control Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: _checkAvailability,
                    icon: Icon(Icons.search),
                    label: Text('Check Availability'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _availability?.available == true && !_isStreaming ? _startStream : null,
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start Stream'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isStreaming ? _stopStream : null,
                    icon: Icon(Icons.stop),
                    label: Text('Stop Stream'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  ElevatedButton.icon(
                    onPressed: _availability?.available == true && !_isStreaming ? _captureImage : null,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Capture Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _availability?.available == true ? _togglePAD : null,
                    icon: Icon(_padEnabled ? Icons.security : Icons.security_outlined),
                    label: Text('PAD: ${_padEnabled ? 'ON' : 'OFF'}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _padEnabled ? Colors.orange : Colors.grey,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Image Display
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Fingerprint Image', style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(height: 16),
                        Expanded(
                          child: _displayImage != null
                              ? Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(7),
                                          child: Image.memory(
                                            _displayImage!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    if (_currentImage != null) ...[
                                      Text('Size: ${_currentImage!.width}x${_currentImage!.height}'),
                                      Text('DPI: ${_currentImage!.dpi}'),
                                      Text('NFIQ Score: ${_currentImage!.nfiqScore ?? 'N/A'}'),
                                      if (_currentImage!.isGoodQuality) Icon(Icons.check_circle, color: Colors.green) else Icon(Icons.error, color: Colors.red),
                                    ],
                                  ],
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fingerprint, size: 100, color: Colors.grey),
                                      Text('No fingerprint image', style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Device Info
              if (_deviceInfo != null)
                Card(
                  child: ExpansionTile(
                    title: Text('Device Information'),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Name', _deviceInfo!.name),
                            _buildInfoRow('Serial', _deviceInfo!.serialNumber),
                            _buildInfoRow('Vendor', _deviceInfo!.vendorName),
                            _buildInfoRow('Product', _deviceInfo!.productName),
                            _buildInfoRow('Firmware', _deviceInfo!.firmwareVersion),
                            _buildInfoRow('Hardware', _deviceInfo!.hardwareVersion),
                            _buildInfoRow('Can Capture', _deviceInfo!.canCapture.toString()),
                            _buildInfoRow('Can Stream', _deviceInfo!.canStream.toString()),
                            _buildInfoRow('PIV Compliant', _deviceInfo!.pivCompliant.toString()),
                            _buildInfoRow('Resolutions', _deviceInfo!.resolutions.join(', ')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fingerprintService.dispose();
    super.dispose();
  }
}
