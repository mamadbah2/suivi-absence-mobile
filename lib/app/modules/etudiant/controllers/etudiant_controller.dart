import 'package:get/get.dart';
import '../../../data/models/absence.dart';
import '../../../data/controllers/auth_controller.dart';

class EtudiantController extends GetxController {
  final RxList<Absence> mesAbsences = <Absence>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final AuthController _authController = Get.find<AuthController>();

  // Stats des absences
  final RxInt absenceCumulee = 31.obs; // en heures
  final RxInt absenceSoumise = 2.obs;
  final RxInt retardsCumules = 8.obs;
  final RxInt absenceRestante = 41.obs;

  // Infos étudiant
  final RxString nom = ''.obs;
  final RxString prenom = ''.obs;
  final RxString classe = 'Licence 2 CLRS'.obs;
  final RxString matricule = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    chargerAbsences();
    initialiserInfosEtudiant();
  }

  void initialiserInfosEtudiant() {
    // Récupérer les informations de l'utilisateur connecté
    if (_authController.currentUser.value != null) {
      nom.value = _authController.currentUser.value!.nom;
      prenom.value = _authController.currentUser.value!.prenom;
      matricule.value = _authController.currentUser.value?.matricule ?? 'DK-30352';
    } else {
      // Valeurs par défaut si aucun utilisateur n'est connecté
      nom.value = 'Diallo';
      prenom.value = 'Mamadou';
      matricule.value = 'DK-30352';
    }
  }
  
  void chargerAbsences() {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Données simulées pour les absences
      final today = DateTime.now();
      
      mesAbsences.assignAll([
        // Absences pour aujourd'hui
        Absence(
          id: '1',
          matricule: matricule.value,
          nom: nom.value,
          prenom: prenom.value,
          classe: classe.value,
          module: 'Développement Flutter',
          date: today,
          heure: '8h',
          status: 'absent',
          duree: '8h-12h',
          type: 'Retard',
        ),
        Absence(
          id: '2',
          matricule: matricule.value,
          nom: nom.value,
          prenom: prenom.value,
          classe: classe.value,
          module: 'Gestion de Projet',
          date: today,
          heure: '8h',
          status: 'absent',
          duree: '8h-12h',
          type: 'Absence',
        ),
        Absence(
          id: '3',
          matricule: matricule.value,
          nom: nom.value,
          prenom: prenom.value,
          classe: classe.value,
          module: 'Base de données',
          date: today,
          heure: '14h',
          status: 'present',
          duree: '14h-18h',
          type: 'Absence',
          justification: 'Justifiée',
        ),
        
        // Absences plus anciennes
        Absence(
          id: '4',
          matricule: matricule.value,
          nom: nom.value,
          prenom: prenom.value,
          classe: classe.value,
          module: 'Java',
          date: today.subtract(const Duration(days: 2)),
          heure: '10h',
          status: 'absent',
          duree: '10h-12h',
          type: 'Absence',
        ),
        Absence(
          id: '5',
          matricule: matricule.value,
          nom: nom.value,
          prenom: prenom.value,
          classe: classe.value,
          module: 'Analyse des Besoins',
          date: today.subtract(const Duration(days: 4)),
          heure: '14h',
          status: 'present',
          duree: '14h-16h',
          type: 'Retard',
          justification: 'Justifiée',
        ),
      ]);
      
    } catch (e) {
      error.value = "Erreur lors du chargement des absences: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Méthodes pour la justification des absences
  Future<bool> envoyerJustification(String absenceId, String motif, String commentaire) async {
    try {
      // Simuler un appel API pour envoyer la justification
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Trouver et mettre à jour l'absence dans la liste
      final index = mesAbsences.indexWhere((absence) => absence.id == absenceId);
      if (index != -1) {
        final absence = mesAbsences[index];
        final updatedAbsence = Absence(
          id: absence.id,
          matricule: absence.matricule,
          nom: absence.nom,
          prenom: absence.prenom,
          classe: absence.classe,
          module: absence.module,
          date: absence.date,
          heure: absence.heure,
          status: absence.status,
          duree: absence.duree,
          type: absence.type,
          justification: 'En attente',
        );
        
        mesAbsences[index] = updatedAbsence;
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de l\'envoi de la justification: $e');
      return false;
    }
  }

  // Obtenir les absences pour aujourd'hui uniquement  
  List<Absence> getAbsencesForToday() {
    final today = DateTime.now();
    return mesAbsences.where((absence) => 
      absence.date.year == today.year && 
      absence.date.month == today.month && 
      absence.date.day == today.day
    ).toList();
  }
}