import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';

class MainButtonWidget extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final double? height;
  final Color backgroundColor;
  final Color textColor;

  const MainButtonWidget({
    super.key,
    required this.title,
    this.onPressed,
    this.height,
  })  : backgroundColor = const Color(0xff1183FF),
        textColor = const Color(0xffffffff);

  const MainButtonWidget.inverse({
    super.key,
    required this.title,
    this.onPressed,
    this.height,
  })  : textColor = const Color(0xff1183FF),
        backgroundColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 40.h,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          // backgroundColor: const Color(0xff1183FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
            color: textColor,
            // color: Colors.white,
            // color: const Color(0xff999999),
          ),
        ),
      ),
    );
  }
}
