import 'package:suivi_absence_mobile/models/etudiant.dart';

class Classe {
  final String id;
  final String filiere;
  final String niveau;
  final List<Etudiant> listeEtudiant;

  Classe({
    required this.id,
    required this.filiere,
    required this.niveau,
    required this.listeEtudiant,
  });
}
