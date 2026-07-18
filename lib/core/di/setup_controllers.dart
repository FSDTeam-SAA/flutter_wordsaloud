import 'package:get/get_core/src/get_main.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../features/tradesman_account_creation/controller/tradesman_controller.dart';
import '../utils/getx_helper.dart';

void setupControllers() {
  Get.getOrPut(() => AuthController());
  Get.getOrPut(() => TradesmanController(), fenix: true);
}
