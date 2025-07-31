import 'package:fingerprint_app/data/model/remote/registration/response/get_list_registration_response_model.dart';
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

  Future<void> getListRegistration({
    int? currentPage = 1,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoadingHome.value = true;
    onFailedCallback(String errorMessage) {
      isLoadingHome.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      GetListRegistrationResponseModel? response = await registrationRepository.getListRegistration(
        currentPage: currentPage,
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
        onSuccess?.call();
        return;
      }
    } catch (e) {
      onFailedCallback.call("e: $e");
    }
  }

  Future<void> getRegistrationById({
    required String id,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoadingHome.value = true;
    onFailedCallback(String errorMessage) {
      isLoadingHome.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      GetListRegistrationResponseModel? response = await registrationRepository.getRegistrationById(
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
        onSuccess?.call();
        return;
      }
    } catch (e) {
      onFailedCallback.call("e: $e");
    }
  }
}
