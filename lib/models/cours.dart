
import 'package:suivi_absence_mobile/models/absence.dart';

class Cours {
  final String id;
  final DateTime heureDebut;
  final DateTime heureFin;
  final DateTime date;
  final String classe;
  final String module;
  final List<Absence> listeDAbsences;

  Cours({
    required this.id,
    required this.heureDebut,
    required this.heureFin,
    required this.date,
    required this.classe,
    required this.module,
    required this.listeDAbsences,
  });
}