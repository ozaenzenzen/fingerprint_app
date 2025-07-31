import 'dart:io';

import 'package:fingerprint_app/data/model/remote/registration/response/face_compare_process_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/ocr_process_response_model.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
import 'package:fingerprint_app/data/repository/remote/access_repository.dart';
import 'package:fingerprint_app/data/repository/remote/registration_repository.dart';
import 'package:fingerprint_app/domain/ocr_data_holder_model.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

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

    dio.MultipartFile image = await dio.MultipartFile.fromFile(
      faceFromKtp.path,
      filename: faceFromKtp.path.toString().split('/').last,
    );

    try {
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
        onFailedCallback.call("${response.message} #0002");
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
      onFailedCallback.call("${e.toString()} #0004");
    }
  }

  Rxn<String> requestId = Rxn<String>();

  Future<void> faceCompareProcess({
    required File faceLiveness,
    // required String requestId,
    void Function(FaceCompareProcessResponseModel result)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoading.value = true;
    onFailedCallback(String errorMessage) {
      isLoading.value = false;
      onFailed?.call(errorMessage);
    }

    dio.MultipartFile image = await dio.MultipartFile.fromFile(
      faceLiveness.path,
      filename: faceLiveness.path.toString().split('/').last,
    );

    try {
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
        onFailedCallback.call("${response.message} #0002");
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
}
