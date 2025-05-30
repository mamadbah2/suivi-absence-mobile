import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    // URL du backend
    httpClient.baseUrl = '';
    super.onInit();
  }

  Future<UserModel> login(String email, String password) async {
    print('AuthProvider: Tentative de connexion');

    await Future.delayed(const Duration(seconds: 1));

    // Compte professeur/admin
    if (email == 'test@test.com' && password == 'password') {
      final userData = {
        'id': '1',
        'nom': 'Doe',
        'prenom': 'Fatima',
        'email': email,
        'role': 'enseignant', // Role modifié pour clarté
      };
      return UserModel.fromJson(userData);
    }
    
    // Compte étudiant
    else if (email == 'etudiant@test.com' && password == 'password') {
      final userData = {
        'id': '2',
        'nom': 'Diallo',
        'prenom': 'Mamadou',
        'email': email,
        'role': 'etudiant',
        'matricule': '2021001', // Ajout du matricule pour les étudiants
      };
      return UserModel.fromJson(userData);
    }

    throw Exception('Identifiants invalides');
  }
}