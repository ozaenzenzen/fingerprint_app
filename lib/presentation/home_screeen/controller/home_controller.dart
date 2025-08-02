import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_list_registration_response_model.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_registration_by_id_response_model.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
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
    void Function(GetListRegistrationResponseModel result)? onSuccess,
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

      GetListRegistrationResponseModel? response = await registrationRepository.getListRegistration(
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
        isLoadingHome.value = false;
        responseRegistrationData.value = response;
        listRegistrationData.addAll(response.data!.items!);
        listRegistrationData.value = removeDuplicatesById(listRegistrationData);

        onSuccess?.call(response);
        return;
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
            onSuccess: (result) {
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
    } catch (e) {
      onFailedCallback.call("e: $e");
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
