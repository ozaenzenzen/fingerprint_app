import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/detail_user_screen/detail_user_screen.dart';
import 'package:fingerprint_app/presentation/login_screen/controller/login_controller.dart';
import 'package:fingerprint_app/presentation/login_screen/login_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/register_user_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 276.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.h),
                bottomRight: Radius.circular(40.h),
              ),
              gradient: RadialGradient(
                colors: [
                  Color(0xff004AA1),
                  Color(0xff01204C),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // alignment: Alignment.centerRight,
                      height: kToolbarHeight,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // InkWell(
                          //   onTap: () {
                          //     Get.to(
                          //       () => FingerprintTestScreen(),
                          //       binding: RegisterBinding(),
                          //     );
                          //   },
                          //   child: Container(
                          //     height: 32.h,
                          //     width: 32.h,
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: Colors.white38,
                          //     ),
                          //     child: Icon(
                          //       Icons.fingerprint,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(width: 8.w),
                          InkWell(
                            onTap: () async {
                              await loginController.logout(
                                onSuccess: () {
                                  Get.offAll(() => LoginScreen());
                                },
                                onFailed: (errorMessage) {
                                  AppDialogActionCS.showFailedPopup(
                                    context: context,
                                    title: "Terjadi kesalahan",
                                    description: errorMessage,
                                    buttonTitle: "Kembali",
                                    mainButtonAction: () {
                                      Get.back();
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 32.h,
                              width: 32.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white38,
                              ),
                              child: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              // child: Container(
                              //   height: 24.h,
                              //   width: 24.h,
                              //   alignment: Alignment.center,
                              //   child: Image.asset(
                              //     AppAssets.iconAvatar,
                              //     color: const Color(0xffffffff),
                              //     height: 24.h,
                              //     width: 24.h,
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Lorem ipsum",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w700,
                        fontSize: 23.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Search user name to know detail data",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: const Color(0xffECECEC),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 40.h,
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(10.h),
                                  child: Image.asset(
                                    AppAssets.iconSearch,
                                    height: 20.h,
                                    width: 20.h,
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(80.h),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => RegisterUserScreen(),
                              binding: RegisterBinding(),
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return RegisterUserScreen();
                            //     },
                            //   ),
                            // );
                          },
                          child: Container(
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xff1183FF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20.h,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: SafeArea(
              top: false,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "List Data",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: const Color(0xff0B60BC),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: ListView.separated(
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        itemCount: 13,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => DetailUserScreen());
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return DetailUserScreen();
                              //     },
                              //   ),
                              // );
                            },
                            child: Container(
                              // height: 62.h,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff1183FF),
                                ),
                                borderRadius: BorderRadius.circular(12.h),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Title $index",
                                          style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                            color: const Color(0xff222222),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "Desc $index",
                                          style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            color: const Color(0xff5A6684),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    size: 24.h,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12.h);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
