import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:flutter/material.dart';

class ScanFingerScreen extends StatefulWidget {
  const ScanFingerScreen({super.key});

  @override
  State<ScanFingerScreen> createState() => _ScanFingerScreenState();
}

class _ScanFingerScreenState extends State<ScanFingerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
