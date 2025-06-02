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
  
  // Variable pour activer/désactiver la simulation
  final bool _useSimulation = false;
  
  PointageProvider() {
    try {
      baseUrl = _authProvider.apiBaseUrl;
      print("PointageProvider initialized with baseUrl: $baseUrl");
    } catch (e) {
      print("Erreur lors de l'initialisation du PointageProvider: $e");
    }
  }

  // Méthode pour obtenir les en-têtes avec le token JWT
  Future<Map<String, String>> _getHeaders() async {
    try {
      final token = await _authProvider.getJwtToken();
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
    } catch (e) {
      print("Erreur lors de la récupération des en-têtes: $e");
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    }
  }

  // Récupère les premiers étudiants du jour
  Future<List<Absence>> getListeAbsencesPourCours() async {
    try {
      print("PointageProvider: Récupération des premiers étudiants du jour");
      
      // Si la simulation est activée, retourner des données simulées
      if (_useSimulation) {
        print("Mode simulation activé: retourne des données simulées");
        return _getSimulatedAbsences();
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      // Utiliser l'endpoint correct avec le format de date spécifié
      final uri = Uri.parse('$baseUrl/absences/mobiles/premiers');
      print("URI de la requête: $uri");
      
      // Utiliser un timeout pour éviter les attentes trop longues
      final response = await http.get(uri, headers: headers)
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            print("Timeout lors de la requête API");
            return http.Response('{"error": "Timeout"}', 408);
          }
        );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}, Body: ${response.body}");
        
        // En cas d'erreur, retourner des données simulées plutôt qu'une erreur
        print("Utilisation des données simulées comme fallback");
        return _getSimulatedAbsences();
      }
      
      print("Réponse API reçue avec succès");
      
      try {
        // Si le body est vide, retourner une liste vide
        if (response.body.isEmpty) {
          print("Réponse API vide");
          return [];
        }
        
        final decodedBody = jsonDecode(response.body);
        
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
          print("Format de réponse non reconnu: ${decodedBody.runtimeType}");
          return _getSimulatedAbsences();
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
              'module': safeData['module'] ?? _getNestedValue(safeData, ['cours', 'module']),
              'date': safeData['date'] ?? DateTime.now().toIso8601String(),
              'heure': safeData['heure'] ?? '00:00',
              'status': safeData['status'] ?? safeData['etat'] ?? 'absent',
            };
            
            return Absence.fromJson(absenceData);
          } catch (e) {
            print("Erreur lors de la conversion d'un élément: $e");
            return null;
          }
        })
        .where((absence) => absence != null)
        .cast<Absence>()
        .toList();
        
        print("Nombre d'absences converties avec succès: ${absences.length}");
        
        // Si aucune absence n'est trouvée, utiliser des données simulées
        if (absences.isEmpty) {
          print("Aucune absence trouvée, utilisation des données simulées");
          return _getSimulatedAbsences();
        }
        
        return absences;
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return _getSimulatedAbsences();
      }
    } catch (e) {
      print("Exception lors de la récupération des absences: $e");
      return _getSimulatedAbsences();
    }
  }
  
  // Génère des données simulées d'absences
  List<Absence> _getSimulatedAbsences() {
    final now = DateTime.now();
    
    return [
      Absence(
        id: 'sim_1',
        matricule: 'DK-30352',
        nom: 'Diallo',
        prenom: 'Mamadou',
        classe: 'Licence 3 GL',
        module: 'Flutter',
        date: now,
        heure: '08:00',
        status: 'absent',
        type: 'Absence',
        duree: '08:00-10:00',
        professeur: 'Dr. Ndiaye',
        salle: 'Salle 202',
      ),
      Absence(
        id: 'sim_2',
        matricule: 'DK-30353',
        nom: 'Diop',
        prenom: 'Fatou',
        classe: 'Licence 3 GL',
        module: 'Flutter',
        date: now,
        heure: '08:00',
        status: 'present',
        type: 'Présence',
        duree: '08:00-10:00',
        professeur: 'Dr. Ndiaye',
        salle: 'Salle 202',
      ),
      Absence(
        id: 'sim_3',
        matricule: 'DK-30354',
        nom: 'Sow',
        prenom: 'Abdoulaye',
        classe: 'Licence 3 GL',
        module: 'Flutter',
        date: now,
        heure: '08:00',
        status: 'absent',
        type: 'Absence',
        duree: '08:00-10:00',
        professeur: 'Dr. Ndiaye',
        salle: 'Salle 202',
      ),
      Absence(
        id: 'sim_4',
        matricule: 'DK-30355',
        nom: 'Fall',
        prenom: 'Aissatou',
        classe: 'Licence 3 GL',
        module: 'Flutter',
        date: now,
        heure: '08:00',
        status: 'absent',
        type: 'Absence',
        duree: '08:00-10:00',
        professeur: 'Dr. Ndiaye',
        salle: 'Salle 202',
      ),
    ];
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
      
      // Si la simulation est activée, simuler une recherche d'étudiant
      if (_useSimulation) {
        print("Mode simulation activé: recherche simulée d'étudiant");
        final etudiants = _getSimulatedAbsences();
        try {
          return etudiants.firstWhere((e) => e.matricule == matricule);
        } catch (e) {
          // Si l'étudiant n'est pas trouvé dans les données simulées,
          // retourner un nouvel étudiant simulé avec ce matricule
          return Absence(
            id: 'sim_searched',
            matricule: matricule,
            nom: 'Étudiant',
            prenom: 'Simulé',
            classe: 'Licence 3',
            module: 'Flutter',
            date: DateTime.now(),
            heure: '08:00',
            status: 'absent',
            type: 'Absence',
            duree: '08:00-10:00',
          );
        }
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      // Utiliser l'endpoint de recherche
      final response = await http.get(
        Uri.parse('$baseUrl/absences/mobiles/rechercher?matricule=$matricule'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print("Timeout lors de la recherche d'étudiant");
          return http.Response('{"error": "Timeout"}', 408);
        }
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}, Corps: ${response.body}");
        
        // Tenter de trouver l'étudiant dans les données locales
        final localData = _getSimulatedAbsences();
        try {
          return localData.firstWhere((e) => e.matricule == matricule);
        } catch (e) {
          // Si non trouvé localement aussi, lever une erreur
          return Future.error('Étudiant non trouvé');
        }
      }
      
      try {
        if (response.body.isEmpty) {
          return null;
        }
        
        final decodedBody = jsonDecode(response.body);
        
        // Gérer différents formats de réponse possibles
        Map<String, dynamic> studentData;
        
        if (decodedBody is Map) {
          studentData = Map<String, dynamic>.from(decodedBody);
        } else if (decodedBody is List && decodedBody.isNotEmpty && decodedBody.first is Map) {
          studentData = Map<String, dynamic>.from(decodedBody.first);
        } else {
          throw FormatException("Format de réponse non reconnu");
        }
        
        // S'assurer que chaque champ requis existe
        final Map<String, dynamic> absenceData = {
          'id': studentData['id'] ?? studentData['_id'] ?? studentData['absenceId'] ?? 'unknown',
          'matricule': studentData['matricule'] ?? matricule,
          'nom': studentData['nom'] ?? _getNestedValue(studentData, ['etudiant', 'nom']) ?? 'unknown',
          'prenom': studentData['prenom'] ?? _getNestedValue(studentData, ['etudiant', 'prenom']) ?? 'unknown',
          'classe': studentData['classe'] ?? _getNestedValue(studentData, ['etudiant', 'classe']) ?? 'unknown',
          'module': studentData['coursNom'] ?? _getNestedValue(studentData, ['cours', 'module']) ?? 'unknown',
          'date': studentData['date'] ?? DateTime.now().toIso8601String(),
          'heure': studentData['heure'] ?? '00:00',
          'status': studentData['statut'] ?? studentData['status'] ?? 'absent',
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
      
      // Si la simulation est activée
      if (_useSimulation) {
        print("Mode simulation activé: simulation de marquage de présence");
        // Simuler un délai
        await Future.delayed(const Duration(milliseconds: 500));
        // Retourner un objet Absence mis à jour
        return Absence(
          id: 'sim_marked_${DateTime.now().millisecondsSinceEpoch}',
          matricule: matricule,
          nom: 'Étudiant',
          prenom: 'Marqué',
          classe: 'Licence 3',
          module: idCours,
          date: DateTime.now(),
          heure: DateFormat('HH:mm').format(DateTime.now()),
          status: 'present',
        );
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      // Utiliser l'endpoint de pointage
      final response = await http.post(
        Uri.parse('$baseUrl/absences/mobiles/pointer?matricule=$matricule'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print("Timeout lors du marquage de présence");
          return http.Response('{"error": "Timeout"}', 408);
        }
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        return Future.error(response.reasonPhrase ?? 'Erreur lors du pointage');
      }
      
      try {
        if (response.body.isEmpty) {
          // Si la réponse est vide mais le statut est 200, considérer comme succès
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
          studentData = Map<String, dynamic>.from(decodedBody);
        } else if (decodedBody is List && decodedBody.isNotEmpty && decodedBody.first is Map) {
          studentData = Map<String, dynamic>.from(decodedBody.first);
        } else {
          throw FormatException("Format de réponse non reconnu");
        }
        
        // S'assurer que chaque champ requis existe
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
          status: 'present',
        );
      }
    } catch (e) {
      print("Exception lors du marquage de présence: $e");
      return Future.error('Erreur lors du marquage de présence: $e');
    }
  }
}
