import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_list_registration_response_model.dart';
import 'package:fingerprint_app/presentation/detail_user_screen/detail_user_screen.dart';
import 'package:fingerprint_app/presentation/fingerprint_test_screen.dart';
import 'package:fingerprint_app/presentation/home_screeen/binding/home_binding.dart';
import 'package:fingerprint_app/presentation/home_screeen/controller/home_controller.dart';
import 'package:fingerprint_app/presentation/login_screen/controller/login_controller.dart';
import 'package:fingerprint_app/presentation/login_screen/login_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/face_scanning/info_scan_face_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/register_user_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/widget/app_loading_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginController loginController = Get.find<LoginController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeController.getListRegistration(
        onSuccess: () {
          //
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
            mainButtonColor: const Color(0xff1183FF),
          );
        },
      );
    });
  }

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                              //       () => InfoScanFaceScreen.registerFlow(),
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
                              //       Icons.face,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(width: 8.w),
                              // InkWell(
                              //   onTap: () {
                              //     Get.to(
                              //       () => FingerprintTestScreen.registerFlow(),
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
                              // SizedBox(width: 8.w),
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
                                        mainButtonColor: const Color(0xff1183FF),
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
                          "E-Regis Dashboard",
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
                        Obx(() {
                          return Expanded(
                            child: SmartRefresher(
                              controller: refreshController,
                              enablePullUp: true,
                              enablePullDown: true,
                              footer: const ClassicFooter(
                                loadStyle: LoadStyle.ShowWhenLoading,
                              ),
                              onLoading: () async {
                                await homeController.loadMoreListRegistration(
                                  onSuccess: () {
                                    refreshController.loadComplete();
                                  },
                                  onFailed: (errorMessage) {
                                    refreshController.loadComplete();
                                    AppDialogActionCS.showFailedPopup(
                                      context: context,
                                      title: "Terjadi kesalahan",
                                      description: errorMessage,
                                      buttonTitle: "Kembali",
                                      mainButtonAction: () {
                                        Get.back();
                                      },
                                      mainButtonColor: const Color(0xff1183FF),
                                    );
                                  },
                                );
                              },
                              onRefresh: () async {
                                await homeController.getListRegistration(
                                  onSuccess: () {
                                    refreshController.refreshCompleted();
                                  },
                                  onFailed: (errorMessage) {
                                    refreshController.refreshCompleted();
                                    AppDialogActionCS.showFailedPopup(
                                      context: context,
                                      title: "Terjadi kesalahan",
                                      description: errorMessage,
                                      buttonTitle: "Kembali",
                                      mainButtonAction: () {
                                        Get.back();
                                      },
                                      mainButtonColor: const Color(0xff1183FF),
                                    );
                                  },
                                );
                              },
                              child: ListView.separated(
                                physics: ScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                itemCount: homeController.listRegistrationData.length,
                                // itemCount: 13,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return RegistrationItemListWidget(
                                    data: homeController.listRegistrationData[index],
                                    onTap: () async {
                                      await homeController.getRegistrationById(
                                        id: homeController.listRegistrationData[index].id ?? "",
                                        onSuccess: (result) {
                                          Get.to(
                                            () => DetailUserScreen(
                                              data: result.data!,
                                              // id: homeController.listRegistrationData[index].id ?? "",
                                            ),
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
                                            mainButtonColor: const Color(0xff1183FF),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 12.h);
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
        Obx(
          () {
            if (homeController.isLoadingHome.value) {
              return AppOverlayLoadingWidget();
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}

class RegistrationItemListWidget extends StatelessWidget {
  final Function()? onTap;
  final ItemGetListRegistration data;

  const RegistrationItemListWidget({
    super.key,
    this.onTap,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
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
                    "${data.user?.fullName}",
                    // "Title $index",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: const Color(0xff222222),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${data.user?.nik}",
                    // "Desc $index",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: const Color(0xff5A6684),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: (data.latestRegistrationTimeline!.status == "SUCCESS") ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                    child: Text(
                      "${data.latestRegistrationTimeline?.step}",
                      // "Desc $index",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 8.sp,
                        color: Colors.white,
                        // color: const Color(0xff5A6684),
                      ),
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
  }
}
