import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/absence.dart';
import '../providers/auth_provider.dart';

class PointageProvider {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  
  // URL de base de l'API
  late final String baseUrl;
  
  PointageProvider() {
    baseUrl = _authProvider.apiBaseUrl;
  }

  // Méthode pour obtenir les en-têtes avec le token JWT
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authProvider.getJwtToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Récupère les premiers étudiants du jour
  Future<List<Absence>> getListeAbsencesPourCours(String idCours) async {
    try {
      print("PointageProvider: Récupération des premiers étudiants du jour");
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      // Utiliser l'endpoint correct avec le format de date spécifié
      final uri = Uri.parse('$baseUrl/absences/mobiles/premiers');
      print("URI de la requête: $uri");
      
      final response = await http.get(uri, headers: headers);
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        return Future.error(response.reasonPhrase ?? 'Erreur inconnue');
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        final decodedBody = jsonDecode(response.body);
        print("Type de données décodées: ${decodedBody.runtimeType}");
        
        // Gérer différents formats de réponse possibles
        List<dynamic> dataList;
        
        if (decodedBody is List) {
          // Si la réponse est directement une liste
          dataList = decodedBody;
        } else if (decodedBody is Map) {
          // Si la réponse est un objet avec une propriété contenant la liste
          // Chercher la première propriété qui contient une liste
          var foundList = false;
          dataList = [];
          
          decodedBody.forEach((key, value) {
            if (!foundList && value is List) {
              dataList = value;
              foundList = true;
              print("Données trouvées dans la propriété: $key");
            }
          });
          
          if (!foundList) {
            // Si aucune liste n'est trouvée, essayer de convertir l'objet lui-même
            // en tant qu'élément unique dans une liste
            dataList = [decodedBody];
          }
        } else {
          throw FormatException("Format de réponse non reconnu");
        }
        
        // Mapper les données en objets Absence
        final absences = dataList.map((data) {
          try {
            // Vérifier que data est un Map et le convertir en Map<String, dynamic>
            final Map<String, dynamic> safeData = 
                data is Map ? Map<String, dynamic>.from(data) : {};
                
            // S'assurer que chaque champ requis existe, sinon utiliser des valeurs par défaut
            final Map<String, dynamic> absenceData = {
              'id': safeData['id'] ?? safeData['_id'] ?? safeData['absenceId'] ?? 'unknown',
              'matricule': safeData['matricule'] ?? 'unknown',
              'nom': safeData['nom'] ?? _getNestedValue(safeData, ['etudiant', 'nom']) ?? 'unknown',
              'prenom': safeData['prenom'] ?? _getNestedValue(safeData, ['etudiant', 'prenom']) ?? 'unknown',
              'classe': safeData['classe'] ?? _getNestedValue(safeData, ['etudiant', 'classe']) ?? 'unknown',
              'module': safeData['module'] ?? _getNestedValue(safeData, ['cours', 'module']) ?? idCours,
              'date': safeData['date'] ?? DateTime.now().toIso8601String(),
              'heure': safeData['heure'] ?? '00:00',
              'status': safeData['status'] ?? safeData['etat'] ?? 'absent',
            };
            
            return Absence.fromJson(absenceData);
          } catch (e) {
            print("Erreur lors de la conversion d'un élément: $e");
            print("Données brutes de l'élément: $data");
            // Retourner null en cas d'erreur pour pouvoir filtrer ensuite
            return null;
          }
        })
        // Filtrer les éléments null
        .where((absence) => absence != null)
        .cast<Absence>()
        .toList();
        
        print("Nombre d'absences converties avec succès: ${absences.length}");
        return absences;
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return [];
      }
    } catch (e) {
      print("Exception lors de la récupération des absences: $e");
      return Future.error('Erreur lors de la récupération des absences: $e');
    }
  }

  // Fonction utilitaire pour obtenir des valeurs nichées dans un Map en toute sécurité
  dynamic _getNestedValue(Map<String, dynamic> map, List<String> keys) {
    dynamic current = map;
    for (var key in keys) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  // Rechercher un étudiant par matricule
  Future<Absence?> rechercherEtudiantParMatricule(String matricule) async {
    try {
      print("PointageProvider: Recherche de l'étudiant avec le matricule $matricule");
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      // Utiliser l'endpoint de recherche que vous avez mentionné
      final response = await http.get(
        Uri.parse('$baseUrl/absences/mobiles/rechercher?matricule=$matricule'),
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        return Future.error(response.reasonPhrase ?? 'Étudiant non trouvé');
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        if (response.body.isEmpty) {
          return null;
        }
        
        final decodedBody = jsonDecode(response.body);
        print("Type de données décodées: ${decodedBody.runtimeType}");
        
        // Gérer différents formats de réponse possibles
        Map<String, dynamic> studentData;
        
        if (decodedBody is Map) {
          // Convertir explicitement Map<dynamic, dynamic> en Map<String, dynamic>
          studentData = Map<String, dynamic>.from(decodedBody);
        } else if (decodedBody is List && decodedBody.isNotEmpty && decodedBody.first is Map) {
          // Si la réponse est une liste, prendre le premier élément et le convertir
          studentData = Map<String, dynamic>.from(decodedBody.first);
        } else {
          throw FormatException("Format de réponse non reconnu");
        }
        
        // S'assurer que chaque champ requis existe, sinon utiliser des valeurs par défaut
        final Map<String, dynamic> absenceData = {
          'id': studentData['id'] ?? studentData['_id'] ?? studentData['absenceId'] ?? 'unknown',
          'matricule': studentData['matricule'] ?? matricule,
          'nom': studentData['nom'] ?? _getNestedValue(studentData, ['etudiant', 'nom']) ?? 'unknown',
          'prenom': studentData['prenom'] ?? _getNestedValue(studentData, ['etudiant', 'prenom']) ?? 'unknown',
          'classe': studentData['classe'] ?? _getNestedValue(studentData, ['etudiant', 'classe']) ?? 'unknown',
          'module': studentData['coursNom'] ?? _getNestedValue(studentData, ['cours', 'module']) ?? 'unknown',
          'date': studentData['date'] ?? DateTime.now().toIso8601String(),
          'heure': studentData['heure'] ?? '00:00',
          'status': studentData['statut'] ?? studentData['status'] ?? 'unknown',
        };
        
        return Absence.fromJson(absenceData);
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return null;
      }
    } catch (e) {
      print("Exception lors de la recherche de l'étudiant: $e");
      return Future.error('Erreur lors de la recherche de l\'étudiant: $e');
    }
  }

  // Marquer un étudiant présent
  Future<Absence?> marquerEtudiantPresent(String matricule, String idCours) async {
    try {
      print("PointageProvider: Marquage de l'étudiant $matricule présent");
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      // Utiliser l'endpoint de pointage que vous avez mentionné
      final response = await http.post(
        Uri.parse('$baseUrl/absences/mobiles/pointer?matricule=$matricule'),
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        return Future.error(response.reasonPhrase ?? 'Erreur lors du pointage');
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        if (response.body.isEmpty) {
          // Si la réponse est vide mais le statut est 200, considérer comme succès
          // et renvoyer une absence mise à jour manuellement
          return Absence(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            matricule: matricule,
            nom: 'Mis à jour',
            prenom: '',
            classe: '',
            module: idCours,
            date: DateTime.now(),
            heure: DateFormat('HH:mm').format(DateTime.now()),
            status: 'present',
          );
        }
        
        final decodedBody = jsonDecode(response.body);
        
        // Gérer différents formats de réponse possibles
        Map<String, dynamic> studentData;
        
        if (decodedBody is Map) {
          // Convertir explicitement Map<dynamic, dynamic> en Map<String, dynamic>
          studentData = Map<String, dynamic>.from(decodedBody);
        } else if (decodedBody is List && decodedBody.isNotEmpty && decodedBody.first is Map) {
          // Si la réponse est une liste, prendre le premier élément et le convertir
          studentData = Map<String, dynamic>.from(decodedBody.first);
        } else {
          throw FormatException("Format de réponse non reconnu");
        }
        
        // S'assurer que chaque champ requis existe, sinon utiliser des valeurs par défaut
        final Map<String, dynamic> absenceData = {
          'id': studentData['id'] ?? studentData['_id'] ?? studentData['absenceId'] ?? 'unknown',
          'matricule': studentData['matricule'] ?? matricule,
          'nom': studentData['nom'] ?? _getNestedValue(studentData, ['etudiant', 'nom']) ?? 'Mis à jour',
          'prenom': studentData['prenom'] ?? _getNestedValue(studentData, ['etudiant', 'prenom']) ?? '',
          'classe': studentData['classe'] ?? _getNestedValue(studentData, ['etudiant', 'classe']) ?? '',
          'module': studentData['module'] ?? _getNestedValue(studentData, ['cours', 'module']) ?? idCours,
          'date': studentData['date'] ?? DateTime.now().toIso8601String(),
          'heure': studentData['heure'] ?? DateFormat('HH:mm').format(DateTime.now()),
          'status': 'present', // Forcer le statut à présent puisque c'est une opération de marquage
        };
        
        return Absence.fromJson(absenceData);
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        // Retourner un objet par défaut en cas d'erreur de parsing
        return Absence(
          id: 'error_${DateTime.now().millisecondsSinceEpoch}',
          matricule: matricule,
          nom: 'Erreur',
          prenom: 'Parsing',
          classe: '',
          module: idCours,
          date: DateTime.now(),
          heure: DateFormat('HH:mm').format(DateTime.now()),
          status: 'present', // On suppose que le marquage a réussi côté serveur
        );
      }
    } catch (e) {
      print("Exception lors du marquage de présence: $e");
      return Future.error('Erreur lors du marquage de présence: $e');
    }
  }
}
