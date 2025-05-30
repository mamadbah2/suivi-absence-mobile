import 'package:get/get.dart';
import '../services/etudiant_service.dart';

class EtudiantController extends GetxController {
  final EtudiantService _service = Get.find<EtudiantService>();

  // État de l'étudiant
  final studentName = ''.obs;
  final photoUrl = ''.obs;
  final filiere = ''.obs;
  final matricule = ''.obs;
  final email = ''.obs;
  final telephone = ''.obs;
  final annee = ''.obs;
  final semestre = ''.obs;

  // État des statistiques
  final stats = <Map<String, String>>[].obs;

  // État des cours
  final courses = <Map<String, dynamic>>[].obs;

  // État de l'historique
  final absenceHistory = <Map<String, dynamic>>[].obs;

  // États de chargement
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Charger les informations de l'étudiant
      final studentInfo = await _service.getStudentInfo();
      studentName.value = '${studentInfo['prenom']} ${studentInfo['nom']}';
      photoUrl.value = studentInfo['photoUrl'];
      filiere.value = studentInfo['filiere'];
      matricule.value = studentInfo['matricule'];
      email.value = studentInfo['email'];
      telephone.value = studentInfo['telephone'];
      annee.value = studentInfo['annee'];
      semestre.value = studentInfo['semestre'];

      // Charger les statistiques
      final absenceStats = await _service.getAbsenceStats();
      stats.assignAll(absenceStats);

      // Charger les cours du jour
      final todayCourses = await _service.getTodayCourses();
      courses.assignAll(todayCourses);

      // Charger l'historique des absences
      final history = await _service.getAbsenceHistory();
      absenceHistory.assignAll(history);
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des données';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleLogout() async {
    try {
      isLoading.value = true;
      await _service.logout();
      // Rediriger vers la page de connexion
      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = 'Erreur lors de la déconnexion';
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour rafraîchir les données
  Future<void> refreshData() async {
    await loadStudentData();
  }

  // Méthode pour obtenir le nombre total d'absences
  int get totalAbsences {
    return courses
        .where((course) => course['type'].toString().contains('Absence'))
        .length;
  }

  // Méthode pour obtenir le nombre total de retards
  int get totalRetards {
    return courses
        .where((course) => course['type'].toString().contains('Retard'))
        .length;
  }
}
