import 'package:get/get.dart';
import '../controllers/justification_controller.dart';
import '../../../data/providers/etudiant_provider.dart';
import '../../../data/repositories/etudiant_repository.dart';

class JustificationBinding implements Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut(() => EtudiantProvider());

    // Repositories
    Get.lazyPut(() => EtudiantRepository());

    // Controllers
    Get.lazyPut(
      () => JustificationController(
        absenceId: Get.arguments['absenceId'] ?? '',
        date: Get.arguments['date'] ?? '',
        cours: Get.arguments['cours'] ?? '',
      ),
    );
  }
}
