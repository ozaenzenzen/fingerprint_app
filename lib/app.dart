import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/data/repository/local/local_access_repository.dart';
import 'package:fingerprint_app/init_config.dart';
import 'package:fingerprint_app/presentation/binding/root_binding.dart';
import 'package:fingerprint_app/presentation/home_screeen/home_screen.dart';
import 'package:fingerprint_app/presentation/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //final LoginController loginController = Get.find<LoginController>();
  final LocalAccessRepository localAccessRepository = LocalAccessRepository();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? value = await localAccessRepository.getAccessToken();
      AppLoggerCS.debugLog("value: $value");
      if (value != null) {
        isLogin = true;
      } else {
        isLogin = false;
      }
      AppLoggerCS.debugLog("isLogin: $isLogin");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      AppLoggerCS.debugLog("anyone call here: AppLifecycleState.resumed");
      AppLoggerCS.debugLog("anyone call here: ${(await LocalAccessRepository().getAccessToken() ?? "")}");
      InitConfig.accessToken = await LocalAccessRepository().getAccessToken() ?? "";
    } else {
      AppLoggerCS.debugLog("anyone call here 2: ${state.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // designSize: const Size(411, 869),
      child: _wrapWithBanner(
        child: GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          initialBinding: RootBinding(),
          // initialBinding: isLogin ? HomeBinding() : LoginBinding(),
          home: isLogin ? const HomeScreen() : const LoginScreen(),
          // initialBinding: isLogin ? LoginBinding() : HomeBinding(),
          // home: isLogin ? const LoginScreen() : const HomeScreen(),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }

  Widget _wrapWithBanner({required Widget child}) {
    return Banner(
      location: BannerLocation.topStart,
      message: (InitConfig.useOCRApi) ? 'OCR Api' : 'OCR Mobile',
      color: Colors.green.withOpacity(0.6),
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
      ),
      textDirection: ui.TextDirection.ltr,
      layoutDirection: ui.TextDirection.rtl,
      child: child,
    );
  }
}
