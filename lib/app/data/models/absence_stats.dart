class AbsenceStats {
  final String absenceCumulee;
  final String absenceSoumise;
  final String retardsCumules;
  final String absenceRestante;
  
  AbsenceStats({
    required this.absenceCumulee,
    required this.absenceSoumise,
    required this.retardsCumules,
    required this.absenceRestante,
  });
  
  // Crée un objet AbsenceStats à partir de JSON
  factory AbsenceStats.fromJson(Map<String, dynamic> json) {
    return AbsenceStats(
      absenceCumulee: json['absenceCumulee'] ?? '0',
      absenceSoumise: json['absenceSoumise'] ?? '0',
      retardsCumules: json['retardsCumules'] ?? '0',
      absenceRestante: json['absenceRestante'] ?? '0',
    );
  }
  
  // Convertit l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'absenceCumulee': absenceCumulee,
      'absenceSoumise': absenceSoumise,
      'retardsCumules': retardsCumules,
      'absenceRestante': absenceRestante,
    };
  }
  
  // Crée un objet AbsenceStats par défaut
  factory AbsenceStats.empty() {
    return AbsenceStats(
      absenceCumulee: '0',
      absenceSoumise: '0',
      retardsCumules: '0',
      absenceRestante: '20',
    );
  }
}