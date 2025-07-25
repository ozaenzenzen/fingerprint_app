import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/register_user_screen/support/camera_ocr_data_model.dart';
import 'package:fingerprint_app/presentation/register_user_screen/id_scanning/validate_data_id_screen.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';

class ResultCameraScanIdScreen extends StatefulWidget {
  final CameraOcrDataModel dataOCR;
  // final Map<String, dynamic> dataOCR;
  final void Function()? retryCaptureCallback;

  const ResultCameraScanIdScreen({
    super.key,
    required this.dataOCR,
    this.retryCaptureCallback,
  });

  @override
  State<ResultCameraScanIdScreen> createState() => _ResultCameraScanIdScreenState();
}

class _ResultCameraScanIdScreenState extends State<ResultCameraScanIdScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        widget.retryCaptureCallback?.call();
      },
      child: Scaffold(
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
                      if (widget.dataOCR.imageCard != null) Image.memory(base64Decode(widget.dataOCR.imageCard!)),
                      if (widget.dataOCR.imageFromCard != null) Image.memory(base64Decode(widget.dataOCR.imageFromCard!)),
                      if (widget.dataOCR.ktpData != null)
                        Text(
                          "ktpData: ${jsonEncode(widget.dataOCR.ktpData)}",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
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
                          widget.retryCaptureCallback?.call();
                        },
                      ),
                      SizedBox(height: 16.h),
                      MainButtonWidget(
                        title: "Lanjutkan",
                        height: 48.h,
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ValidateDataIdScreen(
                                  dataOCR: widget.dataOCR,
                                );
                              },
                            ),
                          );
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
    );
  }
}
