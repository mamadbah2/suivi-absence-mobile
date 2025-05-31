class AbsenceModel {
  final String id;
  final String cours;
  final String type;
  final String date;
  final String heureDebut;
  final String heureFin;
  final String professeur;
  final String salle;
  final bool isRetard;
  final String? status;
  final String? justification;

  AbsenceModel({
    required this.id,
    required this.cours,
    required this.type,
    required this.date,
    required this.heureDebut,
    required this.heureFin,
    required this.professeur,
    required this.salle,
    required this.isRetard,
    this.status,
    this.justification,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    return AbsenceModel(
      id: json['id'] ?? '',
      cours: json['cours'] ?? '',
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      heureDebut: json['heureDebut'] ?? '',
      heureFin: json['heureFin'] ?? '',
      professeur: json['professeur'] ?? '',
      salle: json['salle'] ?? '',
      isRetard: json['isRetard'] ?? false,
      status: json['status'],
      justification: json['justification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cours': cours,
      'type': type,
      'date': date,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'professeur': professeur,
      'salle': salle,
      'isRetard': isRetard,
      'status': status,
      'justification': justification,
    };
  }
}
