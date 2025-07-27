import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/support/widget/app_loading_indicator_widget.dart';
import 'package:flutter/material.dart';

class AppOverlayLoadingWidget extends StatelessWidget {
  const AppOverlayLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black45,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLoadingIndicatorWidget(),
            SizedBox(height: 14.h),
            Text(
              "Loading...",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
