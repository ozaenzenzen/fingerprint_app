import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/env.dart';

class InitConfig {
  static FamCodingSupply famCodingSupply = FamCodingSupply();

  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  static AppConnectivityServiceCS appConnectivityServiceCS = AppConnectivityServiceCS();
  static AppDeviceInfoCS appDeviceInfo = AppDeviceInfoCS();
  static AppInfoCS appInfoCS = AppInfoCS();
  static LocalServiceHive localServiceHive = LocalServiceHive();
  
  static Future<void> init() async {
    await localServiceHive.init();
    await appInfoCS.init();
    await appConnectivityServiceCS.init();
    await appDeviceInfo.getDeviceData();
  }
}