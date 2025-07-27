import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/support/app_assets.dart';
import 'package:flutter/material.dart';

class DetailUserScreen extends StatefulWidget {
  const DetailUserScreen({super.key});

  @override
  State<DetailUserScreen> createState() => _DetailUserScreenState();
}

class _DetailUserScreenState extends State<DetailUserScreen> {
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
                  color: Colors.red,
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
                                //
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
                                //
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
                        Expanded(
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 18.h),
                                TextField(
                                  readOnly: true,
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
                                  readOnly: true,
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
                                        readOnly: true,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
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
                                        readOnly: true,
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
