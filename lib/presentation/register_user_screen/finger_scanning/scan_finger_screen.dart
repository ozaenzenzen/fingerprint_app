import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/home_screeen/binding/home_binding.dart';
import 'package:fingerprint_app/presentation/home_screeen/home_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanFingerScreen extends StatefulWidget {
  const ScanFingerScreen({super.key});

  @override
  State<ScanFingerScreen> createState() => _ScanFingerScreenState();
}

class _ScanFingerScreenState extends State<ScanFingerScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xff004AA1),
                    Color(0xff01204C),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // initialState(),
                    // scanningState(),
                    doneScanState(),
                  ],
                ),
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
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 16.w,
                    //     ),
                    //     // color: Colors.amber,
                    //     height: 40.h,
                    //     width: 40.h,
                    //     child: Icon(
                    //       Icons.arrow_back_ios,
                    //       color: Colors.white,
                    //       size: 20.h,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget initialState() {
    return Column(
      children: [
        SizedBox(height: 156.h),
        Image.asset(
          AppAssets.iconFingerprint,
          height: 146.h,
          width: 114.h,
        ),
        SizedBox(height: 149.h),
        Text(
          "Place your fingertip over the sensor",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget scanningState() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 156.h),
            Image.asset(
              AppAssets.iconFingerprint,
              height: 146.h,
              width: 114.h,
            ),
            SizedBox(height: 149.h),
            Text(
              "Collecting data, please keep hold your hand",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Positioned(
          top: 80.h,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 320.h,
              width: 320.h,
              // color: Colors.red,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget doneScanState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 245.h),
        Image.asset(
          AppAssets.iconSecured,
          height: 80.h,
          width: 80.h,
        ),
        SizedBox(height: 24.h),
        Text(
          "Registrasi Berhasil",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Nikmati berbagai layanan yang kami sediakan.",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 24.h),
        MainButtonWidget(
          title: "Back to Home",
          onPressed: () {
            Get.offAll(
              () => HomeScreen(),
              binding: HomeBinding(),
            );
          },
        ),
      ],
    );
  }
}
