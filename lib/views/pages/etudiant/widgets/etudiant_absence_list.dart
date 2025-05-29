import 'package:flutter/material.dart';

// Définition des couleurs ISM
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);
const Color ismBrownLight = Color(0xFFb56e1e);
const Color ismOrangeLight = Color(0xFFda841f);

class EtudiantAbsenceList extends StatelessWidget {
  const EtudiantAbsenceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ismBrownDark.withOpacity(0.03),
      appBar: AppBar(
        backgroundColor: ismBrownDark,
        title: const Text(
          'Absence-Retard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('Licence 2 CLRS', style: TextStyle(fontSize: 14, color: Colors.white)),
                Text('DK-30352', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        ],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section photo et QR code - maintenant cliquable
            _buildStudentProfileWithQR(context),

            // Section des totaux d'absence
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ismBrown.withOpacity(0.08),
                border: Border.all(color: ismBrownLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Absence cum', style: TextStyle(fontWeight: FontWeight.bold, color: ismBrown)),
                      Text('Absence Soumex', style: TextStyle(fontWeight: FontWeight.bold, color: ismBrown)),
                      Text('Retire cum', style: TextStyle(fontWeight: FontWeight.bold, color: ismBrown)),
                      Text('Absence restam', style: TextStyle(fontWeight: FontWeight.bold, color: ismBrown)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('31h', style: TextStyle(color: ismOrange)),
                      Text('2h', style: TextStyle(color: ismOrange)),
                      Text('8h', style: TextStyle(color: ismOrange)),
                      Text('41h', style: TextStyle(color: ismOrange)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Titre "Aujourd'hui"
            const Text(
              'Aujourd\'hui',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ismBrownDark,
              ),
            ),

            const SizedBox(height: 16),

            // Liste des absences/retards
            _buildAbsenceItem(
              context: context,
              course: 'Development Flutter',
              type: 'Retard',
              date: '14/02/2024',
              start: '8h',
              end: '12h',
              isRetard: true,
            ),

            const SizedBox(height: 16),

            _buildAbsenceItem(
              context: context,
              course: 'Gestion de Projet',
              type: 'Absence',
              date: '14/02/2024',
              start: '8h',
              end: '12h',
              isRetard: false,
            ),

            const SizedBox(height: 16),

            _buildAbsenceItem(
              context: context,
              course: 'Développement Flutter',
              type: 'Retard',
              date: '14/02/2024',
              start: '8h',
              end: '12h',
              isRetard: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentProfileWithQR(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showFullSizeProfile(context);
      },
      child: Center(
        child: Column(
          children: [
            // Photo de l'étudiant
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: ismOrange, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/student_photo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Code QR
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: ismBrownLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/qr_code.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showFullSizeProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Photo en grand
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: ismOrange, width: 3),
                    image: const DecorationImage(
                      image: AssetImage('assets/student_photo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // QR code en grand
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ismBrownLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/qr_code.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                // Bouton de fermeture
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ismOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAbsenceItem({
    required BuildContext context,
    required String course,
    required String type,
    required String date,
    required String start,
    required String end,
    required bool isRetard,
  }) {
    final Color badgeBg = isRetard ? ismOrangeLight.withOpacity(0.18) : ismOrange.withOpacity(0.18);
    final Color badgeText = isRetard ? ismOrangeLight : ismOrange;
    final Color borderColor = isRetard ? ismOrangeLight : ismOrange;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ismBrown.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  course,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ismBrownDark,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.list, color: ismBrown),
                onPressed: () {
                  _showJustificationDialog(context, course);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$type: $date',
                  style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text('Début: $start', style: const TextStyle(color: ismBrown)),
              const SizedBox(width: 16),
              Text('Fin: $end', style: const TextStyle(color: ismBrown)),
            ],
          ),
        ],
      ),
    );
  }

  void _showJustificationDialog(BuildContext context, String courseName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Justifier $courseName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Sélectionnez un motif de justification:'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Motif',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Maladie', child: Text('Maladie')),
                  DropdownMenuItem(value: 'Problème familial', child: Text('Problème familial')),
                  DropdownMenuItem(value: 'Problème de transport', child: Text('Problème de transport')),
                  DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                ],
                onChanged: (value) {
                  // Gérer la sélection du motif
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Commentaire (optionnel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ismOrange,
              ),
              onPressed: () {
                // Envoyer la justification
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Justification pour $courseName envoyée'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Envoyer', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}