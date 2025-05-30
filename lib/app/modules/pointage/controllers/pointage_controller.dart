import 'package:get/get.dart';
import '../../../data/models/absence.dart';
import '../../../data/providers/pointage_provider.dart'; // Import PointageProvider

class PointageController extends GetxController {
  final PointageProvider _pointageProvider = Get.find<PointageProvider>(); // Inject PointageProvider
  final RxList<Absence> absences = <Absence>[].obs;
  final RxBool isLoading = true.obs; // Set to true initially to show loading for initial fetch
  final RxString error = ''.obs;

  // Example: ID of the current course, replace with actual dynamic value
  final String _idCoursActuel = "FLUTTER_L3_2024"; 

  @override
  void onInit() {
    super.onInit();
    fetchListeAbsences();
  }

  Future<void> fetchListeAbsences() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _pointageProvider.getListeAbsencesPourCours(_idCoursActuel);
      absences.assignAll(result);
    } catch (e) {
      error.value = "Erreur lors de la récupération de la liste des étudiants: $e";
      Get.snackbar("Erreur", "Impossible de charger la liste des étudiants.");
    } finally {
      isLoading.value = false;
    }
  }

  Absence? getAbsenceByMatricule(String matricule) {
    try {
      return absences.firstWhere((a) => a.matricule == matricule);
    } catch (_) {
      return null;
    }
  }

  Future<void> marquerPresent(String matricule) async {
    final index = absences.indexWhere((a) => a.matricule == matricule);
    if (index != -1) {
      // Optimistic update: update UI immediately
      // final originalAbsence = absences[index]; // Keep original for potential rollback
      absences[index] = absences[index].copyWith(status: 'present');
      
      try {
        // Call provider to update backend
        final updatedAbsence = await _pointageProvider.marquerEtudiantPresent(matricule, _idCoursActuel);
        if (updatedAbsence != null) {
          // Update with data from backend if necessary (e.g., if backend returns more fields or confirms ID)
          absences[index] = updatedAbsence; 
        } else {
          // Handle case where backend update fails but no error was thrown by provider
          // Potentially rollback: absences[index] = originalAbsence;
          // Get.snackbar("Avertissement", "Le statut n'a pas pu être confirmé par le serveur.");
        }
      } catch (e) {
        // Rollback UI change if backend update fails
        // absences[index] = originalAbsence;
        // For simplicity, we'll just show an error. A more robust app might rollback.
        absences[index] = absences[index].copyWith(status: 'absent'); // Simple rollback for demo
        Get.snackbar("Erreur", "Impossible de marquer l'étudiant comme présent: $e");
        // Re-throw if you want the UI to handle the error state more explicitly
        // rethrow;
      }
    }
  }
}