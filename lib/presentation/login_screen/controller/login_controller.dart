import 'package:fingerprint_app/data/model/remote/access/request/login_request_model.dart';
import 'package:fingerprint_app/data/model/remote/access/response/login_response_model.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
import 'package:fingerprint_app/data/repository/remote/access_repository.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // final LoginController controller = Get.find<LoginController>();
  final AccessRepository accessRepository = AccessRepository(InitConfig.appApiService);
  final LocalAccessRepository localAccessRepository = LocalAccessRepository();

  RxBool isLoadingLogin = false.obs;
  RxBool isLoadingLogout = false.obs;
  RxBool isHidePassword = true.obs;

  Future<void> template({
    required dynamic req,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {}

  Future<void> logout({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoadingLogout.value = true;
    try {
      await localAccessRepository.logout();
      isLoadingLogout.value = false;
      onSuccess?.call();
    } catch (e) {
      isLoadingLogout.value = false;
      onFailed?.call("[LoginController][logout] e: $e");
    }
  }

  Future<void> login({
    required LoginRequestModel req,
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoadingLogin.value = true;
    onFailedCallback(String errorMessage) {
      isLoadingLogin.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      LoginResponseModel? response = await accessRepository.login(req);
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
        await localAccessRepository.setAccessToken(response.data!.accessToken!);
        isLoadingLogin.value = false;
        onSuccess?.call();
        return;
      }
    } catch (e) {
      isLoadingLogin.value = false;
      onFailedCallback.call("[LoginController][login] ${e.toString()}");
    }
  }
}
