/*class Etudiant {
  final String nom;
  final String prenom;
  final String classe;
  final String matricule;
  final String email;

  Etudiant({
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.matricule,
    required this.email,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      nom: json['nom'],
      prenom: json['prenom'],
      classe: json['classe'],
      matricule: json['matricule'],
      email: json['email'],
    );
  }
}*/

class Module {
  final String id;
  final String nom;
  final String nomDuProf;
  final String classe;

  Module({
    required this.id,
    required this.nom,
    required this.nomDuProf,
    required this.classe,
  });
}

