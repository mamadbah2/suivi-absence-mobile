import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/absence_model.dart';
import '../../../data/repositories/etudiant_repository.dart';
import '../../../data/controllers/auth_controller.dart';

class AbsencesController extends GetxController {
  final EtudiantRepository _etudiantRepository = Get.find<EtudiantRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<AbsenceModel> absences = <AbsenceModel>[].obs;
  final RxList<AbsenceModel> filteredAbsences = <AbsenceModel>[].obs;

  // Statistiques
  final RxInt absenceCumulee = 0.obs;
  final RxInt absenceSoumise = 0.obs;
  final RxInt retardsCumules = 0.obs;
  final RxInt absenceRestante = 0.obs;

  // Filtres
  final RxString selectedPeriod = 'Aujourd\'hui'.obs;
  final RxString selectedType = 'Tous'.obs;
  final RxString selectedStatus = 'Tous'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAbsences();
  }

  Future<void> loadAbsences() async {
    try {
      final result = await _etudiantRepository
          .getAbsences(_authController.currentUser.value?.id ?? '');
      absences.value =
          result.map((json) => AbsenceModel.fromJson(json)).toList();
      updateStatistics();
      applyFilters();
    } catch (e) {
      print('Erreur lors du chargement des absences: $e');
    }
  }

  void updateStatistics() {
    absenceCumulee.value = absences.where((a) => !a.isRetard).length * 4;
    absenceSoumise.value =
        absences.where((a) => a.status == 'Justifiée').length * 4;
    retardsCumules.value = absences.where((a) => a.isRetard).length;
    absenceRestante.value = absenceCumulee.value - absenceSoumise.value;
  }

  void applyFilters() {
    var filtered = absences;

    // Filtre par période
    if (selectedPeriod.value == 'Aujourd\'hui') {
      final today = DateTime.now();
      filtered = filtered
          .where((a) {
            final absenceDate = DateTime.parse(a.date);
            return absenceDate.year == today.year &&
                absenceDate.month == today.month &&
                absenceDate.day == today.day;
          })
          .toList()
          .obs;
    } else if (selectedPeriod.value == 'Cette semaine') {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      filtered = filtered
          .where((a) {
            final absenceDate = DateTime.parse(a.date);
            return absenceDate.isAfter(startOfWeek);
          })
          .toList()
          .obs;
    }

    // Filtre par type
    if (selectedType.value != 'Tous') {
      filtered = filtered
          .where(
              (a) => selectedType.value == 'Retards' ? a.isRetard : !a.isRetard)
          .toList()
          .obs;
    }

    // Filtre par statut
    if (selectedStatus.value != 'Tous') {
      filtered =
          filtered.where((a) => a.status == selectedStatus.value).toList().obs;
    }

    filteredAbsences.value = filtered;
  }

  void setPeriodFilter(String period) {
    selectedPeriod.value = period;
    applyFilters();
  }

  void setTypeFilter(String type) {
    selectedType.value = type;
    applyFilters();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  Future<void> submitJustification(
      String absenceId, String motif, String? commentaire) async {
    try {
      final success = await _etudiantRepository.justifierAbsence(
        absenceId,
        'Motif: $motif${commentaire != null ? '\nCommentaire: $commentaire' : ''}',
      );

      if (success) {
        Get.back();
        Get.snackbar(
          'Succès',
          'Justification envoyée avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadAbsences(); // Recharger les absences pour mettre à jour le statut
      } else {
        Get.snackbar(
          'Erreur',
          'Échec de l\'envoi de la justification',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Erreur lors de la soumission de la justification: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
