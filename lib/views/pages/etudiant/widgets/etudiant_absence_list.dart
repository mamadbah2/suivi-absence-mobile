import 'package:flutter/material.dart';

// Définition des couleurs ISM avec des nuances améliorées
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);
const Color ismBrownLight = Color(0xFFb56e1e);
const Color ismOrangeLight = Color(0xFFda841f);
const Color ismCream = Color(0xFFf8f1e5);

class EtudiantAbsenceList extends StatelessWidget {
  const EtudiantAbsenceList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: ismCream,
      appBar: AppBar(
        backgroundColor: ismBrownDark,
        title: const Text(
          'Absence-Retard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text('Licence 2 CLRS',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                Text('DK-30352',
                    style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        ],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentProfileWithQR(context, isSmallScreen),

            // Statistiques
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ismBrown.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: ismBrown.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Absence cumulée',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: ismBrown)),
                      SizedBox(height: 8),
                      Text('Absence soumise',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: ismBrown)),
                      SizedBox(height: 8),
                      Text('Retards cumulés',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: ismBrown)),
                      SizedBox(height: 8),
                      Text('Absence restante',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: ismBrown)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('31h',
                          style: TextStyle(
                              color: ismOrange,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('2h',
                          style: TextStyle(
                              color: ismOrange,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('8h',
                          style: TextStyle(
                              color: ismOrange,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('41h',
                          style: TextStyle(
                              color: ismBrownDark,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section "Aujourd'hui"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: ismBrownDark, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Aujourd\'hui',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ismBrownDark,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text('Voir tout', style: TextStyle(color: ismOrange)),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: ismOrange, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Liste des absences/retards
            _buildAbsenceItem(
              context: context,
              course: 'Développement Flutter',
              type: 'Retard',
              date: '14/02/2024',
              start: '8h',
              end: '12h',
              isRetard: true,
              isSmallScreen: isSmallScreen,
            ),

            const SizedBox(height: 12),

            _buildAbsenceItem(
              context: context,
              course: 'Gestion de Projet',
              type: 'Absence',
              date: '14/02/2024',
              start: '8h',
              end: '12h',
              isRetard: false,
              isSmallScreen: isSmallScreen,
            ),

            const SizedBox(height: 12),

            _buildAbsenceItemWithStatus(
              context: context,
              course: 'Base de données',
              type: 'Absence',
              date: '14/02/2024',
              start: '14h',
              end: '18h',
              isRetard: false,
              status: 'Justifiée',
              statusColor: Colors.green,
              isSmallScreen: isSmallScreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentProfileWithQR(BuildContext context, bool isSmallScreen) {
    return GestureDetector(
      onTap: () {
        _showFullSizeProfile(context);
      },
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: isSmallScreen ? 100 : 120,
                  height: isSmallScreen ? 100 : 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: ismOrange, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: ismBrown.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/Et1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: ismOrange),
                  ),
                  child: const Icon(Icons.qr_code,
                      color: ismOrange, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Ousmane Ba',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ismBrownDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Étudiant en Informatique',
              style: TextStyle(
                fontSize: 14,
                color: ismBrown,
              ),
            ),
            const SizedBox(height: 16),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Photo de profil
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: ismOrange, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: ismBrown.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/Et1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Informations étudiant
                const Text(
                  'Ousmane Ba',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ismBrownDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Licence 2 CLRS - DK-30352',
                  style: TextStyle(
                    fontSize: 16,
                    color: ismBrown,
                  ),
                ),
                const SizedBox(height: 20),
                // Code QR
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ismBrownLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/QR_Code_example.png',
                        width: 180,
                        height: 180,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ID: STUD-2024-ISM-12345',
                        style: TextStyle(
                          fontSize: 14,
                          color: ismBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Bouton Fermer
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ismOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
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
    required bool isSmallScreen,
  }) {
    return _buildAbsenceItemWithStatus(
      context: context,
      course: course,
      type: type,
      date: date,
      start: start,
      end: end,
      isRetard: isRetard,
      status: null,
      statusColor: null,
      isSmallScreen: isSmallScreen,
    );
  }

  Widget _buildAbsenceItemWithStatus({
    required BuildContext context,
    required String course,
    required String type,
    required String date,
    required String start,
    required String end,
    required bool isRetard,
    String? status,
    Color? statusColor,
    required bool isSmallScreen,
  }) {
    final Color badgeBg =
        isRetard ? ismOrangeLight.withOpacity(0.18) : ismOrange.withOpacity(0.18);
    final Color badgeText = isRetard ? ismOrangeLight : ismOrange;
    final Color borderColor = isRetard ? ismOrangeLight : ismOrange;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        _showAbsenceDetails(context, course, type, date, start, end, isRetard);
      },
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ismBrown.withOpacity(0.05),
              blurRadius: 6,
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
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: ismBrownDark,
                    ),
                  ),
                ),
                if (status != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor?.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: statusColor ?? Colors.transparent),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isRetard ? Icons.schedule : Icons.event_busy,
                        color: badgeText,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$type • $date',
                        style: TextStyle(
                          color: badgeText,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text('$start - $end',
                    style: TextStyle(
                        color: ismBrown,
                        fontSize: isSmallScreen ? 12 : 14)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: ismBrown),
                  onPressed: () {
                    _showJustificationDialog(context, course);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAbsenceDetails(
    BuildContext context,
    String course,
    String type,
    String date,
    String start,
    String end,
    bool isRetard,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                course,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ismBrownDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.calendar_today, 'Date', date),
              _buildDetailRow(
                  isRetard ? Icons.schedule : Icons.event_busy,
                  'Type',
                  type),
              _buildDetailRow(Icons.access_time, 'Heures', '$start - $end'),
              _buildDetailRow(Icons.person, 'Professeur', 'Prof. Dupont'),
              _buildDetailRow(Icons.location_on, 'Salle', 'Bâtiment A - Salle 203'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: ismOrange),
                      ),
                      child: const Text('Fermer',
                          style: TextStyle(color: ismOrange)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showJustificationDialog(context, course);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ismOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Justifier',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: ismBrown, size: 20),
          const SizedBox(width: 16),
          Text(
            '$label: ',
            style: const TextStyle(
              color: ismBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: ismBrownDark),
          ),
        ],
      ),
    );
  }

  void _showJustificationDialog(BuildContext context, String courseName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedReason;
        String comment = '';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Justifier $courseName',
            style: const TextStyle(color: ismBrownDark),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Veuillez sélectionner un motif de justification :'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Motif',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ismBrownLight),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(color: ismBrownDark),
                items: const [
                  DropdownMenuItem(
                      value: 'Maladie', child: Text('Maladie')),
                  DropdownMenuItem(
                      value: 'Problème familial',
                      child: Text('Problème familial')),
                  DropdownMenuItem(
                      value: 'Problème de transport',
                      child: Text('Problème de transport')),
                  DropdownMenuItem(
                      value: 'Autre', child: Text('Autre')),
                ],
                onChanged: (value) {
                  selectedReason = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Commentaire (optionnel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ismBrownLight),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 3,
                onChanged: (value) {
                  comment = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler',
                  style: TextStyle(color: ismBrown)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ismOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Traitement de la justification
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Justification pour $courseName envoyée\nMotif: ${selectedReason ?? "Non spécifié"}\nCommentaire: ${comment.isNotEmpty ? comment : "Aucun"}'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: const Text('Envoyer',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}