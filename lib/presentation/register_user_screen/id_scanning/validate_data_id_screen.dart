import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fam_coding_supply/logic/app_bottomsheet_utils.dart';
import 'package:fingerprint_app/presentation/register_user_screen/face_scanning/info_scan_face_screen.dart';
import 'package:fingerprint_app/presentation/register_user_screen/support/camera_ocr_data_model.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:fingerprint_app/support/widget/main_button_widget.dart';
import 'package:flutter/material.dart';

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
  TextEditingController ttlController = TextEditingController();
  TextEditingController jenisKelaminController = TextEditingController();
  TextEditingController golonganDarahController = TextEditingController();
  TextEditingController rtRwController = TextEditingController();
  TextEditingController kelurahanDesaController = TextEditingController();
  TextEditingController kecamatanController = TextEditingController();
  TextEditingController agamaController = TextEditingController();
  TextEditingController pekerjaanController = TextEditingController();
  TextEditingController kewarganegaraanController = TextEditingController();
  TextEditingController berlakuHinggaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = "${widget.dataOCR.ktpData?.address}";
    nikController.text = "${widget.dataOCR.ktpData?.nik}";
    namaController.text = "${widget.dataOCR.ktpData?.name}";
    ttlController.text = "${widget.dataOCR.ktpData?.birthDate}, ${widget.dataOCR.ktpData?.birthPlace}";
    jenisKelaminController.text = "${widget.dataOCR.ktpData?.gender}";
    golonganDarahController.text = "${widget.dataOCR.ktpData?.bloodType}";
    rtRwController.text = "${widget.dataOCR.ktpData?.rt}/${widget.dataOCR.ktpData?.rw}";
    kelurahanDesaController.text = "${widget.dataOCR.ktpData?.subDistrict}";
    kecamatanController.text = "${widget.dataOCR.ktpData?.district}";
    agamaController.text = "${widget.dataOCR.ktpData?.religion}";
    pekerjaanController.text = "${widget.dataOCR.ktpData?.profession}";
    kewarganegaraanController.text = "${widget.dataOCR.ktpData?.nationality}";
    berlakuHinggaController.text = "${widget.dataOCR.ktpData?.expired}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: true,
                      onChanged: (value) {
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
                                Text(
                                    """Dengan melanjutkan, Anda menyetujui bahwa aplikasi ini dapat menyimpan dan mengelola data pribadi Anda sesuai dengan Kebijakan Privasi kami. Data yang disimpan meliputi, namun tidak terbatas pada:
- NIK
- Nama lengkap
- Alamat
                          
Kami menjamin bahwa data Anda akan dijaga kerahasiaannya dan tidak akan dibagikan kepada pihak ketiga tanpa izin Anda.

Dengan menekan tombol "Setuju", Anda memberikan izin kepada kami untuk menyimpan dan menggunakan data Anda sesuai dengan ketentuan di atas."""),
                                SizedBox(height: kToolbarHeight + 16.h),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return InfoScanFaceScreen();
                        },
                      ),
                    );
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
                  width: MediaQuery.of(context).size.width,
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
                  color: Colors.red,
                  child: Image.asset(
                    AppAssets.imageKtp,
                    fit: BoxFit.cover,
                    height: 174.h,
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
                        Expanded(
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 18.h),
                                TextField(
                                  controller: nikController,
                                  decoration: InputDecoration(
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
                                  controller: namaController,
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
                                  controller: ttlController,
                                  decoration: InputDecoration(
                                    label: Text(
                                      "Tempat Tanggal Lahir",
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
                                    Expanded(
                                      child: TextField(
                                        controller: rtRwController,
                                        decoration: InputDecoration(
                                          label: Text(
                                            "RT/RW",
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
                                        controller: kelurahanDesaController,
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
                                  controller: agamaController,
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
                                  controller: pekerjaanController,
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
