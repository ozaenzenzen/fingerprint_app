import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/logic/app_permission_handler.dart';
import 'package:fingerprint_app/presentation/home_screeen/binding/home_binding.dart';
import 'package:fingerprint_app/presentation/home_screeen/home_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/controller/register_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/finger_scanning/finish_scan_finger_screen.dart';
import 'package:fingerprint_app/service/fingerprint_service.dart';
import 'package:fingerprint_app/support/widget/app_glassmorphism_card_widget.dart';
import 'package:fingerprint_app/support/widget/app_glassmorphism_expansion_tile_widget.dart';
import 'package:fingerprint_app/support/widget/app_loading_overlay_widget.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

enum DeviceAvailability {
  idle,
  needPermissionCamera,
  // permissionCameraDone,
  needPermissionHardware,
  // permissionHardwareDone,
  deviceReady,
}

enum FingerprintCaptureFlowType { registerFlow, continueFlow }

class FingerprintTestScreen extends StatefulWidget {
  final FingerprintCaptureFlowType fingerprintCaptureFlowType;

  // const FingerprintTestScreen({super.key});
  const FingerprintTestScreen.registerFlow({
    super.key,
  }) : fingerprintCaptureFlowType = FingerprintCaptureFlowType.registerFlow;

  const FingerprintTestScreen.continueFlow({
    super.key,
  }) : fingerprintCaptureFlowType = FingerprintCaptureFlowType.continueFlow;

  @override
  State<FingerprintTestScreen> createState() => _FingerprintTestScreenState();
}

class _FingerprintTestScreenState extends State<FingerprintTestScreen> {
  final RegisterController registerController = Get.find<RegisterController>();
  final FingerprintService _fingerprintService = FingerprintService();

  FingerprintAvailabilityNewModel? _availability;
  // FingerprintAvailability? _availability;
  FingerprintPermission? _permission;
  FingerprintDeviceInfo? _deviceInfo;
  FingerprintImage? _currentImage;
  Uint8List? _displayImage;
  String _status = 'Not initialized';
  bool _isStreaming = false;
  bool _permissionGranted = false;
  // DeviceAvailability _deviceAvailability = DeviceAvailability.idle;

  @override
  void initState() {
    super.initState();
    // _setupListeners();
  }

  Future<void> _requestPermission() async {
    if (_availability?.available != true) {
      _showSnackBar('Check availability first', isError: true);
      return;
    }

    setState(() => _status = 'Requesting permission...');

    try {
      final permission = await _fingerprintService.requestPermission();
      setState(() {
        _permission = permission;
        _permissionGranted = permission.granted && permission.deviceReady;
        _status = permission.message;
      });

      if (permission.granted && permission.deviceReady) {
        _showSnackBar('Permission granted and device ready!');
        await _getDeviceInfo();
      } else if (permission.granted) {
        _showSnackBar('Permission granted but device not ready', isError: true);
      } else {
        _showSnackBar('Permission denied', isError: true);
      }
    } catch (e) {
      setState(() => _status = 'Permission error: $e');
      _showSnackBar('$e', isError: true);
    }
  }

  Future<void> _checkAvailability() async {
    setState(() {
      _status = 'Checking availability...';
      // _deviceAvailability = DeviceAvailability.needPermissionCamera;
    });

    try {
      bool result = await AppPermissionHandler.handlePermission(
        permission: Permission.camera,
        onPermanentlyDenied: () async {
          await AppPermissionHandler.openAppSettings();
        },
        onDenied: () async {
          AppDialogActionCS.showFailedPopup(
            context: context,
            title: "Terjadi kesalahan",
            description: "Anda harus membuka izin menggunakan kamera",
            buttonTitle: "Mengerti",
            mainButtonAction: () {
              Get.back();
            },
          );
        },
        onGranted: () async {
          final availability = await _fingerprintService.checkAvailabilityNew();
          log("availability: ${jsonEncode(availability)}");
          setState(() {
            _availability = availability;
            _status = availability.message;
            _permissionGranted = false; // Reset permission status
          });

          if (availability.available) {
            _showSnackBar('${availability.readersCount} device(s) found: ${availability.deviceName}');
          } else {
            _showSnackBar(availability.message, isError: true);
          }
          // final availability = await _fingerprintService.checkAvailability();
          // log("availability: $availability");
          // setState(() {
          //   _availability = availability;
          //   _status = availability.message;
          // });

          // if (availability.available) {
          //   _showSnackBar('Device ready: ${availability.deviceName}');
          //   await _getDeviceInfo();
          // } else {
          //   _showSnackBar(availability.message, isError: true);
          // }
        },
      );
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
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
        // if (_displayImage != null) {
        //   _saveImageToGallery(_displayImage!);
        //   // _saveImage(_displayImage!);
        // }
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

  // Function to save Uint8List to a file
  Future<void> _saveImage(Uint8List imageBytes) async {
    try {
      // Get the directory for saving the image
      final directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      final String fullPath = '$path/$fileName';

      // Write the Uint8List to a file
      final File imageFile = File(fullPath);
      await imageFile.writeAsBytes(imageBytes);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to $fullPath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    }
  }

  // Save Uint8List to Gallery
  Future<void> _saveImageToGallery(Uint8List imageBytes) async {
    try {
      // Step 1: Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File tempFile = File(tempPath);
      await tempFile.writeAsBytes(imageBytes);

      // Step 2: Save to Gallery using gallery_saver
      final bool? success = await GallerySaver.saveImage(
        tempPath,
        // albumName: 'MyAppImages',
      );

      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to Gallery')),
        );
      } else {
        throw Exception('Failed to save to Gallery');
      }

      // Step 3: Clean up the temporary file
      await tempFile.delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    }
  }

  String titleButtonAvailability = "Check Availability";

  void onPressedButtonAvailability() {
    if (_availability != null) {
      if (!_availability!.available && !_permissionGranted) {
        _checkAvailability.call();
      } else if (_availability!.available && !_permissionGranted) {
        _requestPermission.call();
      } else {
        _checkAvailability.call();
      }
    } else {
      _checkAvailability.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            // appBar: AppBar(
            //   title: Text('Fingerprint Scanner Demo'),
            //   backgroundColor: Colors.blue,
            // ),
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                              onPressed: (_availability != null && _availability!.available && !_permissionGranted) ? _requestPermission : _checkAvailability,
                              title: (_availability != null && _availability!.available && !_permissionGranted) ? "Request Permission" : "Check Availability",
                              // title: "Check Availability",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: MainButtonWidget(
                              onPressed: _availability?.available == true && _permissionGranted && !_isStreaming ? _captureImage : null,
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
                                          title: widget.fingerprintCaptureFlowType == FingerprintCaptureFlowType.registerFlow ? "Simpan" : "Verify",
                                          width: MediaQuery.of(context).size.width,
                                          onPressed: () {
                                            if (_currentImage != null) {
                                              AppDialogActionCS.showWarningPopup(
                                                context: context,
                                                title: "Warning",
                                                description: "Apakah Anda sudah yakin dengan data ini?",
                                                mainButtonTitle: "Ya",
                                                mainButtonColor: const Color(0xff1183FF),
                                                mainButtonAction: () async {
                                                  Get.back();
                                                  registerController.fingerprintData.value = _currentImage;
                                                  if (widget.fingerprintCaptureFlowType == FingerprintCaptureFlowType.registerFlow) {
                                                    await registerController.fingerprintProcess(
                                                      fingerprintImage: _currentImage!,
                                                      onSuccess: () {
                                                        Get.to(
                                                          () => FinishScanFingerScreen(),
                                                          binding: RegisterBinding(),
                                                        );
                                                      },
                                                      onFailed: (errorMessage) {
                                                        AppDialogActionCS.showFailedPopup(
                                                          context: context,
                                                          title: "Terjadi kesalahan",
                                                          description: errorMessage,
                                                          mainButtonAction: () {
                                                            Get.back();
                                                          },
                                                          buttonTitle: "Kembali",
                                                          mainButtonColor: const Color(0xff1183FF),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    await registerController.verifyFingerprint(
                                                      id: registerController.continueUserId.value,
                                                      fingerprintImage: _currentImage!,
                                                      onSuccess: (result) {
                                                        AppDialogActionCS.showSuccessPopup(
                                                          context: context,
                                                          title: "Berhasil",
                                                          description: "${result.message}",
                                                          mainButtonAction: () {
                                                            Get.back();
                                                          },
                                                          buttonTitle: "Kembali",
                                                          mainButtonColor: const Color(0xff1183FF),
                                                        );
                                                        // Get.to(
                                                        //   () => FinishScanFingerScreen(),
                                                        //   binding: RegisterBinding(),
                                                        // );
                                                      },
                                                      onFailed: (errorMessage) {
                                                        AppDialogActionCS.showFailedPopup(
                                                          context: context,
                                                          title: "Terjadi kesalahan",
                                                          description: errorMessage,
                                                          mainButtonAction: () {
                                                            Get.back();
                                                          },
                                                          buttonTitle: "Kembali",
                                                          mainButtonColor: const Color(0xff1183FF),
                                                        );
                                                      },
                                                    );
                                                  }
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
                    width: MediaQuery.of(context).size.width,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: 16.w,
                                // ),
                                alignment: Alignment.center,
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
                            InkWell(
                              onTap: () {
                                AppDialogActionCS.showWarningPopup(
                                  context: context,
                                  title: "Warning",
                                  description: "Proses Scan Fingerprint belum tersimpan. Apakah Anda yakin ingin ke halaman home?",
                                  mainButtonTitle: "Ya",
                                  mainButtonColor: const Color(0xff1183FF),
                                  mainButtonAction: () {
                                    Get.back();
                                    Get.offAll(
                                      () => HomeScreen(),
                                      binding: HomeBinding(),
                                    );
                                  },
                                  isHorizontal: false,
                                  secondaryButtonColor: Colors.grey,
                                  secondaryButtonTitle: "Tidak",
                                  secondaryButtonAction: () {
                                    Get.back();
                                  },
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                // color: Colors.amber,
                                height: 40.h,
                                width: 40.h,
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 20.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () {
              if (registerController.isLoading.value) {
                return AppOverlayLoadingWidget();
              } else {
                return SizedBox();
              }
            },
          ),
        ],
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
