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

    if (email == 'test@test.com' && password == 'password') {
      final userData = {
        'id': '1',
        'nom': 'Doe',
        'prenom': 'Fatima',
        'email': email,
        'role': 'admin',
      };
      return UserModel.fromJson(userData);
    }

    throw Exception('Identifiants invalides');
  }
}