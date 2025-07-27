import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';

class AppLoadingIndicatorWidget extends StatelessWidget {
  const AppLoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40.h,
      width: 40.h,
      child: const CircularProgressIndicator(
        color: Color(0xff1183FF),
      ),
    );
  }
}
