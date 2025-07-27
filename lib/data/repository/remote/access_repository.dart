import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/access/request/login_request_model.dart';
import 'package:fingerprint_app/data/model/remote/access/response/login_response_model.dart';
import 'package:fingerprint_app/support/app_api_path.dart';

class AccessRepository {
  final AppApiServiceCS appApiService;
  AccessRepository(this.appApiService);

  Future<LoginResponseModel?> login(LoginRequestModel data) async {
    try {
      final response = await appApiService.call(
        AppApiPath.login,
        request: data.toJson(),
        method: MethodRequestCS.post,
      );
      if (response.data != null) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AccessRepository][login] errorMessage $errorMessage");
      return null;
    }
  }
}
