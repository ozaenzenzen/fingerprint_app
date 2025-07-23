import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:fingerprint_app/home_screen.dart';
import 'package:fingerprint_app/presentation/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // designSize: const Size(411, 869),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginScreen(),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
