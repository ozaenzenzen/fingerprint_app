import 'dart:convert';

import 'package:fam_coding_supply/logic/app_logger.dart';
import 'package:fam_coding_supply/logic/local_service_hive.dart';
import 'package:fingerprint_app/data/model/remote/registration/response/get_list_registration_response_model.dart';
import 'package:fingerprint_app/init_config.dart';

class LocalHomeKey {
  static const String listRegistration = "listRegistration";
  static const String detailRegistration = "detailRegistration";
}

class LocalHomeRepository {
  static LocalServiceHive localServiceHive = InitConfig.famCodingSupply.localServiceHive;

  Future<void> setListRegistration(List<ItemGetListRegistration> value) async {
    // Future<void> setListRegistration(String value) async {
    try {
      String jsonString = jsonEncode(value.map((p) => p.toJson()).toList());
      // print('JSON String: $jsonString');

      await localServiceHive.user.putSecure(
        key: LocalHomeKey.listRegistration,
        data: jsonString,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][setListRegistration] error: $e");
      rethrow;
    }
  }

  Future<List<ItemGetListRegistration>?> getListRegistration() async {
    // Future<String?> getListRegistration() async {
    try {
      String? value = await localServiceHive.user.getSecure(
        key: LocalHomeKey.listRegistration,
      );
      if (value != null) {
        List<dynamic> jsonList = jsonDecode(value);
        List<ItemGetListRegistration> decodedPeople = jsonList.map((item) => ItemGetListRegistration.fromJson(item)).toList();
        return decodedPeople;
      } else {
        return [];
      }
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][getListRegistration] error: $e");
      return null;
    }
  }

  Future<void> setDetailRegistration(String value) async {
    try {
      await localServiceHive.user.putSecure(
        key: LocalHomeKey.detailRegistration,
        data: value,
      );
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][setDetailRegistration] error: $e");
      rethrow;
    }
  }

  Future<String?> getDetailRegistration() async {
    try {
      String? value = await localServiceHive.user.getSecure(
        key: LocalHomeKey.detailRegistration,
      );
      return value;
    } catch (e) {
      AppLoggerCS.debugLog("[LocalAccessRepository][getDetailRegistration] error: $e");
      return null;
    }
  }
}
