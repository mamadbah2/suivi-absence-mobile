import 'dart:convert';
import 'dart:io' show HttpClient, HttpOverrides, SecurityContext, X509Certificate;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthProvider {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String JWT_TOKEN_KEY = 'jwt_token';
  static const String USER_DATA_KEY = 'user_data';
  
  // URL du backend - utilise localhost directement comme demandé
  final String apiBaseUrl = 'http://localhost:8081/app';
  
  // Constructeur
  AuthProvider() {
    // Configuration SSL pour développement
    try {
      if (!kIsWeb) {
        HttpOverrides.global = MyHttpOverrides();
      }
    } catch (e) {
      print('Impossible de configurer HttpOverrides: $e');
    }
  }

  // Méthode pour décoder un token JWT et extraire les données utilisateur
  Map<String, dynamic> decodeJwtToken(String token) {
    try {
      // Diviser le token en ses trois parties
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Format de token JWT invalide');
        return {};
      }

      // Décoder la partie payload (deuxième partie)
      String normalizedPayload = base64Url.normalize(parts[1]);
      String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      Map<String, dynamic> payload = jsonDecode(decodedPayload);
      
      print('Token décodé: $payload');
      return payload;
    } catch (e) {
      print('Erreur lors du décodage du token: $e');
      return {};
    }
  }

  // Méthode de connexion
  Future<UserModel> login(String email, String password) async {
    try {
      print('Tentative de connexion avec: $email');
      final url = '$apiBaseUrl/auth/login';
      
      // Préparer les données de la requête
      final body = jsonEncode({
        'email': email,
        'password': password,
      });
      
      // Headers essentiels
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      // Effectuer la requête POST
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 15));
      
      print('Réponse HTTP status: ${response.statusCode}');
      
      // Traiter la réponse
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Afficher les données complètes pour le débogage
        print('=== DONNÉES UTILISATEUR REÇUES DU BACKEND ===');
        print('Données complètes: $data');
        
        // Stocker le token JWT
        if (data['token'] != null) {
          final token = data['token'];
          await _storage.write(key: JWT_TOKEN_KEY, value: token);
          
          // Extraire les informations utilisateur du token
          final userDataFromToken = decodeJwtToken(token);
          print('Données extraites du token JWT: $userDataFromToken');
          
          // Utiliser les données du token pour créer l'utilisateur
          final user = UserModel.fromJson(userDataFromToken);
          
          // Stocker les données utilisateur pour utilisation hors ligne
          await _storage.write(key: USER_DATA_KEY, value: jsonEncode(user.toJson()));
          
          print('Rôle extrait du token: ${user.role}');
          return user;
        } else {
          throw Exception('Token manquant dans la réponse');
        }
      } else {
        // Gérer l'erreur
        String errorMessage = 'Erreur de connexion (${response.statusCode})';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {}
        
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception lors du décodage du token: $e');
      
      // Mode de secours avec comptes test si besoin
      if (email == 'test@test.com' && password == 'password') {
        return _createTestUser(true);
      } else if (email == 'etudiant@test.com' && password == 'password') {
        return _createTestUser(false);
      }
      
      // Rethrow pour gestion d'erreur par l'appelant
      throw Exception('Erreur de connexion: $e');
    }
  }
  
  // Crée un utilisateur test en cas de besoin
  Future<UserModel> _createTestUser(bool isTeacher) async {
    final userData = {
      'id': isTeacher ? '1' : '2',
      'nom': isTeacher ? 'VIGILE' : 'Étudiant',
      'prenom': 'Test',
      'email': isTeacher ? 'test@test.com' : 'etudiant@test.com',
      'role': isTeacher ? 'VIGILE' : 'etudiant',
      if (!isTeacher) 'matricule': 'ET12345',
    };
    
    final user = UserModel.fromJson(userData);
    await _storage.write(key: USER_DATA_KEY, value: jsonEncode(user.toJson()));
    return user;
  }

  // Méthode pour vérifier la validité du token
  Future<bool> validateToken() async {
    try {
      final token = await _storage.read(key: JWT_TOKEN_KEY);
      if (token == null) return false;

      // Extraire à nouveau les données du token pour s'assurer qu'elles sont à jour
      final userDataFromToken = decodeJwtToken(token);
      if (userDataFromToken.isNotEmpty) {
        // Mettre à jour les données utilisateur stockées
        final user = UserModel.fromJson(userDataFromToken);
        await _storage.write(key: USER_DATA_KEY, value: jsonEncode(user.toJson()));
      }

      final client = http.Client();
      try {
        final response = await client.get(
          Uri.parse('$apiBaseUrl/auth/validate-token'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        return response.statusCode == 200;
      } catch (e) {
        print('Erreur lors de la validation du token: $e');
        return false;
      } finally {
        client.close();
      }
    } catch (_) {
      return false;
    }
  }

  // Méthode pour récupérer les données utilisateur à partir du token stocké
  Future<UserModel?> getUserFromToken() async {
    try {
      final token = await _storage.read(key: JWT_TOKEN_KEY);
      if (token == null) return null;
      
      final userDataFromToken = decodeJwtToken(token);
      if (userDataFromToken.isNotEmpty) {
        return UserModel.fromJson(userDataFromToken);
      }
      return null;
    } catch (e) {
      print('Erreur lors de l\'extraction des données du token: $e');
      return null;
    }
  }

  // Méthodes essentielles pour l'authentification
  Future<UserModel?> getUserFromStorage() async {
    // D'abord essayer d'obtenir les données à partir du token (plus fiable)
    final userFromToken = await getUserFromToken();
    if (userFromToken != null) {
      return userFromToken;
    }
    
    // Fallback sur les données stockées
    try {
      final userData = await _storage.read(key: USER_DATA_KEY);
      if (userData != null) {
        return UserModel.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  // Récupère le token JWT stocké
  Future<String?> getJwtToken() async {
    try {
      return await _storage.read(key: JWT_TOKEN_KEY);
    } catch (e) {
      print('Erreur lors de la récupération du token JWT: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: JWT_TOKEN_KEY);
    await _storage.delete(key: USER_DATA_KEY);
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: JWT_TOKEN_KEY);
    return token != null;
  }
}

// Pour ignorer les erreurs de certificats SSL en développement
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}