import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';

class PointageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PointageController>(
      () => PointageController(),
    );
  }
}
