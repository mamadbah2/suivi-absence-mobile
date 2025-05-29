import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'package:get/get.dart';

class AuthRepository {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  //C'est le repos qui communique avec le provider pour faire la connexion
  //Je peux faire d'autres fonctions ici si je veux


  //Ma fonction pour faire la connexion
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _authProvider.login(email, password);
      if (response.status.isOk) {
        return UserModel.fromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
} 