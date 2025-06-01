import 'package:get/get.dart';
import '../../pointage/controllers/pointage_controller.dart';

class MarquageBinding implements Bindings {
  @override
  void dependencies() {
    // S'assurer que le PointageController est disponible
    if (!Get.isRegistered<PointageController>()) {
      // Cette condition ne devrait normalement pas être remplie
      // car le PointageController devrait déjà être injecté par PointageBinding
      // Mais c'est une sécurité supplémentaire
      Get.lazyPut<PointageController>(() => PointageController());
    }
  }
}