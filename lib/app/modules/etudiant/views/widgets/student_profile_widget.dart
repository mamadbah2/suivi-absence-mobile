import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Définition des couleurs ISM avec des nuances améliorées
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);
const Color ismBrownLight = Color(0xFFb56e1e);
const Color ismOrangeLight = Color(0xFFda841f);

class StudentProfileWidget extends StatelessWidget {
  final String photoUrl;
  final String nomComplet;
  final String infoFormation;
  final String matricule;
  final bool isSmallScreen;

  const StudentProfileWidget({
    super.key,
    required this.photoUrl,
    required this.nomComplet,
    required this.infoFormation,
    required this.matricule,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
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
                    image: DecorationImage(
                      image: AssetImage(photoUrl),
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
                  child: const Icon(Icons.qr_code, color: ismOrange, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              nomComplet,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ismBrownDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Étudiant en $infoFormation',
              style: const TextStyle(
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
                    image: DecorationImage(
                      image: AssetImage(photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Informations étudiant
                Text(
                  nomComplet,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ismBrownDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$infoFormation - $matricule',
                  style: const TextStyle(
                    fontSize: 16,
                    color: ismBrown,
                  ),
                ),
                const SizedBox(height: 20),
                // Code QR dynamique généré à partir du matricule
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ismBrownLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: matricule,
                        version: QrVersions.auto,
                        size: 180,
                        backgroundColor: Colors.white,
                        foregroundColor: ismBrownDark,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID: STUD-${DateTime.now().year}-ISM-$matricule',
                        style: const TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
}