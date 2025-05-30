import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';
import '../../../data/providers/pointage_provider.dart';

class PointageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PointageProvider>(() => PointageProvider());
    Get.lazyPut<PointageController>(() => PointageController());
    print('PointageBinding: PointageProvider and PointageController initialized.');
  }
}




