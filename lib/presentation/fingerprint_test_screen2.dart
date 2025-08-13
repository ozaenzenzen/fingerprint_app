import 'dart:typed_data';
import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/controller/register_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/finger_scanning/finish_scan_finger_screen.dart';
import 'package:fingerprint_app/service/fingerprint_service.dart';
import 'package:fingerprint_app/support/widget/app_glassmorphism_card_widget.dart';
import 'package:fingerprint_app/support/widget/app_glassmorphism_expansion_tile_widget.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FingerprintTestScreen2 extends StatefulWidget {
  const FingerprintTestScreen2({super.key});

  @override
  State<FingerprintTestScreen2> createState() => _FingerprintTestScreen2State();
}

class _FingerprintTestScreen2State extends State<FingerprintTestScreen2> {
  final RegisterController registerController = Get.find<RegisterController>();
  final FingerprintService _fingerprintService = FingerprintService();

  FingerprintAvailability? _availability;
  FingerprintDeviceInfo? _deviceInfo;
  FingerprintImage? _currentImage;
  Uint8List? _displayImage;
  String _status = 'Not initialized';
  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    // _setupListeners();
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
        // appBar: AppBar(
        //   title: Text('Fingerprint Scanner Demo'),
        //   backgroundColor: Colors.blue,
        // ),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xff004AA1),
                    Color(0xff01204C),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: kToolbarHeight),

                  // Status Card
                  AppGlassmorphismCardWidget(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 12.h,
                    ),
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Hardware:',
                          style: GoogleFonts.openSans(
                            color: const Color(0xffffffff),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _status,
                          style: GoogleFonts.openSans(
                            color: const Color(0xffffffff),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (_availability?.available == true) ...[
                          SizedBox(height: 4),
                          Text(
                            'Device: ${_availability!.deviceName}',
                            style: GoogleFonts.openSans(
                              color: Colors.green,
                              // color: const Color(0xffffffff),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            // style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MainButtonWidget(
                          onPressed: _checkAvailability,
                          title: "Check Availability",
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: MainButtonWidget(
                          onPressed: _availability?.available == true && !_isStreaming ? _captureImage : null,
                          title: "Capture Image",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Image Display
                  AppGlassmorphismCardWidget(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 12.h,
                    ),
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Text(
                          'Fingerprint Image',
                          style: GoogleFonts.openSans(
                            color: const Color(0xffffffff),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16),
                        _displayImage != null
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image.memory(
                                        _displayImage!,
                                        height: 200.h,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  if (_currentImage != null) ...[
                                    Text(
                                      'Size: ${_currentImage!.width}x${_currentImage!.height}',
                                      style: GoogleFonts.openSans(
                                        color: const Color(0xffffffff),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'DPI: ${_currentImage!.dpi}',
                                      style: GoogleFonts.openSans(
                                        color: const Color(0xffffffff),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'NFIQ Score: ${_currentImage!.nfiqScore ?? 'N/A'}',
                                      style: GoogleFonts.openSans(
                                        color: const Color(0xffffffff),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    if (_currentImage!.isGoodQuality)
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    else
                                      Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    SizedBox(height: 16.h),
                                    MainButtonWidget(
                                      title: "Simpan",
                                      width: MediaQuery.sizeOf(context).width,
                                      onPressed: () {
                                        if (_currentImage != null) {
                                          AppDialogActionCS.showWarningPopup(
                                            context: context,
                                            title: "Warning",
                                            description: "Apakah Anda sudah yakin dengan data ini?",
                                            mainButtonTitle: "Ya",
                                            mainButtonAction: () {
                                              Get.back();
                                              registerController.fingerprintData.value = _currentImage;
                                              Get.to(
                                                () => FinishScanFingerScreen(),
                                                binding: RegisterBinding(),
                                              );
                                            },
                                            isHorizontal: false,
                                            secondaryButtonColor: Colors.grey,
                                            secondaryButtonTitle: "Tidak",
                                            secondaryButtonAction: () {
                                              Get.back();
                                            },
                                          );
                                        } else {
                                          AppDialogActionCS.showFailedPopup(
                                            context: context,
                                            title: "Terjadi kesalahan",
                                            description: "Silakan mengulang proses lagi",
                                            mainButtonAction: () {
                                              Get.back();
                                            },
                                            buttonTitle: "Kembali",
                                            mainButtonColor: const Color(0xff1183FF),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ],
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 40.h),
                                    Icon(
                                      Icons.fingerprint,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'No fingerprint image',
                                      style: GoogleFonts.openSans(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Device Info
                  if (_deviceInfo != null)
                    AppGlassmorphismExpansionTileWidget(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                      margin: EdgeInsets.zero,
                      title: Text(
                        'Device Information',
                        style: GoogleFonts.openSans(
                          color: const Color(0xffffffff),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                ],
              ),
            ),
            SafeArea(
              child: Container(
                alignment: Alignment.centerLeft,
                height: kToolbarHeight,
                width: MediaQuery.sizeOf(context).width,
                // color: Colors.red,
                child: Stack(
                  children: [
                    Container(
                      // color: Colors.black,
                      height: 40.h,
                      alignment: Alignment.center,
                      child: Text(
                        "Fingerprint Scan",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        // color: Colors.amber,
                        height: 40.h,
                        width: 40.h,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            child: Text(
              '$label:',
              style: GoogleFonts.openSans(
                color: const Color(0xffffffff),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.openSans(
                color: const Color(0xffffffff),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
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
