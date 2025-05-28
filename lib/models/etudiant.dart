import 'package:suivi_absence_mobile/models/absence.dart';

class Etudiant {
  final String matricule;
  final String classe;
  final List<Absence> listeAbsence;

  Etudiant({
    required this.matricule,
    required this.classe,
    required this.listeAbsence,
  });
}