import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/absence.dart';
import '../../pointage/controllers/pointage_controller.dart';

class MarquagePresencePage extends StatelessWidget {
  final Absence absence;
  final VoidCallback? onPresenceMarked;

  const MarquagePresencePage({
    Key? key,
    required this.absence,
    this.onPresenceMarked,
  }) : super(key: key);

  void marquerPresence(BuildContext context) {
    // Récupérer le controller de pointage
    final pointageController = Get.find<PointageController>();
    
    // Appeler la méthode de marquage présent
    pointageController.marquerPresent(absence.matricule).then((_) {
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Présence marquée avec succès')),
      );
      
      // Appeler le callback si fourni
      if (onPresenceMarked != null) {
        onPresenceMarked!();
      }
      
      // Retourner à la page précédente
      Navigator.pop(context);
    }).catchError((error) {
      // Gérer les erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser les chemins d'accès corrects pour les assets
    String logoPath = 'assets/images/logo.png';
    String photoPath = 'assets/images/student_photo.jpeg';
    
    return Scaffold(
      backgroundColor: const Color(0xFF3B1E0E),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF2D1B11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo avec chemin d'accès corrigé
                  Image.asset(
                    logoPath,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.school, color: Colors.white, size: 40);
                    },
                  ),
                  const Text(
                    'POINTAGE ETUDIANTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Icon(Icons.refresh, color: Color(0xFFFFA500), size: 20),
                      Text(
                        'Amadou\nDiaw',  // Nom de l'enseignant (à remplacer par une valeur dynamique)
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF2F2F2),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Color(0xFF3B1E0E),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // Photo de l'étudiant (utilisation d'un placeholder si la photo n'est pas disponible)
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.person, size: 40, color: Colors.grey),
                            backgroundImage: const AssetImage(
                              'assets/images/student_photo.jpeg',
                            ),
                            onBackgroundImageError: (e, _) {
                              // Ne rien faire, l'icône sera affichée par défaut
                            },
                          ),
                          const SizedBox(height: 16),
                          // Informations de l'absence avec les vraies données
                          buildInfoRow('Matricule', absence.matricule),
                          buildInfoRow('Nom', absence.nom),
                          buildInfoRow('Prénom', absence.prenom),
                          buildInfoRow('Classe', absence.classe),
                          buildInfoRow('Cours', absence.module),
                          buildInfoRow('Heure', absence.heure),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B1E0E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => marquerPresence(context),
                        child: const Text(
                          'Marquer présent(e)',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: FloatingActionButton(
                        onPressed: () {
                          // Redirection vers la page de scan ou autre action
                          Navigator.pop(context); // Retourne à la page de pointage pour un nouveau scan
                        },
                        backgroundColor: const Color(0xFFB67329),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
