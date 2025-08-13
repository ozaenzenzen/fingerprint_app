import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/logic/app_bottomsheet_utils.dart';
import 'package:fingerprint_app/domain/ocr_data_holder_model.dart';
import 'package:fingerprint_app/presentation/home_screeen/binding/home_binding.dart';
import 'package:fingerprint_app/presentation/home_screeen/home_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/binding/register_binding.dart';
import 'package:fingerprint_app/presentation/register_user_screen/controller/register_controller.dart';
import 'package:fingerprint_app/presentation/register_user_screen/face_scanning/info_scan_face_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/support/camera_ocr_data_model.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/app_input_formatter.dart';
import 'package:fingerprint_app/support/widget/app_loading_overlay_widget.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidateDataIdScreen extends StatefulWidget {
  final CameraOcrDataModel dataOCR;

  const ValidateDataIdScreen({
    super.key,
    required this.dataOCR,
  });

  @override
  State<ValidateDataIdScreen> createState() => _ValidateDataIdScreenState();
}

class _ValidateDataIdScreenState extends State<ValidateDataIdScreen> {
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

  final RegisterController controller = Get.find<RegisterController>();

  @override
  void initState() {
    super.initState();
    addressController.text = "${widget.dataOCR.ktpData?.address}";
    nikController.text = "${widget.dataOCR.ktpData?.nik}";
    namaController.text = "${widget.dataOCR.ktpData?.name}";
    // ttlController.text = "${widget.dataOCR.ktpData?.birthDate}, ${widget.dataOCR.ktpData?.birthPlace}";
    tempatLahirController.text = "${widget.dataOCR.ktpData?.birthPlace}";
    tanggalLahirController.text = "${widget.dataOCR.ktpData?.birthDate}";
    jenisKelaminController.text = (widget.dataOCR.ktpData?.gender?.toLowerCase() == "perempuan") ? "Female" : "Male";
    golonganDarahController.text = "${widget.dataOCR.ktpData?.bloodType}";
    // rtRwController.text = "${widget.dataOCR.ktpData?.rt}/${widget.dataOCR.ktpData?.rw}";
    rtController.text = "${widget.dataOCR.ktpData?.rt}";
    rwController.text = "${widget.dataOCR.ktpData?.rw}";
    kelurahanDesaController.text = "${widget.dataOCR.ktpData?.subDistrict}";
    kecamatanController.text = "${widget.dataOCR.ktpData?.district}";
    kotaController.text = "${widget.dataOCR.ktpData?.city}";
    provinsiController.text = "${widget.dataOCR.ktpData?.province}";
    agamaController.text = "${widget.dataOCR.ktpData?.religion}";
    maritalStatusController.text = "${widget.dataOCR.ktpData?.maritalStatus}";
    pekerjaanController.text = "${widget.dataOCR.ktpData?.profession}";
    kewarganegaraanController.text = "${widget.dataOCR.ktpData?.nationality}";
    berlakuHinggaController.text = "${widget.dataOCR.ktpData?.expired}";

    controller.lengthTextNIK.value = nikController.text.length;
    controller.lengthTextRT.value = rtController.text.length;
    controller.lengthTextRW.value = rwController.text.length;
  }

  void submitHandler() async {
    controller.ocrHolder.value = OcrDataHolderModel(
      nama: namaController.text,
      nik: nikController.text,
      tempatLahir: tempatLahirController.text,
      tanggalLahir: tanggalLahirController.text,
      jenisKelamin: jenisKelaminController.text,
      golonganDarah: golonganDarahController.text,
      address: addressController.text,
      rt: rtController.text,
      rw: rwController.text,
      kelurahanDesa: kelurahanDesaController.text,
      kecamatan: kecamatanController.text,
      kota: kotaController.text,
      provinsi: provinsiController.text,
      agama: agamaController.text,
      maritalStatus: maritalStatusController.text,
      pekerjaan: pekerjaanController.text,
      kewarganegaraan: kewarganegaraanController.text,
      berlakuHingga: berlakuHinggaController.text,
    );
    await controller.ocrProcess(
      faceFromKtp: controller.faceFromKtp.value!,
      reqBody: controller.ocrHolder.value!.toJson(),
      onSuccess: () {
        Get.to(
          () => InfoScanFaceScreen.registerFlow(),
          binding: RegisterBinding(),
        );
      },
      onFailed: (errorMessage) {
        AppDialogActionCS.showFailedPopup(
          context: context,
          title: "Terjadi kesalahan",
          description: errorMessage,
          mainButtonColor: const Color(0xff1183FF),
          buttonTitle: "Kembali",
          mainButtonAction: () {
            Get.back();
          },
        );
      },
    );
    // Get.to(
    //   () => InfoScanFaceScreen(),
    //   binding: RegisterBinding(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            bottomNavigationBar: SafeArea(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Checkbox(
                            activeColor: const Color(0xff1183FF),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: controller.isPrivacyAgreement.value,
                            onChanged: (value) {
                              if (controller.isPrivacyAgreement.value) {
                                controller.isPrivacyAgreement.value = false;
                              }
                              // controller.isPrivacyAgreement.value = !controller.isPrivacyAgreement.value;
                              // controller.isPrivacyAgreement.value = !controller.isPrivacyAgreement.value;
                              AppBottomSheetUtilsCS().showAppBottomSheetV2(
                                // withClose: true,
                                context,
                                radius: 12.h,
                                withStrip: true,
                                title: "Kebijakan Privasi",
                                actions: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.h,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: const Color(0xff1183FF),
                                      ),
                                    ),
                                  ),
                                ],
                                content: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.w,
                                  ),
                                  child: Column(
                                    children: [
                                      Text("""Dengan melanjutkan, Anda menyetujui bahwa aplikasi ini dapat menyimpan dan mengelola data pribadi Anda sesuai dengan Kebijakan Privasi kami. Data yang disimpan meliputi, namun tidak terbatas pada:
- NIK
- Nama lengkap
- Alamat
                          
Kami menjamin bahwa data Anda akan dijaga kerahasiaannya dan tidak akan dibagikan kepada pihak ketiga tanpa izin Anda.
                    
Dengan menekan tombol "Setuju", Anda memberikan izin kepada kami untuk menyimpan dan menggunakan data Anda sesuai dengan ketentuan di atas."""),
                                      SizedBox(height: 16.h),
                                      MainButtonWidget(
                                        width: MediaQuery.sizeOf(context).width,
                                        title: "Setuju",
                                        onPressed: () {
                                          Navigator.pop(context);
                                          controller.isPrivacyAgreement.value = true;
                                        },
                                      ),
                                      SizedBox(height: kToolbarHeight + 16.h),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        SizedBox(width: 8.w),
                        Text(
                          "Saya menyetujui Kebijakan Privasi",
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    MainButtonWidget(
                      title: "Simpan",
                      width: MediaQuery.sizeOf(context).width,
                      onPressed: () {
                        if (!controller.isPrivacyAgreement.value) {
                          AppDialogActionCS.showFailedPopup(
                            context: context,
                            title: "Terjadi kesalahan",
                            description: "Anda belum menyetujui kebijakan privasi",
                            mainButtonAction: () {
                              Get.back();
                            },
                            buttonTitle: "Kembali",
                            mainButtonColor: const Color(0xff1183FF),
                          );
                        } else {
                          if (addressController.text.isEmpty ||
                              nikController.text.isEmpty ||
                              namaController.text.isEmpty ||
                              tempatLahirController.text.isEmpty ||
                              tanggalLahirController.text.isEmpty ||
                              jenisKelaminController.text.isEmpty ||
                              golonganDarahController.text.isEmpty ||
                              rtController.text.isEmpty ||
                              rwController.text.isEmpty ||
                              kelurahanDesaController.text.isEmpty ||
                              kecamatanController.text.isEmpty ||
                              kotaController.text.isEmpty ||
                              provinsiController.text.isEmpty ||
                              agamaController.text.isEmpty ||
                              maritalStatusController.text.isEmpty ||
                              pekerjaanController.text.isEmpty ||
                              kewarganegaraanController.text.isEmpty ||
                              berlakuHinggaController.text.isEmpty) {
                            AppDialogActionCS.showFailedPopup(
                              context: context,
                              title: "Terjadi kesalahan",
                              description: "Masih terdapat field belum terisi",
                              mainButtonAction: () {
                                Get.back();
                              },
                              buttonTitle: "Kembali",
                              mainButtonColor: const Color(0xff1183FF),
                            );
                          } else {
                            if (controller.errorTextNIK.value != null || controller.errorTextRT.value != null || controller.errorTextRW.value != null) {
                              AppDialogActionCS.showFailedPopup(
                                context: context,
                                title: "Terjadi kesalahan",
                                description: "Masih terdapat field belum terisi dengan benar",
                                mainButtonAction: () {
                                  Get.back();
                                },
                                buttonTitle: "Kembali",
                                mainButtonColor: const Color(0xff1183FF),
                              );
                            } else {
                              if (addressController.text == "null" ||
                                  nikController.text == "null" ||
                                  namaController.text == "null" ||
                                  tempatLahirController.text == "null" ||
                                  tanggalLahirController.text == "null" ||
                                  jenisKelaminController.text == "null" ||
                                  // golonganDarahController.text == "null" ||
                                  rtController.text == "null" ||
                                  rwController.text == "null" ||
                                  kelurahanDesaController.text == "null" ||
                                  kecamatanController.text == "null" ||
                                  kotaController.text == "null" ||
                                  provinsiController.text == "null" ||
                                  agamaController.text == "null" ||
                                  maritalStatusController.text == "null" ||
                                  pekerjaanController.text == "null" ||
                                  kewarganegaraanController.text == "null" ||
                                  berlakuHinggaController.text == "null") {
                                AppDialogActionCS.showFailedPopup(
                                  context: context,
                                  title: "Terjadi kesalahan",
                                  description: "Masih terdapat field dengan nilai null",
                                  mainButtonAction: () {
                                    Get.back();
                                  },
                                  buttonTitle: "Kembali",
                                  mainButtonColor: const Color(0xff1183FF),
                                );
                              } else {
                                AppDialogActionCS.showWarningPopup(
                                  context: context,
                                  title: "Warning",
                                  description: "Apakah Anda yakin semua data sudah benar?",
                                  isHorizontal: false,
                                  mainButtonAction: () {
                                    Get.back();
                                    submitHandler();
                                  },
                                  mainButtonTitle: "Ya",
                                  mainButtonColor: const Color(0xff1183FF),
                                  secondaryButtonAction: () {
                                    Get.back();
                                  },
                                  secondaryButtonTitle: "Kembali",
                                  secondaryButtonColor: const Color(0xff5A6684),
                                );
                              }
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
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
                      width: MediaQuery.sizeOf(context).width,
                      // color: Colors.red,
                      child: Stack(
                        children: [
                          Container(
                            // color: Colors.black,
                            height: 40.h,
                            alignment: Alignment.center,
                            child: Text(
                              "Validasi Data",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              InkWell(
                                onTap: () {
                                  AppDialogActionCS.showWarningPopup(
                                    context: context,
                                    title: "Warning",
                                    description: "Proses Scan ID belum tersimpan. Apakah Anda yakin ingin ke halaman home?",
                                    mainButtonTitle: "Ya",
                                    mainButtonColor: const Color(0xff1183FF),
                                    mainButtonAction: () {
                                      Get.back();
                                      Get.offAll(
                                        () => HomeScreen(),
                                        binding: HomeBinding(),
                                      );
                                    },
                                    isHorizontal: false,
                                    secondaryButtonColor: Colors.grey,
                                    secondaryButtonTitle: "Tidak",
                                    secondaryButtonAction: () {
                                      Get.back();
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  // color: Colors.amber,
                                  height: 40.h,
                                  width: 40.h,
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                    size: 20.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              // color: Colors.red,
                              child: widget.dataOCR.imageCard != null
                                  ? Image.memory(
                                      base64Decode(widget.dataOCR.imageCard!),
                                      fit: BoxFit.cover,
                                      height: 174.h,
                                    )
                                  : Image.asset(
                                      AppAssets.imageKtp,
                                      fit: BoxFit.cover,
                                      height: 174.h,
                                    ),
                            ),
                            Container(
                              // color: Colors.red,
                              child: widget.dataOCR.imageCard != null
                                  ? Image.memory(
                                      base64Decode(widget.dataOCR.imageFromCard!),
                                      fit: BoxFit.cover,
                                      height: 100.h,
                                      width: 100.h,
                                    )
                                  : Image.asset(
                                      AppAssets.imageKtp,
                                      fit: BoxFit.cover,
                                      height: 100.h,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
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
                            Expanded(
                              child: SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: Column(
                                  children: [
                                    SizedBox(height: 18.h),
                                    Obx(() {
                                      return TextField(
                                        controller: nikController,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(), // Custom formatter to force uppercase
                                        ],
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          controller.validateTextNIK(
                                            value,
                                          );
                                        },
                                        decoration: InputDecoration(
                                          errorText: controller.errorTextNIK.value,
                                          counterText: "${controller.lengthTextNIK}/${controller.maxLengthNIK}",
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
                                      );
                                    }),
                                    SizedBox(height: 22.h),
                                    TextField(
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
                                      onTap: () async {
                                        DateTime? tanggalLahirChosen = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          currentDate: controller.tanggalLahirChosen.value,
                                        );
                                        if (tanggalLahirChosen != null) {
                                          tanggalLahirController.text = DateFormat("yyyy-MM-dd").format(tanggalLahirChosen);
                                          controller.tanggalLahirChosen.value = tanggalLahirChosen;
                                        }
                                      },
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
                                              controller: rtController,
                                              keyboardType: TextInputType.number,
                                              onChanged: controller.validateTextRT,
                                              decoration: InputDecoration(
                                                errorText: controller.errorTextRT.value,
                                                counterText: "${controller.lengthTextRT}/${controller.maxLengthRT}",
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
                                              controller: rwController,
                                              keyboardType: TextInputType.number,
                                              onChanged: controller.validateTextRW,
                                              decoration: InputDecoration(
                                                errorText: controller.errorTextRW.value,
                                                counterText: "${controller.lengthTextRW}/${controller.maxLengthRW}",
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
        ),
        Obx(
          () {
            if (controller.isLoading.value) {
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
