import 'package:fingerprint_app/app.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await InitConfig.init(
    testModeValue: false,
    // testModeValue: true,
    screenshotActive: true,
  );
  runApp(const MyApp());
}
