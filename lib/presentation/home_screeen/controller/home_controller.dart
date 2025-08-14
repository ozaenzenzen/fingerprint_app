import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_list_registration_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_registration_by_id_response_model.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
import 'package:fingerprint_app/data/repository/local/local_home_repository.dart';
import 'package:fingerprint_app/data/repository/remote/access_repository.dart';
import 'package:fingerprint_app/data/repository/remote/registration_repository.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final AccessRepository accessRepository = AccessRepository(InitConfig.appApiService);
  final RegistrationRepository registrationRepository = RegistrationRepository(InitConfig.appApiService);
  final LocalAccessRepository localAccessRepository = LocalAccessRepository();

  RxBool isLoadingHome = false.obs;

  RxInt currentPage = 1.obs;
  Rxn<GetListRegistrationResponseModel> responseRegistrationData = Rxn<GetListRegistrationResponseModel>();
  RxList<ItemGetListRegistration> listRegistrationData = <ItemGetListRegistration>[].obs;

  Future<void> getListRegistration({
    // int? currentPage = 1,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    AppLoggerCS.debugLog("[getListRegistration] called");
    isLoadingHome.value = true;
    onFailedCallback(String errorMessage) {
      isLoadingHome.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      currentPage.value = 1;

      if (InitConfig.testMode) {
        await Future.delayed(const Duration(seconds: 1));
        List<ItemGetListRegistration>? dataListRegist = await LocalHomeRepository().getListRegistration();
        if (dataListRegist != null) {
          listRegistrationData.addAll(dataListRegist);
          isLoadingHome.value = false;
          onSuccess?.call();
        } else {
          onFailedCallback.call("response is null");
          return;
        }
      } else {
        GetListRegistrationResponseModel? response = await registrationRepository.getListRegistration(
          searchQuery: searchTextFieldValue.value,
          currentPage: currentPage.value,
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
          if (currentPage.value == 1) {
            listRegistrationData.value = [];
          }
          isLoadingHome.value = false;
          responseRegistrationData.value = response;
          listRegistrationData.addAll(response.data!.items!);
          listRegistrationData.value = removeDuplicatesById(listRegistrationData);

          onSuccess?.call();
          return;
        }
      }
    } catch (e) {
      onFailedCallback.call("e: $e");
    }
  }

  Future<void> loadMoreListRegistration({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    AppLoggerCS.debugLog("loadMoreListRegistration");
    onFailedCallback(String errorMessage) {
      onFailed?.call(errorMessage);
    }

    try {
      if (responseRegistrationData.value != null) {
        if (responseRegistrationData.value?.data != null && responseRegistrationData.value!.data!.pagination!.hasMore!) {
          currentPage++;

          await getListRegistration(
            onSuccess: () {
              isLoadingHome.value = false;
              onSuccess?.call();
            },
            onFailed: (errorMessage) {
              isLoadingHome.value = false;
              onFailedCallback.call("e: $errorMessage");
            },
          );
        } else {
          onSuccess?.call();
        }
      }
    } catch (e) {
      onFailedCallback.call("e: $e");
    }
  }

  List<ItemGetListRegistration> removeDuplicatesById(List<ItemGetListRegistration> originalList) {
    final seenIds = <String>{};
    return originalList.where((item) {
      final isNew = !seenIds.contains(item.id);
      seenIds.add(item.id!);
      return isNew;
    }).toList();
  }

  Rx<GetRegistrationByIdResponseModel> responseDetailRegistration = GetRegistrationByIdResponseModel().obs;

  Future<void> getRegistrationById({
    required String id,
    void Function(GetRegistrationByIdResponseModel result)? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoadingHome.value = true;
    onFailedCallback(String errorMessage) {
      isLoadingHome.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      if (InitConfig.testMode) {
        await Future.delayed(const Duration(seconds: 1));
        String dataString = """
{
  "statusCode": 200,
  "message": "Registration data retrieved successfully",
  "data": {
    "id": "REG-123456",
    "ktpImageUrl": "https://example.com/ktp/123456.jpg",
    "isDoneFingerprint": true,
    "isDoneFacialRecognition": false,
    "registeredAt": "2023-06-15T09:30:45Z",
    "surveyor": {
      "fullName": "Budi Santoso"
    },
    "user": {
      "id": "USR-789",
      "nik": "3273010101980001",
      "fullName": "Debby Anggraini",
      "placeOfBirth": "Jakarta",
      "dateOfBirth": "1990-12-21",
      "gender": "Female",
      "bloodType": "A",
      "address": "Jl. Merdeka No. 123",
      "rt": "001",
      "rw": "002",
      "kelurahan": "Menteng",
      "kecamatan": "Jakarta Pusat",
      "city": "Jakarta",
      "province": "DKI Jakarta",
      "religion": "Islam",
      "maritalStatus": "Single",
      "occupation": "Software Developer",
      "nationality": "Indonesia",
      "validUntil": "Permanent",
      "createdAt": "2023-06-01T08:00:00Z",
      "updatedAt": "2023-06-15T09:30:45Z"
    },
    "registrationTimelines": [
      {
        "id": "TLN-001",
        "registrationId": "REG-123456",
        "userNik": "3273010101980001",
        "step": "Document Upload",
        "status": "Completed",
        "createdAt": "2023-06-15T09:15:00Z",
        "updatedAt": "2023-06-15T09:20:00Z"
      },
      {
        "id": "TLN-002",
        "registrationId": "REG-123456",
        "userNik": "3273010101980001",
        "step": "Fingerprint",
        "status": "Completed",
        "createdAt": "2023-06-15T09:25:00Z",
        "updatedAt": "2023-06-15T09:28:00Z"
      },
      {
        "id": "TLN-003",
        "registrationId": "REG-123456",
        "userNik": "3273010101980001",
        "step": "Facial Recognition",
        "status": "Pending",
        "createdAt": "2023-06-15T09:30:00Z",
        "updatedAt": "2023-06-15T09:30:00Z"
      }
    ]
  }
}
""";
        GetRegistrationByIdResponseModel? response = GetRegistrationByIdResponseModel.fromJson(jsonDecode(dataString));
        isLoadingHome.value = false;
        responseDetailRegistration.value = response;
        onSuccess?.call(response);
      } else {
        GetRegistrationByIdResponseModel? response = await registrationRepository.getRegistrationById(
          id: id,
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
          isLoadingHome.value = false;
          responseDetailRegistration.value = response;
          onSuccess?.call(response);
          return;
        }
      }
    } catch (e) {
      onFailedCallback.call("e: $e");
    }
  }

  final int minLengthNIK = 16;
  final int maxLengthNIK = 16;
  Rxn<String> errorTextNIK = Rxn<String>();
  Rxn<String> textNIK = Rxn<String>();
  RxInt lengthTextNIK = RxInt(0);
  void validateTextNIK(
    String text, {
    void Function()? callbackSetState,
  }) {
    textNIK.value = text;
    lengthTextNIK.value = text.length;
    if (text.length < minLengthNIK) {
      errorTextNIK.value = 'Minimum $minLengthNIK characters required';
    } else if (text.length > minLengthNIK) {
      errorTextNIK.value = 'Maximum $minLengthNIK characters required';
    } else {
      errorTextNIK.value = null;
    }
    callbackSetState?.call();
  }

  final int minLengthRT = 3;
  final int maxLengthRT = 3;
  Rxn<String> errorTextRT = Rxn<String>();
  Rxn<String> textRT = Rxn<String>();
  RxInt lengthTextRT = RxInt(0);
  void validateTextRT(
    String text, {
    void Function()? callbackSetState,
  }) {
    textRT.value = text;
    lengthTextRT.value = text.length;
    if (text.length < minLengthRT) {
      errorTextRT.value = 'Minimum $minLengthRT characters required';
    } else if (text.length > minLengthRT) {
      errorTextRT.value = 'Maximum $minLengthRT characters required';
    } else {
      errorTextRT.value = null;
    }
    callbackSetState?.call();
  }

  final int minLengthRW = 3;
  final int maxLengthRW = 3;
  Rxn<String> errorTextRW = Rxn<String>();
  Rxn<String> textRW = Rxn<String>();
  RxInt lengthTextRW = RxInt(0);

  void validateTextRW(
    String text, {
    void Function()? callbackSetState,
  }) {
    textRW.value = text;
    lengthTextRW.value = text.length;
    if (text.length < minLengthRW) {
      errorTextRW.value = 'Minimum $minLengthRW characters required';
    } else if (text.length > minLengthRW) {
      errorTextRW.value = 'Maximum $minLengthRW characters required';
    } else {
      errorTextRW.value = null;
    }
    callbackSetState?.call();
  }

  // RxString searchTextFieldValue = ''.obs;
  Rxn<String> searchTextFieldValue = Rxn(null);
}
