import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/id_scanning/info_scan_id_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.bgLoginRectangle,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 96.h),
                    Image.asset(
                      AppAssets.bgLoginFingerprint,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 231.h),
                    Text(
                      "Let’s Get Started",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w700,
                        fontSize: 23.sp,
                        color: const Color(0xff135CB7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Untuk melakukan pendaftaran, kamu perlu melakukan 3 tahapan ini.",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: const Color(0xff333333),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              AppAssets.iconScanDocument,
                              height: 40.h,
                              width: 40.h,
                              color: Colors.black,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              "Scan ID Card",
                              style: GoogleFonts.openSans(
                                color: const Color(0xff22222A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Image.asset(
                              AppAssets.iconScanPerson,
                              height: 40.h,
                              width: 40.h,
                              color: Colors.black,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              "Face Recognition",
                              style: GoogleFonts.openSans(
                                color: const Color(0xff22222A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Image.asset(
                              AppAssets.iconScanFingerprint,
                              height: 40.h,
                              width: 40.h,
                              color: Colors.black,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              "Scan Fingertip",
                              style: GoogleFonts.openSans(
                                color: const Color(0xff22222A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      height: 40.h,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xff1183FF),
                          // backgroundColor: const Color(0xffE6E8E9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                        ),
                        onPressed: () {
                          Get.to(
                            () => InfoScanIdScreen(),
                            binding: RegisterBinding(),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) {
                          //     return InfoScanIdScreen();
                          //   }),
                          // );
                        },
                        child: Text(
                          "Continue",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            color: Colors.white,
                            // color: const Color(0xff999999),
                          ),
                        ),
                      ),
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
    );
  }
}
