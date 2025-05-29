import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:suivi_absence_mobile/models/absence.dart';
import 'package:suivi_absence_mobile/services/absence_service.dart';

class AbsenceController extends GetxController {
  final AbsenceService _absenceService = AbsenceService();
  final _logger = Logger();
  final _absencesDuJour = <Absence>[].obs;
  final _isLoading = false.obs;
  final _error = RxnString();
  String? _currentMatricule;

  List<Absence> get absencesDuJour => _absencesDuJour;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  Future<void> getAbsencesDuJour(String matricule) async {
    try {
      _isLoading.value = true;
      _error.value = null;
      _currentMatricule = matricule;

      final today = DateTime.now();
      final absence = await _absenceService.getAbsencesDuJourParEtudiant(
        today,
        matricule,
      );
      _logger.d('Absence du jour: $absence');

      if (absence.isNotEmpty) {
        _absencesDuJour.value = absence;
      } else {
        _absencesDuJour.value = [];
      }
    } catch (e) {
      _error.value =
          "Erreur lors de la récupération des absences: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> toggleAbsence(int idAbsence) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      await _absenceService.toggleAbsence(idAbsence);

      // Rafraîchir la liste des absences après la modification
      if (_currentMatricule != null) {
        await getAbsencesDuJour(_currentMatricule!);
      }
    } catch (e) {
      _error.value =
          "Erreur lors de la modification de l'absence: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
  }
}
