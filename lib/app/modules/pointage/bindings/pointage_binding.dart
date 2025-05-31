import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';
import '../../../data/providers/pointage_provider.dart';
import '../../../data/providers/auth_provider.dart'; // Import AuthProvider

class PointageBinding implements Bindings {
  @override
  void dependencies() {
    // Initialiser AuthProvider en premier car PointageProvider en dépend
    if (!Get.isRegistered<AuthProvider>()) {
      Get.put(AuthProvider(), permanent: true);
      print('PointageBinding: AuthProvider initialized.');
    }
    
    // Ensuite initialiser PointageProvider et PointageController
    Get.lazyPut<PointageProvider>(() => PointageProvider());
    Get.lazyPut<PointageController>(() => PointageController());
    print('PointageBinding: PointageProvider and PointageController initialized.');
  }
}




