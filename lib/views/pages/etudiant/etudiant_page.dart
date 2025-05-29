import 'package:flutter/material.dart';

class EtudiantPage extends StatelessWidget {
  const EtudiantPage({super.key}); // Utilisation de super.parameters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Étudiant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Bienvenue sur votre espace étudiant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la liste des absences
              },
              child: const Text('Voir mes absences'),
            ),
          ],
        ),
      ),
    );
  }
}