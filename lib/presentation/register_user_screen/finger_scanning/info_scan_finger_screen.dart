import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/register_user_screen/finger_scanning/scan_finger_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';

class InfoScanFingerScreen extends StatefulWidget {
  const InfoScanFingerScreen({super.key});

  @override
  State<InfoScanFingerScreen> createState() => _InfoScanFingerScreenState();
}

class _InfoScanFingerScreenState extends State<InfoScanFingerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            AppAssets.imageScanningFinger,
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
                            "Scan Fingertip",
                            style: GoogleFonts.poppins(
                              color: const Color(0xffFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Scan your fingertip to verify your identity",
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
                                  "Tempelkan Jari",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff284D75),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Letakkan jari kamu di atas sensor fingerprint dengan posisi rata dan tidak bergeser",
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
                                  "Tunggu Hingga Terbaca",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff284D75),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Tahan beberapa detik hingga pemindaian selesai.",
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
                      MainButtonWidget(
                        title: "Go to Scan",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ScanFingerScreen(
                                    // callback: (textDetected) {},
                                    // callbackImage: (image) {},
                                    // callbackImageCard: (image) {},
                                    // callbackKTPMapping: (mapping) {},
                                    // callbackSIMMapping: (mapping) {},
                                    );
                              },
                            ),
                          );
                        },
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
}
