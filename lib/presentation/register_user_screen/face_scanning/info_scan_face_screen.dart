import 'dart:developer';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/home_screeen/binding/home_binding.dart';
import 'package:fingerprint_app/presentation/home_screeen/home_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/controller/register_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/face_scanning/camera_scan_face_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/face_scanning/result_camera_scan_face_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ScanFaceFlowType { registerFlow, continueFlow }

class InfoScanFaceScreen extends StatefulWidget {
  final ScanFaceFlowType scanFaceFlowType;

  // const InfoScanFaceScreen({
  //   super.key,
  //   required this.scanFaceFlowType,
  // });
  const InfoScanFaceScreen.continueFlow({
    super.key,
  }) : scanFaceFlowType = ScanFaceFlowType.continueFlow;

  const InfoScanFaceScreen.registerFlow({
    super.key,
  }) : scanFaceFlowType = ScanFaceFlowType.registerFlow;

  @override
  State<InfoScanFaceScreen> createState() => _InfoScanFaceScreenState();
}

class _InfoScanFaceScreenState extends State<InfoScanFaceScreen> {
  final RegisterController registerController = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    registerController.currentScanFaceFlowType.value = widget.scanFaceFlowType;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.scanFaceFlowType == ScanFaceFlowType.continueFlow ? true : false,
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 432.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(34.h),
                            bottomRight: Radius.circular(34.h),
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              AppAssets.imageScanningFace,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      //
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: kToolbarHeight),
                            Text(
                              "Face Recognition",
                              style: GoogleFonts.poppins(
                                color: const Color(0xffFFFFFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Scan your face to verify your identity",
                              style: GoogleFonts.poppins(
                                color: const Color(0xffECECEC),
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 32.h,
                              width: 32.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff1183FF),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "1",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xffFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pencahayaan baik",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff284D75),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Pastikan berada di tempat terang. Hindari bayangan atau cahaya berlebih pada ID.",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff383838),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Container(
                              height: 32.h,
                              width: 32.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff1183FF),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "2",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xffFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lihat Lurus ke Kamera",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff284D75),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Dekatkan kamera ke wajah, posisikan sejajar, dan tatap lurus ke kamera depan.",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xff383838),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MainButtonWidget(
                                title: "Go to Scan",
                                onPressed: () {
                                  Get.to(
                                    () => CameraScanFaceScreen(
                                      callback: (dataImage) {
                                        log("callback here");
                                        Get.back();
                                        Get.to(
                                          () => ResultCameraScanFaceScreen(
                                            faceLiveness: dataImage,
                                          ),
                                          binding: RegisterBinding(),
                                        );
                                      },
                                    ),
                                    binding: RegisterBinding(),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: MainButtonWidget.grey(
                                title: "Back to Home",
                                onPressed: () {
                                  Get.offAll(
                                    () => HomeScreen(),
                                    binding: HomeBinding(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: kToolbarHeight,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  child: Stack(
                    children: [
                      // Container(
                      //   // color: Colors.black,
                      //   height: 40.h,
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     "Detail Data",
                      //     style: GoogleFonts.lato(
                      //       color: Colors.white,
                      //       fontSize: 16.sp,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                      if (widget.scanFaceFlowType == ScanFaceFlowType.continueFlow)
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
      ),
    );
  }
}
