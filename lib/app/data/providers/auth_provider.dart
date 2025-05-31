import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    // URL du backend
    httpClient.baseUrl = '';
    super.onInit();
  }

  Future<Response> login(String email, String password) async {
    print('AuthProvider: Tentative de connexion');
  
    await Future.delayed(const Duration(seconds: 2));
    //Pour faire une petite simulation de connexion
    //Dans les normes le back doit me retourner l'entite user
    if (email == 'test@test.com' && password == 'password') {
      return Response(
        body: {
          'id': '1',
          'nom': 'Keita',
          'prenom': 'John',
          'email': email,
          'password': password,
          'role': 'Vigile',
        },
        statusCode: 200,
      );
    }
    
    return Response(
      body: {'message': 'Invalid credentials'},
      statusCode: 401,
    );
  }
} 