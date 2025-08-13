import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:fam_coding_supply/fam_coding_supply.dart';
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
                          // margin: const EdgeInsets.all(6.81),
                          // decoration: BoxDecoration(
                          //   shape: BoxShape.circle,
                          //   // border: Border.all(
                          //   //   color: const Color(0xFF6F6F6F),
                          //   //   width: 2,
                          //   // ),
                          // ),
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
                  onTakePict: (String base64Image) {
                    // debugPrint('data base64Image $base64Image');
                    widget.callbackImageCard?.call(base64Image);

                    // Map<String, dynamic> onTakePictMap = {'onTakePict': base64Image};
                    // dataHolder.addAll(onTakePictMap);
                    dataHolder.imageCard = base64Image;
                  },
                  croppedFaceCard: (String? base64Image) {
                    widget.callbackImage?.call(base64Image);

                    // Map<String, dynamic> croppedFaceCardMap = {'croppedFaceCard': base64Image};
                    // dataHolder.addAll(croppedFaceCardMap);
                    dataHolder.imageFromCard = base64Image;
                  },
                  onTextDetected: (RecognizedText recognizedText) async {
                    KTPData? handler = await compute(OCRHandler().recognizedText, recognizedText);
                    debugPrint('data recognizedText ${handler?.toJson()}');
                    // KtpocrData? data = await OCRHandlerV2.getKtpData(recognizedText);
                    // debugPrint('data KtpocrData ${data?.toJson()}');
                    widget.callback?.call(handler!.toJson().toString());
                    // Navigator.pop(context);
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

                    // widget.callback?.call(recognizedText.text);
                    // // debugPrint('data recognizedText ${recognizedText.text}');
                    // Navigator.pop(context);
                  },
                  onKTPDetected: (KTPData ktpData) {
                    debugPrint('data ktpData ${jsonEncode(ktpData.toJson())}');

                    // Map<String, dynamic> ktpDataMap = {'ktpData': ktpData.toJson()};
                    // dataHolder.addAll(ktpDataMap);
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
                    debugPrint('isLoading now $isLoading');
                    setState(() {
                      isLoadingScreen = isLoading;
                    });
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
