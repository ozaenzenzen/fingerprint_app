import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/presentation/register_user_screen/finger_scanning/info_scan_finger_screen.dart';
import 'package:flutter/material.dart';
import 'package:saas_mlkit/saas_mlkit.dart';

class CameraScanFaceScreen extends StatefulWidget {
  final void Function(String dataImage)? callback;

  const CameraScanFaceScreen({
    super.key,
    this.callback,
  });

  @override
  State<CameraScanFaceScreen> createState() => _CameraScanFaceScreenState();
}

class _CameraScanFaceScreenState extends State<CameraScanFaceScreen> {
  String? captured;
  void actionTakePicture(BuildContext context) async {
    if (cameraController != null) {
      XFile? data = await SaasLivenessHelper().takePicture(
        cameraController!,
      );

      if (data != null) {
        debugPrint('data captured $data');
        XFile? imageCaptured;
        imageCaptured = data;
        File tempImage;
        tempImage = File(
          imageCaptured.path, // DISINI ERRORNYA
        );
        var bytes = await tempImage.readAsBytes();
        captured = base64Encode(bytes);
        debugPrint('tempImage ${tempImage.path}');
        widget.callback!.call(captured!);
        // cameraController?.dispose();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        //
      }
    }
  }

  void actionTakePictureV2(BuildContext context) async {
    print("here");
    if (cameraController != null) {
      String? data = await SaasLivenessHelper().takePictureAsBase64(
        cameraController!,
      );
      if (data != null) {
        captured = data;
        debugPrint('captured $captured');
        widget.callback!.call(captured!);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        //
      }
    }
  }

  String currentAction = "notyet";
  CameraController? cameraController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Liveness",
      //     style: GoogleFonts.mukta(),
      //   ),
      // ),
      body: Stack(
        children: [
          Stack(
            children: [
              SaasLivenessCamera(
                onControllerCreated: (controller) {
                  cameraController = controller;
                },
                child: const OvalClip(),
                onOpenMouthDetected: (face) {
                  setState(() {
                    currentAction = 'onOpenMouthDetected';
                  });
                  debugPrint("onOpenMouthDetected");
                },
                onNodDetected: (face) {
                  setState(() {
                    currentAction = 'onNodDetected';
                  });
                  debugPrint("onNodDetected");
                },
                onBlinkDetected: (face) {
                  setState(() {
                    currentAction = 'onBlinkDetected';
                  });
                  debugPrint("onBlinkDetected");
                },
                onShakeHeadDetected: (face) {
                  setState(() {
                    currentAction = 'onShakeHeadDetected';
                  });
                  debugPrint("onShakeHeadDetected");
                },
                onFaceDetected: (face) {
                  debugPrint("onFaceDetected");
                },
                onFaceLoss: () {
                  setState(() {
                    currentAction = 'onFaceLoss';
                  });
                  debugPrint("onFaceLoss");
                },
                // onMultipleFaceDetected: () {
                //   debugPrint("onMultipleFaceDetected");
                // },
              ),
              Center(
                child: Container(
                  color: Colors.black,
                  child: Text(
                    // "Flutter Test Liveness Camera",
                    currentAction,
                    style: GoogleFonts.mukta(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        // actionTakePicture(context);
                        // actionTakePictureV2(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return InfoScanFingerScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Take Picture',
                        style: GoogleFonts.mukta(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
          SafeArea(
            child: Container(
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
                      "Face Recognition",
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
          ),
        ],
      ),
    );
  }
}
