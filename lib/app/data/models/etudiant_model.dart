import 'user_model.dart';

class EtudiantModel {
  final String id;
  final String matricule;
  final String nom;
  final String prenom;
  final String email;
  final String classe;

  EtudiantModel({
    required this.id,
    required this.matricule,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.classe
  });

  // Crée un modèle étudiant à partir des données JSON
  factory EtudiantModel.fromJson(Map<String, dynamic> json) {
    return EtudiantModel(
      id: json['id'] ?? '',
      matricule: json['matricule'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      classe: json['classe'] ?? '',
    );
  }

  // Crée un modèle étudiant à partir d'un UserModel
  factory EtudiantModel.fromUserModel(UserModel user) {
    return EtudiantModel(
      id: user.id,
      matricule: user.matricule ?? 'DK-30352', // Valeur par défaut si manquante
      nom: user.nom,
      prenom: user.prenom,
      email: user.email,
      classe: 'Licence 2 CLRS', // Valeur par défaut
    );
  }

  // Crée un modèle étudiant vide
  factory EtudiantModel.empty() {
    return EtudiantModel(
      id: '',
      matricule: 'DK-30352',
      nom: 'BA',
      prenom: 'Ousmane',
      email: 'test@test.com',
      classe: 'Licence 2 CLRS',
    );
  }

  // Convertit l'objet en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricule': matricule,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'classe': classe,
    };
  }
}