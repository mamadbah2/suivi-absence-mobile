class Absence {
  final String id;
  final String matricule;
  final String nom;
  final String prenom;
  final String classe;
  final String module;
  final DateTime date;
  final String heure;
  final String status; // "absent" ou "présent"
  final String? justification; // ex: "Justifiée", "En attente", null
  final String? justificatif; // URL ou chemin vers le document justificatif
  final String? duree; // ex: "8h-12h"
  final String? type; // ex: "Absence" ou "Retard"
  final String? professeur; // ex: "Prof. Dupont"
  final String? salle; // ex: "Bâtiment A - Salle 203"

  Absence({
    required this.id,
    required this.matricule,
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.module,
    required this.date,
    required this.heure,
    required this.status,
    this.justification,
    this.justificatif,
    this.duree,
    this.type,
    this.professeur,
    this.salle,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      matricule: json['matricule'],
      nom: json['nom'],
      prenom: json['prenom'],
      classe: json['classe'],
      module: json['module'],
      date: DateTime.parse(json['date']),
      heure: json['heure'],
      status: json['status'],
      justification: json['justification'],
      justificatif: json['justificatif'],
      duree: json['duree'],
      type: json['type'],
      professeur: json['professeur'],
      salle: json['salle'],
    );
  }

  Map<String, dynamic> toJson() {
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
      'duree': duree,
      'type': type,
      'professeur': professeur,
      'salle': salle,
    };
  }

  Absence copyWith({
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
    String? duree,
    String? type,
    String? professeur,
    String? salle,
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
      duree: duree ?? this.duree,
      type: type ?? this.type,
      professeur: professeur ?? this.professeur,
      salle: salle ?? this.salle,
    );
  }
}
