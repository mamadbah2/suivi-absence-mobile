class Absence {
  final String id;
  final DateTime heure;
  final DateTime date;
  final String justification;
  final String nomModule;
  final String matricule;
  final String statut;

  Absence({
    required this.id,
    required this.heure,
    required this.date,
    required this.justification,
    required this.nomModule,
    required this.matricule,
    required this.statut,
  });
}
