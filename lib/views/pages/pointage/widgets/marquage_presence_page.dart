import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/views/pages/pointage/widgets/liste_presences_page.dart';

class MarquagePresencePage extends StatelessWidget {
  const MarquagePresencePage({super.key});

  void marquerPresence(BuildContext context) {
    // Tu peux ajouter ici la logique d'enregistrement dans la base de données
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Présence marquée avec succès')),
    );

    // Redirection vers la page de liste des présences
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListePresencesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    '/Users/mac/Downloads/suivi-absence-mobile/image.png',
                    height: 40,
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
                        'Amadou\nDiaw',
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
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Color(0xFF3B1E0E),
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
                          const CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(
                              'image copy.png',
                            ),
                          ),
                          const SizedBox(height: 16),
                          buildInfoRow('Matricule', 'DK-30345'),
                          buildInfoRow('Nom', 'Keita'),
                          buildInfoRow('Prénom', 'Adja Marieme'),
                          buildInfoRow('Classe', 'L3GLRS'),
                          buildInfoRow('Cours', 'PHP'),
                          buildInfoRow('Heure', '8h-12h'),
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
                        onPressed: () {},
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
