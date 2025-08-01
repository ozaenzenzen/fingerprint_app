import 'dart:async';
import 'dart:typed_data';

import 'package:fingerprint_app/service/fingerprint_capture_service.dart';
import 'package:flutter/material.dart';

class FingerprintCaptureWidget extends StatefulWidget {
  final String deviceName;

  const FingerprintCaptureWidget({
    super.key,
    required this.deviceName,
  });

  @override
  State<FingerprintCaptureWidget> createState() => _FingerprintCaptureWidgetState();
}

class _FingerprintCaptureWidgetState extends State<FingerprintCaptureWidget> {
  bool _isCapturing = false;
  bool _padEnabled = false;
  String _selectedImageProcessing = 'DEFAULT';
  List<String> _availableProcessingModes = ['DEFAULT'];
  Uint8List? _currentImage;
  String _captureStatus = 'Ready to capture';
  String _qualityInfo = '';
  int _nfiqScore = 0;

  @override
  void initState() {
    super.initState();
    _loadImageProcessingModes();
    _setupImageUpdateTimer();
  }

  // String deviceName = "";

  Future<void> _loadImageProcessingModes() async {
    final modes = await FingerprintCaptureService.getAvailableImageProcessingModes(widget.deviceName);
    // debugPrint("modes: $modes");
    // deviceName = modes.first;
    setState(() {
      _availableProcessingModes = modes;
      if (modes.isNotEmpty) {
        _selectedImageProcessing = modes.first;
      }
    });
  }

  void _setupImageUpdateTimer() {
    // Update captured image every 500ms while capturing
    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (!_isCapturing || !mounted) {
        timer.cancel();
        return;
      }

      final image = await FingerprintCaptureService.getLatestImage();
      final result = await FingerprintCaptureService.getCaptureResult();

      if (mounted) {
        setState(() {
          _currentImage = image;
          if (result != null) {
            _qualityInfo = result['qualityString'] ?? '';
            _nfiqScore = result['nfiqScore'] ?? 0;
            _captureStatus = result['status'] ?? 'Capturing...';
          }
        });
      }
    });
  }

  Future<void> _startCapture() async {
    setState(() {
      _captureStatus = 'Starting capture...';
    });

    final success = await FingerprintCaptureService.startCapture(
      // deviceName,
      widget.deviceName,
      imageProcessing: _selectedImageProcessing,
      padEnabled: _padEnabled,
    );

    if (success) {
      setState(() {
        _isCapturing = true;
        _captureStatus = 'Capturing... Place finger on scanner';
      });
      _setupImageUpdateTimer();
    } else {
      setState(() {
        _captureStatus = 'Failed to start capture';
      });
    }
  }

  Future<void> _stopCapture() async {
    final success = await FingerprintCaptureService.stopCapture();
    setState(() {
      _isCapturing = false;
      _captureStatus = success ? 'Capture stopped' : 'Failed to stop capture';
    });
  }

  Future<void> _onImageProcessingChanged(String? value) async {
    if (value != null && value != _selectedImageProcessing) {
      setState(() {
        _selectedImageProcessing = value;
      });

      if (_isCapturing) {
        await FingerprintCaptureService.setImageProcessing(value);
      }
    }
  }

  Future<void> _onPadToggled(bool? value) async {
    if (value != null) {
      final success = await FingerprintCaptureService.setPadEnabled(value);
      if (success) {
        setState(() {
          _padEnabled = value;
        });
      }
    }
  }

  Widget _buildImageDisplay() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _currentImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                _currentImage!,
                fit: BoxFit.contain,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No fingerprint captured',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Capture Fingerprint'),
          // subtitle: Text(
          //   'Device: ${widget.deviceName}',
          // ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status: $_captureStatus',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      if (_qualityInfo.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Text('Quality: $_qualityInfo'),
                        Text('NFIQ Score: $_nfiqScore'),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Controls
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),

                      // Image Processing Dropdown
                      Row(
                        children: [
                          Text('Image Processing: '),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedImageProcessing,
                              onChanged: _isCapturing ? null : _onImageProcessingChanged,
                              items: _availableProcessingModes.map((String mode) {
                                return DropdownMenuItem<String>(
                                  value: mode,
                                  child: Text(mode),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // PAD Checkbox
                      CheckboxListTile(
                        title: Text('Enable PAD (Presentation Attack Detection)'),
                        value: _padEnabled,
                        onChanged: _onPadToggled,
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Image Display
              Expanded(
                child: Center(
                  child: _buildImageDisplay(),
                ),
              ),

              SizedBox(height: 16),

              // Control Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isCapturing ? null : _startCapture,
                      icon: Icon(Icons.play_arrow),
                      label: Text('Start Capture'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isCapturing ? _stopCapture : null,
                      icon: Icon(Icons.stop),
                      label: Text('Stop Capture'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isCapturing) {
      FingerprintCaptureService.stopCapture();
    }
    super.dispose();
  }
}
