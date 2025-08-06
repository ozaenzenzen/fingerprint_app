import 'dart:convert';
import 'dart:developer';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/face_compare_process_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_list_registration_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_registration_by_id_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/ocr_process_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/verify_face_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/fingerprint_process_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/verify_fingerprint_response_model.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:fingerprint_app/support/app_api_path.dart';
import 'package:dio/dio.dart' as dio;

class RegistrationRepository {
  final AppApiServiceCS appApiService;
  RegistrationRepository(this.appApiService);

  Future<GetListRegistrationResponseModel?> getListRegistration({
    int? currentPage,
    int? pageSize,
    String? searchQuery,
    String? sortBy,
    String? filterBy,
  }) async {
    // Create a map of non-null parameters
    final queryParams = <String, dynamic>{};

    // Add parameters only if they are not null
    if (currentPage != null) queryParams['currentPage'] = currentPage.toString();
    if (pageSize != null) queryParams['pageSize'] = pageSize.toString();
    if (searchQuery != null && searchQuery.isNotEmpty) queryParams['search'] = searchQuery;
    if (sortBy != null && sortBy.isNotEmpty) queryParams['sortBy'] = sortBy;
    if (filterBy != null && filterBy.isNotEmpty) queryParams['filterBy'] = filterBy;

    // Build query string
    String queryString = '';
    if (queryParams.isNotEmpty) {
      queryString = '?${queryParams.entries.map((entry) => '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}').join('&')}';
    }

    String path = "${AppApiPath.getListRegistration}$queryString";
    try {
      final response = await appApiService.call(
        path,
        method: MethodRequestCS.get,
        header: {
          "Authorization": "Bearer ${InitConfig.accessToken}",
        },
      );
      AppLoggerCS.debugLog("[getListRegistration] response.data: ${response.data}");
      if (response.data != null) {
        return GetListRegistrationResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[RegistrationRepository][getListRegistration] errorMessage $errorMessage");
      return null;
    }
  }

  Future<GetRegistrationByIdResponseModel?> getRegistrationById({
    required String id,
  }) async {
    String path = "${AppApiPath.getRegistrationById}/$id";
    try {
      final response = await appApiService.call(
        path,
        method: MethodRequestCS.get,
        header: {
          "Authorization": "Bearer ${InitConfig.accessToken}",
        },
      );
      if (response.data != null) {
        return GetRegistrationByIdResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[RegistrationRepository][getRegistrationById] errorMessage $errorMessage");
      return null;
    }
  }

  Future<OcrProcessResponseModel?> ocrProcess({
    required dio.MultipartFile image,
    required Map<String, dynamic> requestData,
  }) async {
    Map<String, dynamic> requestDataEdited = requestData;
    requestDataEdited.addAll({'image': image});

    String path = AppApiPath.ocrProcess;
    try {
      final response = await appApiService.call(
        path,
        request: requestDataEdited,
        method: MethodRequestCS.post,
        useFormData: true,
        header: {
          "Authorization": "Bearer ${InitConfig.accessToken}",
          "Content-Type": "multipart/form-data",
        },
      );
      log("[ocrProcess] response.data: ${jsonEncode(response.data)}");
      if (response.data != null) {
        return OcrProcessResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[RegistrationRepository][ocrProcess] errorMessage $errorMessage");
      return null;
    }
  }

  Future<FaceCompareProcessResponseModel?> faceCompareProcess({
    required dio.MultipartFile image,
    required Map<String, dynamic> requestData,
  }) async {
    Map<String, dynamic> requestDataEdited = requestData;
    requestDataEdited.addAll({'image': image});

    String path = AppApiPath.faceCompareProcess;
    try {
      final response = await appApiService.call(
        path,
        request: requestDataEdited,
        method: MethodRequestCS.post,
        useFormData: true,
        header: {
          "Authorization": "Bearer ${InitConfig.accessToken}",
          "Content-Type": "multipart/form-data",
        },
      );
      log("[faceCompareProcess] response.data: ${jsonEncode(response.data)}");
      if (response.data != null) {
        return FaceCompareProcessResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[RegistrationRepository][faceCompareProcess] errorMessage $errorMessage");
      return null;
    }
  }

  Future<FingerprintProcessResponseModel?> fingerprintProcess({
    required dio.MultipartFile image,
    required Map<String, dynamic> requestData,
  }) async {
    Map<String, dynamic> requestDataEdited = requestData;
    requestDataEdited.addAll({'image': image});

    String path = AppApiPath.fingerprintProcess;
    try {
      final response = await appApiService.call(
        path,
        request: requestDataEdited,
        method: MethodRequestCS.post,
        useFormData: true,
        header: {
          "Authorization": "Bearer ${InitConfig.accessToken}",
          "Content-Type": "multipart/form-data",
        },
      );
      log("[fingerprintProcess] response.data: ${jsonEncode(response.data)}");
      if (response.data != null) {
        return FingerprintProcessResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[RegistrationRepository][fingerprintProcess] errorMessage $errorMessage");
      return null;
    }
  }

  Future<VerifyFaceResponseModel?> verifyFace({
    required String id,
    required dio.MultipartFile image,
  }) async {
    Map<String, dynamic> requestDataEdited = {
      'image': image,
    };

    String path = "${AppApiPath.verifyFace}/$id/verify-face";
    try {
      final response = await appApiService.call(
        path,
        request: requestDataEdited,
        method: MethodRequestCS.post,
        useFormData: true,
        header: {
          "Authorization": "Bearer ${InitConfig.accessToken}",
          "Content-Type": "multipart/form-data",
        },
      );
      log("[verifyFace] response.data: ${jsonEncode(response.data)}");
      if (response.data != null) {
        return VerifyFaceResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[RegistrationRepository][verifyFace] errorMessage $errorMessage");
      return null;
    }
  }

  Future<VerifyFingerprintResponseModel?> verifyFingerprint({
    required String id,
    required dio.MultipartFile image,
  }) async {
    Map<String, dynamic> requestDataEdited = {
      'image': image,
    };

    String path = "${AppApiPath.verifyFingeprint}/$id/verify-fingerprint";
    try {
      final response = await appApiService.call(
        path,
        request: requestDataEdited,
        method: MethodRequestCS.post,
        useFormData: true,
        header: {
          "Authorization": "Bearer ${InitConfig.accessToken}",
          "Content-Type": "multipart/form-data",
        },
      );
      log("[verifyFingerprint] response.data: ${jsonEncode(response.data)}");
      if (response.data != null) {
        return VerifyFingerprintResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[RegistrationRepository][verifyFingerprint] errorMessage $errorMessage");
      return null;
    }
  }
}
