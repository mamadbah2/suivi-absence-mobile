class Absence {
  final String id;
  final String matricule; // Added matricule
  final String nom;
  final String prenom;
  final String classe;
  final String module;
  final DateTime date;
  final String heure;
  final String status; // This will be used for "absent" or "présent"
  final String? justification; // Made nullable
  final String? justificatif; // Made nullable

  Absence({
    required this.id,
    required this.matricule, // Added matricule
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.module,
    required this.date,
    required this.heure,
    required this.status,
    this.justification, // Updated
    this.justificatif, // Updated
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      matricule: json['matricule'], // Added matricule
      nom: json['nom'],
      prenom: json['prenom'],
      classe: json['classe'],
      module: json['module'],
      date: DateTime.parse(json['date']),
      heure: json['heure'],
      status: json['status'],
      justification: json['justification'],
      justificatif: json['justificatif'],
    );
  }

  Map<String, dynamic> toJson() { // Added toJson for completeness
    return {
      'id': id,
      'matricule': matricule,
      'nom': nom,
      'prenom': prenom,
      'classe': classe,
      'module': module,
      'date': date.toIso8601String(),
      'heure': heure,
      'status': status,
      'justification': justification,
      'justificatif': justificatif,
    };
  }

  Absence copyWith({ // Added copyWith
    String? id,
    String? matricule,
    String? nom,
    String? prenom,
    String? classe,
    String? module,
    DateTime? date,
    String? heure,
    String? status,
    String? justification,
    String? justificatif,
  }) {
    return Absence(
      id: id ?? this.id,
      matricule: matricule ?? this.matricule,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      classe: classe ?? this.classe,
      module: module ?? this.module,
      date: date ?? this.date,
      heure: heure ?? this.heure,
      status: status ?? this.status,
      justification: justification ?? this.justification,
      justificatif: justificatif ?? this.justificatif,
    );
  }
}
