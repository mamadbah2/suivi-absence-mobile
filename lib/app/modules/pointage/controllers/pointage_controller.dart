import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../data/models/etudiant_pointage_model.dart';
import 'package:flutter/material.dart';

class PointageController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final searchQuery = ''.obs;
  final matriculeQuery = ''.obs;
  final RxList<EtudiantPointageModel> etudiants = <EtudiantPointageModel>[].obs;
  final RxList<EtudiantPointageModel> filteredEtudiants =
      <EtudiantPointageModel>[].obs;
  final RxList<String> recentPresents = <String>[].obs;
  final selectedClasse = 'Toutes les classes'.obs;
  final searchByMatricule = true.obs;

  final List<String> classes = [
    'Toutes les classes',
    'L3GLRS',
    'L2CPD',
    'L1CDSD',
    'L2IAGE',
    'L2ETSE',
  ];

  // Getter pour accéder aux informations de l'utilisateur
  String get userEmail => _authController.userEmail;
  String get userToken => _authController.userToken;

  @override
  void onInit() {
    super.onInit();
    if (!_authController.isAuthenticated.value) {
      Get.offNamed('/login');
      return;
    }
    loadEtudiants();
  }

  void loadEtudiants() {
    final List<Map<String, String>> data = [
      {
        'nom': 'Keita',
        'prenom': 'Fatima',
        'matricule': 'DK-2025001',
        'classe': 'L3GLRS'
      },
      {
        'nom': 'NDIAYE',
        'prenom': 'Anna',
        'matricule': 'DK-2025002',
        'classe': 'L2CPD'
      },
      {
        'nom': 'Bah',
        'prenom': 'Mamadou',
        'matricule': 'DK-2025003',
        'classe': 'L3GLRS'
      },
      {
        'nom': 'Keita',
        'prenom': 'Mariem',
        'matricule': 'DK-2025004',
        'classe': 'L2IAGE'
      },
      {
        'nom': 'Ba',
        'prenom': 'Ousmane',
        'matricule': 'DK-2025005',
        'classe': 'L3GLRS'
      },
      {
        'nom': 'Niang',
        'prenom': 'Fatoumata',
        'matricule': 'DK-2025006',
        'classe': 'L2CPD'
      },
      {
        'nom': 'Toure',
        'prenom': 'Ameth',
        'matricule': 'DK-2025007',
        'classe': 'L2ETSE'
      },
    ];

    etudiants.value = data.map((e) {
      var etudiant = EtudiantPointageModel.fromJson(e);
      etudiant.status = 'Absent'; // Par défaut tous les étudiants sont absents
      return etudiant;
    }).toList();
    applyFilters();
  }

  void updateMatricule(String matricule) {
    matriculeQuery.value = matricule;
    applyFilters();
  }

  void updateClasse(String classe) {
    selectedClasse.value = classe;
    applyFilters();
  }

  void applyFilters() {
    var filtered = etudiants;

    // Filtre par matricule
    if (matriculeQuery.isNotEmpty) {
      filtered = filtered
          .where((etudiant) => etudiant.matricule
              .toLowerCase()
              .contains(matriculeQuery.value.toLowerCase()))
          .toList()
          .obs;
    }

    // Filtre par classe
    if (selectedClasse.value != 'Toutes les classes') {
      filtered = filtered
          .where((etudiant) => etudiant.classe == selectedClasse.value)
          .toList()
          .obs;
    }

    // Ne montrer que les 5 derniers étudiants marqués présents
    if (matriculeQuery.isEmpty) {
      filtered = filtered
          .where((etudiant) => recentPresents.contains(etudiant.matricule))
          .take(5)
          .toList()
          .obs;
    }

    filteredEtudiants.value = filtered;
  }

  void markPresent(String matricule) async {
    final index = etudiants.indexWhere((e) => e.matricule == matricule);
    if (index != -1) {
      etudiants[index].status = 'Présent';

      // Ajouter à la liste des présents récents
      if (!recentPresents.contains(matricule)) {
        recentPresents.add(matricule);
        if (recentPresents.length > 5) {
          recentPresents.removeAt(0); // Garder seulement les 5 derniers
        }
      }

      // Sauvegarder automatiquement
      try {
        // TODO: Implémenter la sauvegarde vers l'API
        Get.snackbar(
          'Succès',
          'Présence enregistrée',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Erreur lors de l\'enregistrement',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }

      applyFilters();

      // Réinitialiser la recherche
      matriculeQuery.value = '';
    }
  }

  Future<void> savePointage() async {
    try {
      // TODO: Implémenter la sauvegarde vers l'API
      Get.snackbar(
        'Succès',
        'Pointage enregistré avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF43291B),
        colorText: const Color(0xFFF89620),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'enregistrement du pointage',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF43291B),
        colorText: const Color(0xFFF89620),
      );
    }
  }

  // Exemple de méthode utilisant les données de l'utilisateur
  void fairePointage() {
    print('Pointage pour l\'utilisateur: ${_authController.userEmail}');
    // Implémentez votre logique de pointage ici
  }

  void handlePointage() {
    // TODO: Implémenter la logique de scan QR code
    Get.snackbar(
      'Scan QR Code',
      'Fonctionnalité en cours de développement',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
