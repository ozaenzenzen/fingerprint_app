import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/model/remote/access/response/get_profile_response_model.dart';
import 'package:fingerprint_app/init_config.dart';

class LocalKey {
  static const String accessToken = "accessToken";
  static const String profileData = "profileData";
}

class LocalAccessRepository {
  static LocalServiceHive localServiceHive = InitConfig.famCodingSupply.localServiceHive;

  Future<void> logout() async {
    try {
      await localServiceHive.user.clear();
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][logout] error: $e");
      rethrow;
    }
  }

  Future<void> setAccessToken(String value) async {
    try {
      await localServiceHive.user.putSecure(
        key: LocalKey.accessToken,
        data: value,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][setAccessToken] error: $e");
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      String? value = await localServiceHive.user.getSecure(
        key: LocalKey.accessToken,
      );
      return value;
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][getAccessToken] error: $e");
      return null;
    }
  }

  Future<void> setProfileData(DataGetProfile value) async {
    try {
      await localServiceHive.user.putSecure(
        key: LocalKey.profileData,
        data: value,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][setProfileData] error: $e");
      rethrow;
    }
  }

  Future<String?> getProfileData() async {
    try {
      String? value = await localServiceHive.user.getSecure(
        key: LocalKey.profileData,
      );
      return value;
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][getProfileData] error: $e");
      return null;
    }
  }
}
