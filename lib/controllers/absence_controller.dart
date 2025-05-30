import 'package:get/get.dart';
import 'package:suivi_absence_mobile/models/absence.dart';

class AbsenceController extends GetxController {
  final _isLoading = false.obs;
  final _error = RxnString();
  final _absencesDuJour = <Absence>[].obs;
  final _historiqueAbsences = <Absence>[].obs;
  String? _currentMatricule;

  List<Absence> get absencesDuJour => _absencesDuJour;
  List<Absence> get historiqueAbsences => _historiqueAbsences;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    // Initialiser avec des données statiques
    _absencesDuJour.value = [
      Absence(
        id: "1",
        nom: "John",
        prenom: "Doe",
        classe: "L1",
        module: "Mathématiques",
        date: DateTime.now(),
        heure: "08:00-10:00",
        status: "Non justifié",
        justification: "",
        justificatif: "",
      ),
      Absence(
        id: "2",
        nom: "John",
        prenom: "Doe",
        classe: "L1",
        module: "Physique",
        date: DateTime.now(),
        heure: "10:30-12:30",
        status: "Justifié",
        justification: "Certificat médical",
        justificatif: "certificat.pdf",
      ),
    ];
  }

  Future<void> getAbsencesDuJour(String matricule) async {
    try {
      _isLoading.value = true;
      _error.value = null;
      _currentMatricule = matricule;

      // Utiliser les données statiques au lieu d'appeler le service
      _absencesDuJour.value = [
        Absence(
          id: "1",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Mathématiques",
          date: DateTime.now(),
          heure: "08:00-10:00",
          status: "Non justifié",
          justification: "",
          justificatif: "",
        ),
        Absence(
          id: "2",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Physique",
          date: DateTime.now(),
          heure: "10:30-12:30",
          status: "Justifié",
          justification: "Certificat médical",
          justificatif: "certificat.pdf",
        ),
      ];
    } catch (e) {
      _error.value =
          "Erreur lors de la récupération des absences: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getHistoriqueAbsences(String matricule) async {
    try {
      _isLoading.value = true;
      _error.value = null;
      _currentMatricule = matricule;

      // Simuler la récupération de l'historique des absences
      _historiqueAbsences.value = [
        Absence(
          id: "1",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Mathématiques",
          date: DateTime.now().subtract(Duration(days: 1)),
          heure: "08:00-10:00",
          status: "Non justifié",
          justification: "",
          justificatif: "",
        ),
        Absence(
          id: "2",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Physique",
          date: DateTime.now().subtract(Duration(days: 2)),
          heure: "10:30-12:30",
          status: "Justifié",
          justification: "Certificat médical",
          justificatif: "certificat.pdf",
        ),
        Absence(
          id: "3",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Informatique",
          date: DateTime.now().subtract(Duration(days: 3)),
          heure: "14:00-16:00",
          status: "Non justifié",
          justification: "",
          justificatif: "",
        ),
      ];
    } catch (e) {
      _error.value =
          "Erreur lors de la récupération de l'historique des absences: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> toggleAbsence(int idAbsence) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      // Simuler la modification d'une absence
      final index = _absencesDuJour.indexWhere(
        (a) => a.id == idAbsence.toString(),
      );
      if (index != -1) {
        final absence = _absencesDuJour[index];
        final updatedAbsence = Absence(
          id: absence.id,
          nom: absence.nom,
          prenom: absence.prenom,
          classe: absence.classe,
          module: absence.module,
          date: absence.date,
          heure: absence.heure,
          status: absence.status == "Justifié" ? "Non justifié" : "Justifié",
          justification: absence.justification,
          justificatif: absence.justificatif,
        );
        _absencesDuJour[index] = updatedAbsence;
      }
    } catch (e) {
      _error.value =
          "Erreur lors de la modification de l'absence: ${e.toString()}";
    } finally {
      _isLoading.value = false;
    }
  }
}
