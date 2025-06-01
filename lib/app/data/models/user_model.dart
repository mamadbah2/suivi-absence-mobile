class UserModel {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String role;
  final String? matricule; // Ajout du matricule, nullable car seuls les étudiants l'ont

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.role,
    this.matricule, // Optionnel
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      matricule: json['matricule'], // Peut être null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'role': role,
      'matricule': matricule,
    };
  }
}