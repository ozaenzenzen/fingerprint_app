import 'dart:developer';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
import 'package:fingerprint_app/env.dart';
import 'package:no_screenshot/no_screenshot.dart';

class InitConfig {
  static FamCodingSupply famCodingSupply = FamCodingSupply();

  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());

  // static AppConnectivityServiceCS appConnectivityServiceCS = AppConnectivityServiceCS();
  // static AppDeviceInfoCS appDeviceInfo = AppDeviceInfoCS();
  // static AppInfoCS appInfoCS = AppInfoCS();
  // static LocalServiceHive localServiceHive = LocalServiceHive();

  static String accessToken = "";
  static bool testMode = false;

  static final NoScreenshot _noScreenshot = NoScreenshot.instance;

  // static void disableScreenshot() async {
  //   bool result = await _noScreenshot.screenshotOff();
  //   log('Screenshot Off: $result');
  // }

  static Future<void> init({
    bool testModeValue = false,
    bool screenshotActive = true,
  }) async {
    testMode = testModeValue;

    AppLoggerCS.useLogger = true;
    AppLoggerCS.useFoundation = true;
    appApiService.useLogger = true;

    AppLoggerCS.debugLog("call init");

    EnvironmentConfig.flavor = Flavor.staging;

    await famCodingSupply.localServiceHive.init();
    await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    await famCodingSupply.appDeviceInfo.getDeviceData();

    InitConfig.accessToken = await LocalAccessRepository().getAccessToken() ?? "";

    if (screenshotActive) {
      await _noScreenshot.screenshotOn();
    } else {
      await _noScreenshot.screenshotOff();
    }
  }
}
