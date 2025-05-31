class EtudiantModel {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String classe;
  final List<String> absences;

  EtudiantModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.classe,
    this.absences = const [],
  });

  factory EtudiantModel.fromJson(Map<String, dynamic> json) {
    return EtudiantModel(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      classe: json['classe'] ?? '',
      absences: List<String>.from(json['absences'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'classe': classe,
      'absences': absences,
    };
  }
}
