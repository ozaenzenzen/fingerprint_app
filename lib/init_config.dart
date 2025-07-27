import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/env.dart';

class InitConfig {
  static FamCodingSupply famCodingSupply = FamCodingSupply();

  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  // static AppConnectivityServiceCS appConnectivityServiceCS = AppConnectivityServiceCS();
  // static AppDeviceInfoCS appDeviceInfo = AppDeviceInfoCS();
  // static AppInfoCS appInfoCS = AppInfoCS();
  // static LocalServiceHive localServiceHive = LocalServiceHive();

  static Future<void> init() async {
    AppLoggerCS.useLogger = true;
    appApiService.useLogger = true;

    EnvironmentConfig.flavor = Flavor.staging;

    await famCodingSupply.localServiceHive.init();
    await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    await famCodingSupply.appDeviceInfo.getDeviceData();
  }
}
