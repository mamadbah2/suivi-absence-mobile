import 'package:suivi_absence_mobile/models/absence.dart';
import 'package:suivi_absence_mobile/models/user.dart';

class Etudiant extends User {
  final String matricule;
  final String classe;
  final List<Absence> listeAbsence;

  Etudiant({
    required this.matricule,
    required this.classe,
    required this.listeAbsence, required super.id, required super.nom, required super.prenom, required super.email, required super.password, required super.role,
  });
}