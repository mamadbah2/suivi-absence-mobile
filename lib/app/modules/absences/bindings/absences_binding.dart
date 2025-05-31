import 'package:get/get.dart';
import '../controllers/absences_controller.dart';
import '../../../data/providers/etudiant_provider.dart';
import '../../../data/repositories/etudiant_repository.dart';

class AbsencesBinding implements Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut(() => EtudiantProvider());

    // Repositories
    Get.lazyPut(() => EtudiantRepository());

    // Controllers
    Get.lazyPut(() => AbsencesController());
  }
}
