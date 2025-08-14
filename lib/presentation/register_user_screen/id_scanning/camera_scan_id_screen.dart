import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/controller/register_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/id_scanning/result_camera_scan_id_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/support/camera_ocr_data_model.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/ocr_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas_mlkit/saas_mlkit.dart';

class CameraScanIdScreen extends StatefulWidget {
  final Function(String? textDetected)? callback;
  final Function(String? mapping)? callbackKTPMapping;
  final Function(String? mapping)? callbackSIMMapping;
  final Function(String? image)? callbackImage;
  final Function(String? image)? callbackImageCard;

  const CameraScanIdScreen({
    super.key,
    this.callback,
    this.callbackKTPMapping,
    this.callbackSIMMapping,
    this.callbackImage,
    this.callbackImageCard,
  });

  @override
  State<CameraScanIdScreen> createState() => _CameraScanIdScreenState();
}

class _CameraScanIdScreenState extends State<CameraScanIdScreen> {
  CameraController? cameraController;
  bool isLoadingScreen = false;

  CameraOcrDataModel dataHolder = CameraOcrDataModel();
  // Map<String, dynamic> dataHolder = {};

  final RegisterController registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                SaasOCRCamera(
                  captureButton: Container(
                    width: 96.h,
                    height: 96.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        // color: const Color(0xFF6F6F6F),
                        width: 2,
                      ),
                    ),
                    child: Container(
                      width: 80.h,
                      height: 80.h,
                      alignment: Alignment.bottomCenter,
                      // margin: const EdgeInsets.all(6.81),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          // color: Colors.transparent,
                          // color: Colors.red,
                          color: Colors.black87,
                          // color: const Color(0xFF6F6F6F),
                          width: 8,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          child: Image.asset(
                            AppAssets.iconCamera1,
                            height: 32.h,
                            width: 32.h,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onControllerCreated: (controller) {
                    cameraController = controller;
                  },
                  onTakePict: (String base64Image) async {
                    widget.callbackImageCard?.call(base64Image);
                    dataHolder.imageCard = base64Image;
                    if (InitConfig.useOCRApi) {
                      if (dataHolder.imageCard != null) {
                        setState(() {
                          isLoadingScreen = true;
                        });
                        await registerController.ocrApiKtp(
                          ktpImage: dataHolder.imageCard!,
                          onSuccess: (KTPData resultKtpData) {
                            setState(() {
                              isLoadingScreen = false;
                            });
                            dataHolder.ktpData = resultKtpData;
                            Get.to(
                              () => ResultCameraScanIdScreen(
                                dataOCR: dataHolder,
                                retryCaptureCallback: () {
                                  cameraController?.resumePreview();
                                  dataHolder = CameraOcrDataModel();
                                },
                              ),
                              binding: RegisterBinding(),
                            );
                          },
                          onFailed: (errorMessage) {
                            setState(() {
                              isLoadingScreen = false;
                            });
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
                        setState(() {
                          isLoadingScreen = false;
                        });
                        AppDialogActionCS.showFailedPopup(
                          context: context,
                          title: "Terjadi kesalahan",
                          description: "Support data is null, please try again",
                          mainButtonAction: () {
                            Get.back();
                            cameraController?.resumePreview();
                          },
                          buttonTitle: "Kembali",
                          mainButtonColor: const Color(0xff1183FF),
                        );
                      }
                    }
                  },
                  croppedFaceCard: (String? base64Image) {
                    widget.callbackImage?.call(base64Image);
                    dataHolder.imageFromCard = base64Image;
                  },
                  onTextDetected: (RecognizedText recognizedText) async {
                    KTPData? handler = await compute(OCRHandler().recognizedText, recognizedText);
                    debugPrint('data recognizedText ${handler?.toJson()}');
                    widget.callback?.call(handler!.toJson().toString());
                    if (!InitConfig.useOCRApi) {
                      if (dataHolder.imageCard != null) {
                        Get.to(
                          () => ResultCameraScanIdScreen(
                            dataOCR: dataHolder,
                            retryCaptureCallback: () {
                              cameraController?.resumePreview();
                              dataHolder = CameraOcrDataModel();
                            },
                          ),
                          binding: RegisterBinding(),
                        );
                      } else {
                        AppDialogActionCS.showFailedPopup(
                          context: context,
                          title: "Terjadi kesalahan",
                          description: "Support data is null, please try again",
                          mainButtonAction: () {
                            Get.back();
                            cameraController?.resumePreview();
                          },
                          buttonTitle: "Kembali",
                          mainButtonColor: const Color(0xff1183FF),
                        );
                      }
                    }
                  },
                  onKTPDetected: (KTPData ktpData) {
                    debugPrint('data ktpData ${jsonEncode(ktpData.toJson())}');
                    dataHolder.ktpData = ktpData;
                    widget.callbackKTPMapping?.call(ktpData.toJson().toString());
                  },
                  onSIMDetected: (SIMData simData) {
                    debugPrint('data simData ${simData.toJson()}');
                    widget.callbackSIMMapping?.call(simData.toJson().toString());
                  },
                  onPassportDetected: (UserDataFromPassportModel passportData) {
                    debugPrint('data passportData ${passportData.toJson()}');
                  },
                  onLoading: (bool isLoading) {
                    if (InitConfig.useOCRApi) {
                      setState(() {
                        isLoadingScreen = true;
                      });
                    } else {
                      debugPrint('isLoading now $isLoading');
                      setState(() {
                        isLoadingScreen = isLoading;
                      });
                    }
                  },
                ),
                if (isLoadingScreen)
                  Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Proses Sedang Berlangsung',
                          style: GoogleFonts.mukta(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
            Container(
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
                      "Scan KTP",
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
          ],
        ),
      ),
    );
  }
}
