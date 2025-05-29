class Absence {
    final String id;
  final String nom;
  final String prenom;
  final String classe;
  final String module;
  final DateTime date;
  final String heure;
  final String status;
  final String justification;
  final String justificatif;

  Absence({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.classe,
    required this.module,
    required this.date,
    required this.heure,
    required this.status,
    required this.justification,
    required this.justificatif,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
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
}
