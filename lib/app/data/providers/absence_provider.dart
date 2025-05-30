import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/app/data/models/absence.dart';

class AbsenceProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Absence> _absencesDuJour = [];
  List<Absence> _historiqueAbsences = [];

  List<Absence> get absencesDuJour => _absencesDuJour;
  List<Absence> get historiqueAbsences => _historiqueAbsences;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AbsenceProvider() {
    _absencesDuJour = [
      Absence(
        id: "1",
        matricule: "2021001",
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
        matricule: "2021002",
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
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));
      _absencesDuJour = [
        Absence(
          matricule: "2021001",
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
          matricule: "2021002",
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
      _error = "Erreur lors de la récupération des absences: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHistoriqueAbsences(String matricule) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));
      _historiqueAbsences = [
        Absence(
          id: "1",
          matricule: "2021001",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Mathématiques",
          date: DateTime.now().subtract(const Duration(days: 1)),
          heure: "08:00-10:00",
          status: "Non justifié",
          justification: "",
          justificatif: "",
        ),
        Absence(
          id: "2",
          matricule: "2021002",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Physique",
          date: DateTime.now().subtract(const Duration(days: 2)),
          heure: "10:30-12:30",
          status: "Justifié",
          justification: "Certificat médical",
          justificatif: "certificat.pdf",
        ),
        Absence(
          id: "3",
          matricule: "2021003",
          nom: "John",
          prenom: "Doe",
          classe: "L1",
          module: "Informatique",
          date: DateTime.now().subtract(const Duration(days: 3)),
          heure: "14:00-16:00",
          status: "Non justifié",
          justification: "",
          justificatif: "",
        ),
      ];
    } catch (e) {
      _error = "Erreur lors de la récupération de l'historique des absences: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAbsence(int idAbsence) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _absencesDuJour.indexWhere(
        (a) => a.id == idAbsence.toString(),
      );
      if (index != -1) {
        final absence = _absencesDuJour[index];
        final updatedAbsence = Absence(
          id: absence.id,
          matricule: absence.matricule,
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
      _error = "Erreur lors de la modification de l'absence: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
