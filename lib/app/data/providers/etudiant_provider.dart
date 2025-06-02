import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/absence.dart';
import '../models/etudiant_model.dart';
import '../models/absence_stats.dart';
import '../providers/auth_provider.dart';

class EtudiantProvider extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  
  // URL de base de l'API
  late final String baseUrl;
  
  // Variable pour activer/désactiver la simulation
  final bool _useSimulation = false; // Désactivé pour utiliser les données réelles
  
  EtudiantProvider() {
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

  // Récupère les informations de l'étudiant actuel
  Future<EtudiantModel> getCurrentEtudiant() async {
    try {
      print("EtudiantProvider: Récupération du profil étudiant");
      
      if (_useSimulation) {
        print("Mode simulation activé: retourne des données simulées");
        return _getSimulatedEtudiant();
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/etudiants/profil'),
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        print("Détails: ${response.body}");
        return _getSimulatedEtudiant();
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        if (response.body.isEmpty) {
          return EtudiantModel.empty();
        }
        
        final decodedBody = jsonDecode(response.body);
        
        if (decodedBody is Map) {
          return EtudiantModel.fromJson(Map<String, dynamic>.from(decodedBody));
        } else {
          throw FormatException("Format de réponse non reconnu");
        }
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return _getSimulatedEtudiant();
      }
    } catch (e) {
      print("Exception lors de la récupération des informations étudiant: $e");
      return _getSimulatedEtudiant();
    }
  }
  
  // Récupère les statistiques d'absence
  Future<AbsenceStats> getAbsenceStats() async {
    try {
      print("EtudiantProvider: Récupération des statistiques d'absence");
      
      if (_useSimulation) {
        print("Mode simulation activé: retourne des statistiques simulées");
        return _getSimulatedAbsenceStats();
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/absences/statistiques'),
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        print("Détails: ${response.body}");
        return _getSimulatedAbsenceStats();
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        if (response.body.isEmpty) {
          return AbsenceStats.empty();
        }
        
        final decodedBody = jsonDecode(response.body);
        
        if (decodedBody is Map) {
          return AbsenceStats.fromJson(Map<String, dynamic>.from(decodedBody));
        } else {
          throw FormatException("Format de réponse non reconnu");
        }
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return _getSimulatedAbsenceStats();
      }
    } catch (e) {
      print("Exception lors de la récupération des statistiques: $e");
      return _getSimulatedAbsenceStats();
    }
  }
  
  // Récupère les absences du jour
  Future<List<Absence>> getAbsencesDuJour() async {
    try {
      print("EtudiantProvider: Récupération des absences du jour");
      
      if (_useSimulation) {
        print("Mode simulation activé: retourne des absences du jour simulées");
        return _getSimulatedAbsencesDuJour();
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/absences/jour'),
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        print("Détails: ${response.body}");
        return _getSimulatedAbsencesDuJour();
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        final decodedBody = jsonDecode(response.body);
        
        List<dynamic> dataList;
        if (decodedBody is List) {
          dataList = decodedBody;
        } else if (decodedBody is Map && decodedBody.containsKey('absences')) {
          dataList = decodedBody['absences'] as List<dynamic>;
        } else {
          return _getSimulatedAbsencesDuJour();
        }
        
        return dataList
            .map((data) {
              try {
                if (data is Map) {
                  return Absence.fromJson(Map<String, dynamic>.from(data));
                }
                return null;
              } catch (e) {
                print("Erreur lors de la conversion d'une absence: $e");
                return null;
              }
            })
            .where((a) => a != null)
            .cast<Absence>()
            .toList();
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return _getSimulatedAbsencesDuJour();
      }
    } catch (e) {
      print("Exception lors de la récupération des absences du jour: $e");
      return _getSimulatedAbsencesDuJour();
    }
  }
  
  // Récupère l'historique des absences
  Future<List<Absence>> getHistoriqueAbsences() async {
    try {
      print("EtudiantProvider: Récupération de l'historique des absences");
      
      if (_useSimulation) {
        print("Mode simulation activé: retourne un historique simulé");
        return _getSimulatedHistoriqueAbsences();
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/absences/historique'),
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        print("Détails: ${response.body}");
        return _getSimulatedHistoriqueAbsences();
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        final decodedBody = jsonDecode(response.body);
        
        List<dynamic> dataList;
        if (decodedBody is List) {
          dataList = decodedBody;
        } else if (decodedBody is Map && decodedBody.containsKey('historique')) {
          dataList = decodedBody['historique'] as List<dynamic>;
        } else {
          return _getSimulatedHistoriqueAbsences();
        }
        
        return dataList
            .map((data) {
              try {
                if (data is Map) {
                  return Absence.fromJson(Map<String, dynamic>.from(data));
                }
                return null;
              } catch (e) {
                print("Erreur lors de la conversion d'une absence historique: $e");
                return null;
              }
            })
            .where((a) => a != null)
            .cast<Absence>()
            .toList();
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return _getSimulatedHistoriqueAbsences();
      }
    } catch (e) {
      print("Exception lors de la récupération de l'historique: $e");
      return _getSimulatedHistoriqueAbsences();
    }
  }
  
  // Soumet une justification pour une absence
  Future<bool> soumettreJustification(String absenceId, String motif, String commentaire) async {
    try {
      print("EtudiantProvider: Soumission de justification pour l'absence $absenceId");
      
      if (_useSimulation) {
        print("Mode simulation activé: simulation de la soumission de justification");
        // Pause pour simuler le temps de traitement
        await Future.delayed(const Duration(milliseconds: 800));
        return true;
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      final body = jsonEncode({
        'absenceId': absenceId,
        'motif': motif,
        'commentaire': commentaire,
      });
      
      final response = await http.post(
        Uri.parse('$baseUrl/absences/justifier'),
        headers: headers,
        body: body,
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        print("Erreur API: ${response.statusCode}");
        print("Détails: ${response.body}");
        return false;
      }
      
      return true;
    } catch (e) {
      print("Exception lors de la soumission de justification: $e");
      return false;
    }
  }
  
  // Récupère les absences d'un étudiant par son matricule
  Future<List<Absence>> getAbsencesEtudiant(String matricule) async {
    try {
      print("EtudiantProvider: Récupération des absences de l'étudiant $matricule");
      
      if (_useSimulation) {
        print("Mode simulation activé: retourne des absences simulées");
        return _getSimulatedAbsencesDuJour();
      }
      
      // Obtenir les en-têtes avec le token JWT
      final headers = await _getHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/absences/etudiants/$matricule'),
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("Timeout lors de la requête API");
          return http.Response('{"error": "Timeout"}', 408);
        }
      );
      
      if (response.statusCode != 200) {
        print("Erreur API: ${response.statusCode}");
        print("Détails: ${response.body}");
        return _getSimulatedAbsencesDuJour();
      }
      
      print("Réponse API: ${response.body}");
      
      try {
        if (response.body.isEmpty) {
          return [];
        }
        
        final decodedBody = jsonDecode(response.body);
        
        if (decodedBody is! List) {
          throw FormatException("Format de réponse non reconnu, attendu: liste");
        }
        
        return decodedBody.map((item) {
          try {
            // Extraire les données du cours
            final cours = item['cours'] ?? {};
            final module = cours['module'] ?? {};
            
            return Absence(
              id: item['id']?.toString() ?? '',
              matricule: matricule,
              nom: '', // Ces valeurs seront complétées ailleurs
              prenom: '', // Ces valeurs seront complétées ailleurs
              classe: '', // Ces valeurs seront complétées ailleurs
              module: module['nom'] ?? 'Inconnu',
              date: item['date'] != null 
                  ? DateTime.parse(item['date']) 
                  : DateTime.now(),
              heure: item['heure']?.toString()?.substring(0, 5) ?? '00:00',
              status: item['status']?.toString()?.toLowerCase() ?? 'absent',
              justification: item['justification'],
              duree: cours['heureDebut'] != null && cours['heureFin'] != null
                  ? '${cours['heureDebut']}-${cours['heureFin']}' 
                  : null,
              type: item['status'] == 'RETARD' ? 'Retard' : 'Absence',
              professeur: module['nomProf'],
              salle: cours['salle'] ?? 'Non spécifiée',
            );
          } catch (e) {
            print("Erreur lors de la conversion d'une absence: $e");
            return null;
          }
        })
        .where((absence) => absence != null)
        .cast<Absence>()
        .toList();
      } catch (e) {
        print("Erreur lors du décodage/conversion des données: $e");
        return _getSimulatedAbsencesDuJour();
      }
    } catch (e) {
      print("Exception lors de la récupération des absences de l'étudiant: $e");
      return _getSimulatedAbsencesDuJour();
    }
  }
  
  // ======== MÉTHODES DE SIMULATION ==========
  
  // Génère un étudiant simulé
  EtudiantModel _getSimulatedEtudiant() {
    return EtudiantModel(
      id: 'etud_1',
      matricule: 'DK-30352',
      nom: 'BA',
      prenom: 'Ousmane',
      email: 'etudiant@ism.edu',
      classe: 'Licence 2 CLRS'
    );
  }
  
  // Génère des statistiques simulées
  AbsenceStats _getSimulatedAbsenceStats() {
    return AbsenceStats(
      absenceCumulee: '4',
      absenceSoumise: '1',
      retardsCumules: '2',
      absenceRestante: '16',
    );
  }
  
  // Génère des absences du jour simulées
  List<Absence> _getSimulatedAbsencesDuJour() {
    final now = DateTime.now();
    
    return [
      Absence(
        id: 'abs_1',
        matricule: 'DK-30352',
        nom: 'BA',
        prenom: 'Ousmane',
        classe: 'Licence 2 CLRS',
        module: 'Programmation Mobile',
        date: now,
        heure: '08:00',
        status: 'absent',
        type: 'Absence',
        duree: '08:00-10:00',
        professeur: 'Dr. Ndiaye',
        salle: 'Salle 202',
      ),
      Absence(
        id: 'abs_2',
        matricule: 'DK-30352',
        nom: 'BA',
        prenom: 'Ousmane',
        classe: 'Licence 2 CLRS',
        module: 'Base de données',
        date: now,
        heure: '10:30',
        status: 'absent',
        type: 'Retard',
        duree: '10:30-12:30',
        justification: 'En attente',
        professeur: 'Prof. Diallo',
        salle: 'Salle 105',
      ),
    ];
  }
  
  // Génère un historique d'absences simulé
  List<Absence> _getSimulatedHistoriqueAbsences() {
    final now = DateTime.now();
    
    return [
      Absence(
        id: 'hist_1',
        matricule: 'DK-30352',
        nom: 'BA',
        prenom: 'Ousmane',
        classe: 'Licence 2 CLRS',
        module: 'Programmation Web',
        date: now.subtract(const Duration(days: 1)),
        heure: '08:00',
        status: 'absent',
        type: 'Absence',
        duree: '08:00-10:00',
        professeur: 'Dr. Sow',
        salle: 'Salle 101',
      ),
      Absence(
        id: 'hist_2',
        matricule: 'DK-30352',
        nom: 'BA',
        prenom: 'Ousmane',
        classe: 'Licence 2 CLRS',
        module: 'Réseau',
        date: now.subtract(const Duration(days: 2)),
        heure: '14:00',
        status: 'absent',
        type: 'Absence',
        duree: '14:00-16:00',
        justification: 'Justifiée',
        justificatif: 'certificat.pdf',
        professeur: 'Prof. Diop',
        salle: 'Salle 305',
      ),
      Absence(
        id: 'hist_3',
        matricule: 'DK-30352',
        nom: 'BA',
        prenom: 'Ousmane',
        classe: 'Licence 2 CLRS',
        module: 'Mathématiques',
        date: now.subtract(const Duration(days: 5)),
        heure: '10:30',
        status: 'absent',
        type: 'Retard',
        duree: '10:30-12:30',
        professeur: 'Dr. Fall',
        salle: 'Salle 205',
      ),
      Absence(
        id: 'hist_4',
        matricule: 'DK-30352',
        nom: 'BA',
        prenom: 'Ousmane',
        classe: 'Licence 2 CLRS',
        module: 'Anglais',
        date: now.subtract(const Duration(days: 7)),
        heure: '08:00',
        status: 'absent',
        type: 'Absence',
        duree: '08:00-10:00',
        professeur: 'Mme. Camara',
        salle: 'Salle 104',
      ),
    ];
  }
}