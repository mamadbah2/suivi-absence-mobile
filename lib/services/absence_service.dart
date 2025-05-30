import 'package:suivi_absence_mobile/models/absence.dart';

class AbsenceService {
  Future<List<Absence>> getAllAbsence() async {
    return [];
  }

  Future<List<Absence>> getAllAbsenceParUser(String id) async {
    return [];
  }

  Future<List<Absence>> getAllAbsenceDuJour(DateTime date) async {
    return [];
  }

  Future<List<Absence>> getAbsencesDuJourParEtudiant(
    DateTime date,
    String matricule,
  ) async {
    // Mock data pour les tests
    final mockAbsences = [
      Absence(
        id: "1",
        nom: "Dupont",
        prenom: "Jean",
        classe: "L2 Info",
        module: "Programmation Mobile",
        date: DateTime.now(),
        heure: "08:00 - 10:00",
        status: "present",
        justification: "",
        justificatif: "",
      ),
      Absence(
        id: "2",
        nom: "Dupont",
        prenom: "Jean",
        classe: "L2 Info",
        module: "Base de données",
        date: DateTime.now(),
        heure: "10:30 - 12:30",
        status: "absent",
        justification: "Maladie",
        justificatif: "certificat_medical.pdf",
      ),
      Absence(
        id: "3",
        nom: "Dupont",
        prenom: "Jean",
        classe: "L2 Info",
        module: "Réseaux",
        date: DateTime.now(),
        heure: "14:00 - 16:00",
        status: "present",
        justification: "",
        justificatif: "",
      ),
    ];

    // Retourner une absence aléatoire pour simuler différents cas
    return mockAbsences;
  }

  Future<void> toggleAbsence(int idAbsence) async {
    // Simuler un délai réseau
    await Future.delayed(Duration(milliseconds: 500));
  }

  // Les params des justification ne sont pas complet
  Future<void> setJustifationAbsence(String justificatif) async {
    // Simuler un délai réseau
    await Future.delayed(Duration(milliseconds: 500));
  }
}
