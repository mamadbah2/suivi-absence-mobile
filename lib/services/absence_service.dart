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

  Future<Absence?> getAbsenceDuJour(DateTime date, String matricule) async {
    return null;
  }

  Future<void> toggleAbsence(int idAbsence) async {

  }

  // Les params des justification ne sont pas complet
  Future<void> setJustifationAbsence(String justificatif) async {

  }

}
