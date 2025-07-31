import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fam_coding_supply/logic/app_base64converter_helper.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/face_compare_process_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/ocr_process_response_model.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
import 'package:fingerprint_app/data/repository/remote/access_repository.dart';
import 'package:fingerprint_app/data/repository/remote/registration_repository.dart';
import 'package:fingerprint_app/domain/ocr_data_holder_model.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:fingerprint_app/support/app_datatype_converter.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class RegisterController extends GetxController {
  final AccessRepository accessRepository = AccessRepository(InitConfig.appApiService);
  final RegistrationRepository registrationRepository = RegistrationRepository(InitConfig.appApiService);
  final LocalAccessRepository localAccessRepository = LocalAccessRepository();

  Rxn<OcrDataHolderModel> ocrHolder = Rxn<OcrDataHolderModel>();
  Rxn<File> faceFromKtp = Rxn<File>();
  Rxn<File> faceLiveness = Rxn<File>();

  Rxn<DateTime> tanggalLahirChosen = Rxn<DateTime>();

  RxBool isPrivacyAgreement = false.obs;

  RxBool isLoading = false.obs;

  Future<void> ocrProcess({
    required File faceFromKtp,
    required Map<String, dynamic> reqBody,
    void Function(OcrProcessResponseModel result)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    onFailedCallback(String errorMessage) {
      isLoading.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      File? outputFile = await AppDatatypeConverter().fileToFile(
        sourceFile: faceFromKtp,
        outputFileName: 'faceFromKtp.jpg',
        format: 'jpeg',
        quality: 100,
        // resizeWidth: 200, // Resize to 200px width
      );

      if (outputFile == null) {
        onFailedCallback.call("failed at processing image");
        return;
      }

      log("outputFile.path: ${outputFile.path}");
      log("outputFile.path.toString().split('/').last: ${outputFile.path.toString().split('/').last}");
      dio.MultipartFile image = await dio.MultipartFile.fromFile(
        outputFile.path,
        filename: outputFile.path.toString().split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      // log("faceLiveness.path: ${faceFromKtp.path}");
      // log("faceLiveness.path.toString().split('/').last: ${faceFromKtp.path.toString().split('/').last}");
      // dio.MultipartFile image = await dio.MultipartFile.fromFile(
      //   faceFromKtp.path,
      //   filename: faceFromKtp.path.toString().split('/').last,
      //   contentType: MediaType('image', 'png'),
      // );
      OcrProcessResponseModel? response = await registrationRepository.ocrProcess(
        image: image,
        requestData: reqBody,
      );
      if (response == null) {
        onFailedCallback.call("response is null");
        return;
      }

      if (response.statusCode == null) {
        onFailedCallback.call("${response.message} #0001");
        return;
      }

      if (response.statusCode != 200) {
        onFailedCallback.call("${response.message}: ${(response.data != null) ? (jsonEncode(response.data)) : ""} #0002");
        return;
      }

      if (response.data == null) {
        onFailedCallback.call("${response.message} #0003");
        return;
      }

      if (response.statusCode == 200) {
        isLoading.value = false;
        requestId.value = response.data?.requestId;
        onSuccess?.call(response);
        return;
      }
    } catch (e) {
      isLoading.value = false;
      onFailedCallback.call("${e.toString()} #0004");
    }
  }

  Rxn<String> requestId = Rxn<String>();

  Future<void> faceCompareProcess({
    required File faceLiveness,
    void Function(FaceCompareProcessResponseModel result)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    onFailedCallback(String errorMessage) {
      isLoading.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      File? outputFile = await AppDatatypeConverter().fileToFile(
        sourceFile: faceLiveness,
        outputFileName: 'faceLiveness.jpg',
        format: 'jpeg',
        quality: 100,
        // resizeWidth: 200, // Resize to 200px width
      );

      if (outputFile == null) {
        onFailedCallback.call("failed at processing image");
        return;
      }

      log("outputFile.path: ${outputFile.path}");
      log("outputFile.path.toString().split('/').last: ${outputFile.path.toString().split('/').last}");
      dio.MultipartFile image = await dio.MultipartFile.fromFile(
        outputFile.path,
        filename: outputFile.path.toString().split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      // log("faceLiveness.path: ${faceLiveness.path}");
      // log("faceLiveness.path.toString().split('/').last: ${faceLiveness.path.toString().split('/').last}");
      // dio.MultipartFile image = await dio.MultipartFile.fromFile(
      //   faceLiveness.path,
      //   filename: faceLiveness.path.toString().split('/').last,
      //   contentType: MediaType('image', 'png'),
      // );

      FaceCompareProcessResponseModel? response = await registrationRepository.faceCompareProcess(
        image: image,
        requestData: {
          "requestId": requestId.value,
        },
      );
      if (response == null) {
        onFailedCallback.call("response is null");
        return;
      }

      if (response.statusCode == null) {
        onFailedCallback.call("${response.message} #0001");
        return;
      }

      if (response.statusCode != 200) {
        onFailedCallback.call("${response.message}: ${(response.data != null) ? (jsonEncode(response.data)) : ""} #0002");
        return;
      }

      if (response.data == null) {
        onFailedCallback.call("${response.message} #0003");
        return;
      }

      if (response.statusCode == 200) {
        isLoading.value = false;
        onSuccess?.call(response);
        return;
      }
    } catch (e) {
      onFailedCallback.call("${e.toString()} #0004");
    }
  }

  final int minLengthNIK = 16;
  final int maxLengthNIK = 16;
  Rxn<String> errorTextNIK = Rxn<String>();
  void validateTextNIK(String text) {
    if (text.length < minLengthNIK) {
      errorTextNIK.value = 'Minimum $minLengthNIK characters required';
    } else {
      errorTextNIK.value = null;
    }
  }

  final int minLengthRT = 3;
  final int maxLengthRT = 3;
  Rxn<String> errorTextRT = Rxn<String>();
  void validateTextRT(String text) {
    if (text.length < minLengthRT) {
      errorTextRT.value = 'Minimum $minLengthRT characters required';
    } else {
      errorTextRT.value = null;
    }
  }

  final int minLengthRW = 3;
  final int maxLengthRW = 3;
  Rxn<String> errorTextRW = Rxn<String>();
  void validateTextRW(String text) {
    if (text.length < minLengthRW) {
      errorTextRW.value = 'Minimum $minLengthRW characters required';
    } else {
      errorTextRW.value = null;
    }
  }
}
