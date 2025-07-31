import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/controller/register_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/finger_scanning/info_scan_finger_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/support/camera_ocr_data_model.dart';
import 'package:fingerprint_app/presentation/register_user_screen/id_scanning/validate_data_id_screen.dart';
import 'package:fingerprint_app/support/app_datatype_converter.dart';
import 'package:fingerprint_app/support/widget/app_loading_overlay_widget.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultCameraScanFaceScreen extends StatefulWidget {
  final String faceLiveness;
  final void Function()? retryCaptureCallback;

  const ResultCameraScanFaceScreen({
    super.key,
    required this.faceLiveness,
    this.retryCaptureCallback,
  });

  @override
  State<ResultCameraScanFaceScreen> createState() => _ResultCameraScanFaceScreenState();
}

class _ResultCameraScanFaceScreenState extends State<ResultCameraScanFaceScreen> {
  final RegisterController registerController = Get.find<RegisterController>();

  Future<void> processHandler() async {
    registerController.faceLiveness.value = await AppDatatypeConverter().convertBase64ToFile(
      base64String: widget.faceLiveness,
      fileName: "faceLiveness",
    );
    if (registerController.faceLiveness.value != null) {
      await registerController.faceCompareProcess(
        faceLiveness: registerController.faceLiveness.value!,
        onSuccess: (result) {
          Get.to(
            () => InfoScanFingerScreen(),
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
      // Get.to(
      //   () => InfoScanFingerScreen(),
      //   binding: RegisterBinding(),
      // );
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
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        widget.retryCaptureCallback?.call();
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color(0xff0E1925),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: const Color(0xff0E1925),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 124.h),
                          Image.memory(base64Decode(widget.faceLiveness)),
                          SizedBox(height: 78.h),
                          Text(
                            "Pastikan hasil gambar terlihat jelas",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: const Color(0xffFFFFFF),
                            ),
                          ),
                          SizedBox(height: 78.h),
                          MainButtonWidget.inverse(
                            title: "Ambil Ulang",
                            height: 48.h,
                            width: MediaQuery.of(context).size.width,
                            onPressed: () {
                              Navigator.pop(context);
                              registerController.faceLiveness.value = null;
                              widget.retryCaptureCallback?.call();
                            },
                          ),
                          SizedBox(height: 16.h),
                          MainButtonWidget(
                            title: "Lanjutkan",
                            height: 48.h,
                            width: MediaQuery.of(context).size.width,
                            onPressed: () async {
                              await processHandler();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
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
                            "Capture Face",
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
                            widget.retryCaptureCallback?.call();
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
}
