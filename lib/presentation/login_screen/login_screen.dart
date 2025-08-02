import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/access/request/login_request_model.dart';
import 'package:fingerprint_app/presentation/home_screeen/binding/home_binding.dart';
import 'package:fingerprint_app/presentation/home_screeen/home_screen.dart';
import 'package:fingerprint_app/presentation/login_screen/controller/login_controller.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/widget/app_loading_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.find<LoginController>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = "admin@gmail.com";
    passwordController.text = "admin123";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Stack(
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
                          "Sign In",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 23.sp,
                            color: const Color(0xff135CB7),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Welcome! please sign in to cotinue",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: const Color(0xff333333),
                          ),
                        ),
                        SizedBox(height: 34.h),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.h),
                              child: Image.asset(
                                AppAssets.iconMail,
                                color: const Color(0xff5A6684),
                                height: 24.h,
                                width: 24.h,
                              ),
                            ),
                            hintText: "Email",
                            hintStyle: GoogleFonts.openSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: const Color(0xff5A6684),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.h),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.h),
                              borderSide: BorderSide(
                                color: const Color(0xff1183FF),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.h),
                              borderSide: BorderSide(
                                color: const Color(0xff1183FF),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Obx(() {
                          return TextField(
                            controller: passwordController,
                            obscureText: loginController.isHidePassword.value,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.h),
                                child: Image.asset(
                                  AppAssets.iconLock,
                                  color: const Color(0xff5A6684),
                                  height: 24.h,
                                  width: 24.h,
                                ),
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  loginController.isHidePassword.value = !loginController.isHidePassword.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10.h),
                                  child: Image.asset(
                                    loginController.isHidePassword.value ? AppAssets.iconEyeClose : AppAssets.iconEyeOpen,
                                    color: const Color(0xff5A6684),
                                    height: 24.h,
                                    width: 24.h,
                                  ),
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: const Color(0xff5A6684),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.h),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.h),
                                borderSide: BorderSide(
                                  color: const Color(0xff1183FF),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.h),
                                borderSide: BorderSide(
                                  color: const Color(0xff1183FF),
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 24.h),
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
                            onPressed: () async {
                              LoginRequestModel reqData = LoginRequestModel(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              await loginController.login(
                                req: reqData,
                                onSuccess: () {
                                  Get.off(
                                    () => HomeScreen(),
                                    binding: HomeBinding(),
                                  );
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
                            child: Text(
                              "Sign In",
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
            ),
          ),
          Obx(
            () {
              if (loginController.isLoadingLogin.value) {
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
