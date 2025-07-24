import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/register_user_screen/camera_scan_id_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';

class InfoScanIdScreen extends StatefulWidget {
  const InfoScanIdScreen({super.key});

  @override
  State<InfoScanIdScreen> createState() => _InfoScanIdScreenState();
}

class _InfoScanIdScreenState extends State<InfoScanIdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
                        AppAssets.imageScanId,
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
                        "Scan ID Card",
                        style: GoogleFonts.poppins(
                          color: const Color(0xffFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "We use your ID Card to validate your data",
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
                              "ID terlihat jelas",
                              style: GoogleFonts.poppins(
                                color: const Color(0xff284D75),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Arahkan kamera dengan posisi lurus dan stabil. Pastikan seluruh ID masuk bingkai dan teks mudah dibaca.",
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CameraScanIdScreen();
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
      ),
    );
  }
}
