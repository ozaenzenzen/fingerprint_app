import 'package:fingerprint_app/presentation/home_screeen/controller/home_controller.dart';
import 'package:fingerprint_app/presentation/login_screen/controller/login_controller.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LoginController());
  }
}
