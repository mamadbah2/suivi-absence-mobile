import 'package:get/get.dart';
import '../../../data/repositories/etudiant_repository.dart';

class JustificationController extends GetxController {
  final EtudiantRepository _etudiantRepository = Get.find<EtudiantRepository>();
  final RxString justification = ''.obs;
  final RxBool isLoading = false.obs;

  final String absenceId;
  final String date;
  final String cours;

  JustificationController({
    required this.absenceId,
    required this.date,
    required this.cours,
  });

  void setJustification(String value) => justification.value = value;

  Future<void> soumettreJustification() async {
    if (justification.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir une justification',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final success = await _etudiantRepository.justifierAbsence(
        absenceId,
        justification.value,
      );

      if (success) {
        Get.back(result: true);
        Get.snackbar(
          'Succès',
          'Justification enregistrée avec succès',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Erreur',
          'Échec de l\'enregistrement de la justification',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
