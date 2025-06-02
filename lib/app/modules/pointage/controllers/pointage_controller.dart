import 'package:get/get.dart';
import '../../../data/models/absence.dart';
import '../../../data/providers/pointage_provider.dart';

class PointageController extends GetxController {
  late final PointageProvider _pointageProvider;
  final RxList<Absence> absences = <Absence>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxBool isInitialized = false.obs;

  // Exemple: ID du cours actuel, à remplacer par une valeur dynamique
  final String _idCoursActuel = "FLUTTER_L3_2024"; 

  @override
  void onInit() {
    super.onInit();
    _initializeProvider();
  }

  void _initializeProvider() {
    try {
      // Initialiser le provider en toute sécurité
      _pointageProvider = Get.find<PointageProvider>();
      isInitialized.value = true;
      // Récupérer les données seulement après avoir confirmé que le provider est disponible
      fetchListeAbsences();
    } catch (e) {
      print("Erreur lors de l'initialisation du PointageProvider: $e");
      error.value = "Erreur d'initialisation: $e";
      isLoading.value = false;
      // Retry initialization after a short delay, useful when the app just started
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isRegistered<PointageProvider>()) {
          _initializeProvider();
        }
      });
    }
  }

  Future<void> fetchListeAbsences() async {
    if (!isInitialized.value) {
      error.value = "Le provider n'est pas encore initialisé";
      return;
    }
    
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _pointageProvider.getListeAbsencesPourCours();
      absences.assignAll(result);
    } catch (e) {
      error.value = "Erreur lors de la récupération de la liste des étudiants: $e";
      // Afficher un message seulement si c'est un appel explicite, pas au démarrage
      if (!isLoading.value) {
        Get.snackbar(
          "Erreur", 
          "Impossible de charger la liste des étudiants.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Version locale - recherche dans la liste des absences déjà chargées
  Absence? getAbsenceByMatricule(String matricule) {
    try {
      return absences.firstWhere((a) => a.matricule == matricule);
    } catch (_) {
      return null;
    }
  }
  
  // Recherche d'un étudiant par matricule auprès du backend
  Future<Absence?> rechercherEtudiantParMatricule(String matricule) async {
    if (!isInitialized.value) {
      error.value = "Le provider n'est pas encore initialisé";
      return null;
    }
    
    try {
      isLoading.value = true;
      error.value = '';
      
      // Appel à la méthode de l'API
      final absence = await _pointageProvider.rechercherEtudiantParMatricule(matricule);
      
      // Si l'étudiant est trouvé et n'est pas déjà dans la liste, l'ajouter
      if (absence != null) {
        final existingIndex = absences.indexWhere((a) => a.matricule == matricule);
        if (existingIndex == -1) {
          absences.add(absence);
        } else {
          // Si l'étudiant est déjà dans la liste, mettre à jour ses informations
          absences[existingIndex] = absence;
        }
      }
      
      return absence;
    } catch (e) {
      error.value = "Erreur lors de la recherche de l'étudiant: $e";
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> marquerPresent(String matricule) async {
    if (!isInitialized.value) {
      Get.snackbar(
        "Erreur",
        "L'application n'est pas encore complètement initialisée",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      final index = absences.indexWhere((a) => a.matricule == matricule);
      if (index != -1) {
        // Mise à jour optimiste: mettre à jour l'UI immédiatement
        absences[index] = absences[index].copyWith(status: 'present');
        
        // Appel au backend pour mettre à jour le statut
        final updatedAbsence = await _pointageProvider.marquerEtudiantPresent(matricule, _idCoursActuel);
        if (updatedAbsence != null) {
          // Mettre à jour avec les données du backend si nécessaire
          absences[index] = updatedAbsence;
        }
      } else {
        // Si l'étudiant n'est pas dans la liste locale, essayer de le rechercher d'abord
        final absence = await rechercherEtudiantParMatricule(matricule);
        if (absence != null) {
          // Puis le marquer présent
          await _pointageProvider.marquerEtudiantPresent(matricule, _idCoursActuel);
          // Mettre à jour son statut dans la liste locale
          final newIndex = absences.indexWhere((a) => a.matricule == matricule);
          if (newIndex != -1) {
            absences[newIndex] = absences[newIndex].copyWith(status: 'present');
          }
        }
      }
    } catch (e) {
      // En cas d'erreur, restaurer le statut "absent" ou afficher un message d'erreur
      final index = absences.indexWhere((a) => a.matricule == matricule);
      if (index != -1) {
        absences[index] = absences[index].copyWith(status: 'absent');
      }
      Get.snackbar(
        "Erreur", 
        "Impossible de marquer l'étudiant comme présent: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}