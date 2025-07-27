import 'package:fingerprint_app/data/model/remote/access/response/get_profile_response_model.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
import 'package:fingerprint_app/data/repository/remote/access_repository.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:get/state_manager.dart';

class ProfileController extends GetxController {
  RxBool isLoadingProfile = false.obs;

  final AccessRepository accessRepository = AccessRepository(InitConfig.appApiService);
  final LocalAccessRepository localAccessRepository = LocalAccessRepository();

  Rxn<DataGetProfile> dataProfile = Rxn<DataGetProfile>();

  Future<void> getProfile({
    void Function()? onSuccess,
    void Function(String errorMessage)? onFailed,
  }) async {
    isLoadingProfile.value = true;
    onFailedCallback(String errorMessage) {
      isLoadingProfile.value = false;
      onFailed?.call(errorMessage);
    }

    try {
      GetProfileResponseModel? response = await accessRepository.getProfile();
      if (response == null) {
        onFailedCallback.call("response is null");
        return;
      }

      if (response.statusCode == null) {
        onFailedCallback.call("${response.message} #0011");
        return;
      }

      if (response.statusCode != 200) {
        onFailedCallback.call("${response.message} #0012");
        return;
      }

      if (response.data == null) {
        onFailedCallback.call("${response.message} #0013");
        return;
      }

      if (response.statusCode == 200) {
        await localAccessRepository.setProfileData(response.data!);
        dataProfile.value = response.data!;
        isLoadingProfile.value = false;
        onSuccess?.call();
        return;
      }
    } catch (e) {
      onFailedCallback.call(e.toString());
    }
  }
}
