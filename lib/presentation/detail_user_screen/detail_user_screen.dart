import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_registration_by_id_response_model.dart';
import 'package:fingerprint_app/presentation/fingerprint_test_screen.dart';
import 'package:fingerprint_app/presentation/home_screeen/controller/home_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/controller/register_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/face_scanning/info_scan_face_screen.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/app_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailUserScreen extends StatefulWidget {
  final DataGetRegistrationById data;

  const DetailUserScreen({
    super.key,
    required this.data,
  });

  @override
  State<DetailUserScreen> createState() => _DetailUserScreenState();
}

class _DetailUserScreenState extends State<DetailUserScreen> {
  final HomeController homeController = Get.find<HomeController>();

  TextEditingController addressController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController tempatLahirController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController jenisKelaminController = TextEditingController();
  TextEditingController golonganDarahController = TextEditingController();
  TextEditingController rtController = TextEditingController();
  TextEditingController rwController = TextEditingController();
  TextEditingController kelurahanDesaController = TextEditingController();
  TextEditingController kecamatanController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController provinsiController = TextEditingController();
  TextEditingController agamaController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController pekerjaanController = TextEditingController();
  TextEditingController kewarganegaraanController = TextEditingController();
  TextEditingController berlakuHinggaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = "${widget.data.user?.address}";
    nikController.text = "${widget.data.user?.nik}";
    namaController.text = "${widget.data.user?.fullName}";
    // ttlController.text = "${widget.dataOCR.ktpData?.birthDate}, ${widget.dataOCR.ktpData?.birthPlace}";
    tempatLahirController.text = "${widget.data.user?.placeOfBirth}";
    tanggalLahirController.text = widget.data.user?.dateOfBirth != null ? DateFormat("yyyy-dd-mm").format(widget.data.user!.dateOfBirth!) : "";
    jenisKelaminController.text = (widget.data.user?.gender?.toLowerCase() == "perempuan") ? "Female" : "Male";
    golonganDarahController.text = "${widget.data.user?.bloodType}";
    // rtRwController.text = "${widget.dataOCR.ktpData?.rt}/${widget.dataOCR.ktpData?.rw}";
    rtController.text = "${widget.data.user?.rt}";
    rwController.text = "${widget.data.user?.rw}";
    kelurahanDesaController.text = "${widget.data.user?.kelurahan}";
    kecamatanController.text = "${widget.data.user?.kecamatan}";
    kotaController.text = "${widget.data.user?.city}";
    provinsiController.text = "${widget.data.user?.province}";
    agamaController.text = "${widget.data.user?.religion}";
    maritalStatusController.text = "${widget.data.user?.maritalStatus}";
    pekerjaanController.text = "${widget.data.user?.occupation}";
    kewarganegaraanController.text = "${widget.data.user?.nationality}";
    berlakuHinggaController.text = "${widget.data.user?.validUntil}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
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
                          "Detail Data",
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
                SizedBox(height: 16.h),
                Container(
                  // color: Colors.red,
                  child: Image.asset(
                    AppAssets.imageKtp,
                    fit: BoxFit.cover,
                    height: 174.h,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 40.h,
                  // width: MediaQuery.of(context).size.width,
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
                      AppBottomSheetAction().showBottomSheetV3(
                        withClose: true,
                        context: context,
                        radius: 12.h,
                        withStrip: true,
                        title: "Pilih Cara Verifikasi",
                        content: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                                final RegisterController registerController = Get.put(RegisterController());
                                registerController.continueUserId.value = widget.data.id ?? "";
                                Get.to(
                                  () => InfoScanFaceScreen(
                                    scanFaceFlowType: ScanFaceFlowType.continueFlow,
                                  ),
                                  binding: RegisterBinding(),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff1183FF),
                                  ),
                                  borderRadius: BorderRadius.circular(12.h),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      AppAssets.iconScanPerson,
                                      height: 20.h,
                                      width: 20.h,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Pengenalan Wajah",
                                      style: GoogleFonts.lato(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(
                                  () => FingerprintTestScreen(),
                                  binding: RegisterBinding(),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff1183FF),
                                  ),
                                  borderRadius: BorderRadius.circular(12.h),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      AppAssets.iconScanFingerprint,
                                      height: 20.h,
                                      width: 20.h,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Pindai Jari",
                                      style: GoogleFonts.lato(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: kToolbarHeight + 16.h),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.iconScanDocument,
                          height: 20.h,
                          width: 20.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Verify ID",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            color: Colors.white,
                            // color: const Color(0xff999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.h),
                        topRight: Radius.circular(20.h),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        Text(
                          "Documents",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: const Color(0xff0B60BC),
                          ),
                        ),
                        // Expanded(
                        //   child: SingleChildScrollView(
                        //     physics: ScrollPhysics(),
                        //     child: Column(
                        //       children: [
                        //         SizedBox(height: 18.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "NIK",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "Nama",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "Tempat Tanggal Lahir",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         Row(
                        //           children: [
                        //             Expanded(
                        //               child: TextField(
                        //                 readOnly: true,
                        //                 decoration: InputDecoration(
                        //                   label: Text(
                        //                     "Jenis Kelamin",
                        //                     style: GoogleFonts.openSans(
                        //                       fontSize: 14.sp,
                        //                       fontWeight: FontWeight.w400,
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   floatingLabelBehavior: FloatingLabelBehavior.always,
                        //                   border: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                   ),
                        //                   enabledBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.w),
                        //             Expanded(
                        //               child: TextField(
                        //                 readOnly: true,
                        //                 decoration: InputDecoration(
                        //                   label: Text(
                        //                     "Golongan Darah",
                        //                     style: GoogleFonts.openSans(
                        //                       fontSize: 14.sp,
                        //                       fontWeight: FontWeight.w400,
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   floatingLabelBehavior: FloatingLabelBehavior.always,
                        //                   border: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                   ),
                        //                   enabledBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "NIK",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         Row(
                        //           children: [
                        //             Expanded(
                        //               child: TextField(
                        //                 readOnly: true,
                        //                 decoration: InputDecoration(
                        //                   label: Text(
                        //                     "RT/RW",
                        //                     style: GoogleFonts.openSans(
                        //                       fontSize: 14.sp,
                        //                       fontWeight: FontWeight.w400,
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   floatingLabelBehavior: FloatingLabelBehavior.always,
                        //                   border: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                   ),
                        //                   enabledBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.w),
                        //             Expanded(
                        //               child: TextField(
                        //                 readOnly: true,
                        //                 decoration: InputDecoration(
                        //                   label: Text(
                        //                     "Kel/Desa",
                        //                     style: GoogleFonts.openSans(
                        //                       fontSize: 14.sp,
                        //                       fontWeight: FontWeight.w400,
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   floatingLabelBehavior: FloatingLabelBehavior.always,
                        //                   border: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                   ),
                        //                   enabledBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.w),
                        //             Expanded(
                        //               child: TextField(
                        //                 readOnly: true,
                        //                 decoration: InputDecoration(
                        //                   label: Text(
                        //                     "Kecamatan",
                        //                     style: GoogleFonts.openSans(
                        //                       fontSize: 14.sp,
                        //                       fontWeight: FontWeight.w400,
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   floatingLabelBehavior: FloatingLabelBehavior.always,
                        //                   border: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                   ),
                        //                   enabledBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                   focusedBorder: OutlineInputBorder(
                        //                     borderRadius: BorderRadius.circular(12.h),
                        //                     borderSide: BorderSide(
                        //                       color: const Color(0xff1183FF),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "Agama",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "Pekerjaan",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "Kewarganegaraan",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //         TextField(
                        //           readOnly: true,
                        //           decoration: InputDecoration(
                        //             label: Text(
                        //               "Berlaku Hingga",
                        //               style: GoogleFonts.openSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             floatingLabelBehavior: FloatingLabelBehavior.always,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(12.h),
                        //               borderSide: BorderSide(
                        //                 color: const Color(0xff1183FF),
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 22.h),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 18.h),
                                TextField(
                                  controller: nikController,
                                  readOnly: true,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  keyboardType: TextInputType.number,
                                  // onChanged: controller.validateTextNIK,
                                  decoration: InputDecoration(
                                    // errorText: controller.errorTextNIK.value,
                                    counterText: "${nikController.text.length}/${homeController.maxLengthNIK}",
                                    counterStyle: GoogleFonts.openSans(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff1183FF),
                                    ),
                                    label: Text(
                                      "NIK",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: namaController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Nama",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: tempatLahirController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Tempat Lahir",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  controller: tanggalLahirController,
                                  readOnly: true,
                                  // onTap: () async {
                                  //   DateTime? tanggalLahirChosen = await showDatePicker(
                                  //     context: context,
                                  //     firstDate: DateTime(1900),
                                  //     lastDate: DateTime.now(),
                                  //     currentDate: controller.tanggalLahirChosen.value,
                                  //   );
                                  //   if (tanggalLahirChosen != null) {
                                  //     tanggalLahirController.text = DateFormat("yyyy-MM-dd").format(tanggalLahirChosen);
                                  //     controller.tanggalLahirChosen.value = tanggalLahirChosen;
                                  //   }
                                  // },
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Tanggal Lahir",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        controller: jenisKelaminController,
                                        inputFormatters: [
                                          CaseTextFormatter(format: CaseFormat.camelCase), // Custom formatter to force uppercase
                                        ],
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Jenis Kelamin",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        controller: golonganDarahController,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                        ],
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Golongan Darah",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: addressController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Alamat",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                Row(
                                  children: [
                                    Obx(() {
                                      return Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: rtController,
                                          keyboardType: TextInputType.number,
                                          onChanged: homeController.validateTextRT,
                                          decoration: InputDecoration(
                                            errorText: homeController.errorTextRT.value,
                                            counterText: "${rtController.text.length}/${homeController.maxLengthRT}",
                                            counterStyle: GoogleFonts.openSans(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff1183FF),
                                            ),
                                            label: Text(
                                              "RT",
                                              style: GoogleFonts.openSans(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff1183FF),
                                              ),
                                            ),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.h),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.h),
                                              borderSide: BorderSide(
                                                color: const Color(0xff1183FF),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.h),
                                              borderSide: BorderSide(
                                                color: const Color(0xff1183FF),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    SizedBox(width: 8.w),
                                    Obx(() {
                                      return Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: rwController,
                                          keyboardType: TextInputType.number,
                                          onChanged: homeController.validateTextRW,
                                          decoration: InputDecoration(
                                            errorText: homeController.errorTextRW.value,
                                            counterText: "${rwController.text.length}/${homeController.maxLengthRW}",
                                            counterStyle: GoogleFonts.openSans(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff1183FF),
                                            ),
                                            label: Text(
                                              "RW",
                                              style: GoogleFonts.openSans(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff1183FF),
                                              ),
                                            ),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.h),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.h),
                                              borderSide: BorderSide(
                                                color: const Color(0xff1183FF),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12.h),
                                              borderSide: BorderSide(
                                                color: const Color(0xff1183FF),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                SizedBox(height: 22.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        controller: kelurahanDesaController,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                        ],
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Kel/Desa",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        controller: kecamatanController,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                        ],
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Kecamatan",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.h),
                                            borderSide: BorderSide(
                                              color: const Color(0xff1183FF),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: kotaController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Kota/Kabupaten",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: provinsiController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Provinsi",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: agamaController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Agama",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: maritalStatusController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Status Perkawinan",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: pekerjaanController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Pekerjaan",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: kewarganegaraanController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Kewarganegaraan",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                TextField(
                                  readOnly: true,
                                  controller: berlakuHinggaController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                  ],
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Berlaku Hingga",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.h),
                                      borderSide: BorderSide(
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22.h),
                              ],
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
      ),
    );
  }
}
