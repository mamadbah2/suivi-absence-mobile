import 'package:suivi_absence_mobile/models/etudiant.dart';
import 'package:get/get.dart';

class EtudiantService extends GetxService {
  Future<List<Etudiant>> getAllEtudiant() async {
    return [];
  }

  Future<Etudiant?> getEtudiantByMatricule(String matricule) async {
    return null;
  }

  // Simuler les données de l'étudiant
  Future<Map<String, dynamic>> getStudentInfo() async {
    // Simuler un appel API
    await Future.delayed(Duration(seconds: 1));
    return {
      'nom': 'Ndiaye',
      'prenom': 'Anna',
      'photoUrl': 'assets/images/student_photo.jpg',
      'filiere': 'Licence 2 GLRS',
      'matricule': 'DK-30352',
      'email': 'anna.ndiaye@example.com',
      'telephone': '+221 77 123 45 67',
      'annee': '2023-2024',
      'semestre': 'S4',
    };
  }

  // Simuler les statistiques d'absence
  Future<List<Map<String, String>>> getAbsenceStats() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      {"label": "Absence cum.", "value": "31h"},
      {"label": "Absence journée", "value": "2h"},
      {"label": "Retard cum.", "value": "8h"},
      {"label": "Absence restantes", "value": "41h"},
    ];
  }

  // Simuler les cours du jour
  Future<List<Map<String, dynamic>>> getTodayCourses() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      {
        "title": "Développement Flutter",
        "type": "Absence | Non justifiée",
        "date": "14/03/2024",
        "time": "8h - 12h",
        "isJustified": false,
        "professeur": "Dr. Mamadou Diallo",
        "salle": "Salle 101",
        "module": "Mobile Development",
      },
      {
        "title": "Gestion de Projet",
        "type": "Absence | Justifiée",
        "date": "14/03/2024",
        "time": "13h - 15h",
        "isJustified": true,
        "professeur": "Prof. Aissatou Ba",
        "salle": "Salle 203",
        "module": "Project Management",
        "justification": "Certificat médical",
      },
      {
        "title": "Développement Flutter",
        "type": "Retard | Non justifié",
        "date": "14/03/2024",
        "time": "16h - 18h",
        "isJustified": false,
        "professeur": "Dr. Mamadou Diallo",
        "salle": "Salle 101",
        "module": "Mobile Development",
      },
      {
        "title": "Base de données",
        "type": "Présent",
        "date": "14/03/2024",
        "time": "18h - 20h",
        "isJustified": true,
        "professeur": "Dr. Ibrahima Sow",
        "salle": "Salle 305",
        "module": "Database Systems",
      },
    ];
  }

  // Simuler l'historique des absences
  Future<List<Map<String, dynamic>>> getAbsenceHistory() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      {
        "date": "13/03/2024",
        "cours": "Algorithmique",
        "type": "Absence",
        "justifie": true,
        "justification": "Certificat médical",
      },
      {
        "date": "12/03/2024",
        "cours": "Réseaux",
        "type": "Retard",
        "justifie": false,
        "justification": "",
      },
      {
        "date": "11/03/2024",
        "cours": "Systèmes d'exploitation",
        "type": "Absence",
        "justifie": true,
        "justification": "Convocation administrative",
      },
    ];
  }

  // Méthode pour la déconnexion
  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
    // Ici, tu ajouteras la logique de déconnexion réelle
  }
}
