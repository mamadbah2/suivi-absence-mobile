class EtudiantPointageModel {
  final String nom;
  final String prenom;
  final String matricule;
  final String classe;
  String status;

  EtudiantPointageModel({
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.classe,
    this.status = 'Présent',
  });

  factory EtudiantPointageModel.fromJson(Map<String, dynamic> json) {
    return EtudiantPointageModel(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      matricule: json['matricule'] ?? '',
      classe: json['classe'] ?? '',
      status: json['status'] ?? 'Présent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'matricule': matricule,
      'classe': classe,
      'status': status,
    };
  }
}
