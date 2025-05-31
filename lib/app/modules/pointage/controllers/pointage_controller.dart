import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../data/models/etudiant_pointage_model.dart';
import 'package:flutter/material.dart';

class PointageController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final searchQuery = ''.obs;
  final RxList<EtudiantPointageModel> etudiants = <EtudiantPointageModel>[].obs;
  final RxList<EtudiantPointageModel> filteredEtudiants =
      <EtudiantPointageModel>[].obs;
  final selectedFilter = 'Aujourd\'hui'.obs;
  final selectedClasse = 'Toutes les classes'.obs;

  final List<String> classes = [
    'Toutes les classes',
    'L3 Informatique',
    'L2 Informatique',
    'L1 Informatique',
    'M1 Informatique',
    'M2 Informatique',
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
    // Simuler le chargement des données
    final List<Map<String, String>> data = [
      {
        'nom': 'DIOP',
        'prenom': 'Aminata',
        'matricule': 'MAT2023001',
        'classe': 'L3 Informatique'
      },
      {
        'nom': 'NDIAYE',
        'prenom': 'Moussa',
        'matricule': 'MAT2023002',
        'classe': 'L2 Informatique'
      },
      {
        'nom': 'SOW',
        'prenom': 'Fatou',
        'matricule': 'MAT2023003',
        'classe': 'L3 Informatique'
      },
      {
        'nom': 'BA',
        'prenom': 'Ibrahima',
        'matricule': 'MAT2023004',
        'classe': 'M1 Informatique'
      },
      {
        'nom': 'GUEYE',
        'prenom': 'Aissatou',
        'matricule': 'MAT2023005',
        'classe': 'L3 Informatique'
      },
      {
        'nom': 'FALL',
        'prenom': 'Omar',
        'matricule': 'MAT2023006',
        'classe': 'L2 Informatique'
      },
      {
        'nom': 'SARR',
        'prenom': 'Marie',
        'matricule': 'MAT2023007',
        'classe': 'M2 Informatique'
      },
      {
        'nom': 'DIALLO',
        'prenom': 'Abdou',
        'matricule': 'MAT2023008',
        'classe': 'L1 Informatique'
      },
    ];

    etudiants.value =
        data.map((e) => EtudiantPointageModel.fromJson(e)).toList();
    applyFilters();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    applyFilters();
  }

  void updateClasse(String classe) {
    selectedClasse.value = classe;
    applyFilters();
  }

  void applyFilters() {
    var filtered = etudiants;

    // Filtre par recherche
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((etudiant) {
            final searchLower = searchQuery.value.toLowerCase();
            return etudiant.nom.toLowerCase().contains(searchLower) ||
                etudiant.prenom.toLowerCase().contains(searchLower) ||
                etudiant.matricule.toLowerCase().contains(searchLower);
          })
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

    // Filtre par période
    // Note: À implémenter selon les besoins (aujourd'hui/cette semaine)

    filteredEtudiants.value = filtered;
  }

  void updateEtudiantStatus(String matricule, String status) {
    final index = etudiants.indexWhere((e) => e.matricule == matricule);
    if (index != -1) {
      etudiants[index].status = status;
      applyFilters();
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
