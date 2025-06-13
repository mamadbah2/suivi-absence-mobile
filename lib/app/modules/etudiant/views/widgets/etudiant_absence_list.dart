import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controllers/etudiant_controller.dart';
import '../../../../data/models/absence.dart';
import '../../../../data/controllers/auth_controller.dart';
import '../../../../routes/app_pages.dart';
import './all_absences_page.dart';
import './justification_dialog.dart'; // Import du widget de justification
import './school_map_page.dart'; // Import de la page de carte

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
    final EtudiantController controller = Get.find<EtudiantController>();

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
          // Bouton de déconnexion
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Déconnexion',
            onPressed: () {
              _showLogoutConfirmDialog(context);
            },
          ),
          // Informations de l'étudiant
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(controller.classe.value,
                    style: const TextStyle(fontSize: 14, color: Colors.white)),
                Text(controller.matricule.value,
                    style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          )),
        ],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator(color: ismOrange))
        : SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStudentProfileWithQR(context, isSmallScreen, controller),
              
              // Bouton pour localiser l'école
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SchoolMapPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.location_on, color: Colors.white),
                  label: const Text('Localiser mon école', 
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ismBrownDark,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                ),
              ),

              // Code QR pour remplacer les statistiques
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
                child: Column(
                  children: [
                    // Titre
                    const Text(
                      "Mon Code QR",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ismBrownDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Code QR plus petit et centré
                    Center(
                      child: SizedBox(
                        width: 180.0, // Taille réduite (avant 200.0)
                        height: 180.0, // Taille réduite (avant 200.0)
                        child: Obx(() => QrImageView(
                          data: controller.matricule.value,
                          version: QrVersions.auto,
                          size: 180.0, // Taille réduite (avant 200.0)
                          gapless: true,
                          foregroundColor: ismBrownDark,
                        )),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Matricule
                    Obx(() => Text(
                      'Matricule: ${controller.matricule.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ismBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AllAbsencesPage(),
                          ),
                        );
                      },
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

              // Liste des absences/retards d'aujourd'hui
              ...controller.getAbsencesForToday().map((absence) => 
                _buildAbsenceItemFromAbsence(
                  context: context, 
                  absence: absence, 
                  isSmallScreen: isSmallScreen
                )
              ).toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentProfileWithQR(BuildContext context, bool isSmallScreen, EtudiantController controller) {
    return Obx(() => GestureDetector(
      onTap: () {
        _showFullSizeProfile(context, controller);
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
                      image: _getImageProvider('assets/images/Et1.jpg'),
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
            Text(
              '${controller.prenom.value} ${controller.nom.value}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ismBrownDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Étudiant en ${controller.classe.value}',
              style: const TextStyle(
                fontSize: 14,
                color: ismBrown,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ));
  }

  void _showFullSizeProfile(BuildContext context, EtudiantController controller) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isSmallScreen ? size.width * 0.9 : 500,
                    maxHeight: isSmallScreen ? size.height * 0.7 : 600,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: _getImageProvider('assets/images/Et1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Bouton pour accéder à la carte de l'école
              Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Fermer la boîte de dialogue avec la photo
                      Navigator.of(context).pop();
                      // Ouvrir la page de la carte
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SchoolMapPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.location_on, color: Colors.white),
                    label: const Text('Localiser mon école', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ismOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Déconnexion',
              style: TextStyle(color: ismBrownDark)),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(color: ismBrown)),
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
                // Récupération du contrôleur d'authentification
                final AuthController authController = Get.find<AuthController>();
                
                // Déconnexion de l'utilisateur
                authController.clearUser();
                
                // Fermer la boîte de dialogue
                Navigator.of(context).pop();
                
                // Retour à la page de connexion
                Get.offAllNamed(Routes.LOGIN);
              },
              child: const Text('Oui, déconnecter',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Ajouter cette méthode à la classe
  Widget buildImageWidget(dynamic image) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: _getImageProvider(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Fonction utilitaire pour obtenir le bon ImageProvider selon la plateforme
  ImageProvider _getImageProvider(dynamic image) {
    if (kIsWeb) {
      // Sur le web
      if (image is XFile) {
        return NetworkImage(image.path);
      } else if (image is String) {
        return NetworkImage(image);
      }
      // Fallback pour les autres types sur le web
      return const AssetImage('assets/images/student_photo.jpeg');
    } else {
      // Sur mobile, l'image est un File
      if (image is File) {
        return FileImage(image);
      } else if (image is XFile) {
        return FileImage(File(image.path));
      } else if (image is String) {
        return NetworkImage(image);
      }
    }
    
    // Fallback sur une image par défaut si le type n'est pas reconnu
    return const AssetImage('assets/images/student_photo.jpeg');
  }

  // Méthode pour construire un élément d'interface pour une absence
  Widget _buildAbsenceItemFromAbsence({
    required BuildContext context,
    required Absence absence,
    required bool isSmallScreen,
  }) {
    // Déterminer si l'absence est justifiable (non justifiée et pas en attente)
    final bool canJustify = absence.status.toLowerCase() != 'justifié' && 
                           absence.status.toLowerCase() != 'en attente';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ismBrown.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _showAbsenceDetails(context, absence),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Indicateur de type d'absence (couleur)
                        Container(
                          width: 5,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getAbsenceColor(absence.type ?? ''),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              absence.module,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ismBrownDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${absence.professeur ?? 'Prof'} - ${absence.salle ?? 'Salle'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          absence.heure,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ismBrown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusBadge(absence.status),
                      ],
                    ),
                  ],
                ),
                // Ajout du bouton de justification si applicable
                if (canJustify)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton.icon(
                      onPressed: () => _openJustificationDialog(context, absence),
                      icon: const Icon(Icons.note_add, size: 16),
                      label: const Text('Justifier'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ismOrangeLight,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Méthode pour ouvrir la boite de dialogue de justification
  void _openJustificationDialog(BuildContext context, Absence absence) {
    // Importer le widget JustificationDialog au début du fichier si ce n'est pas déjà fait
    showDialog(
      context: context,
      builder: (context) => JustificationDialog(
        absence: absence,
        onSuccess: () {
          // Rafraîchir les absences après la soumission réussie
          final EtudiantController controller = Get.find<EtudiantController>();
          controller.fetchAbsences();
        },
      ),
    );
  }
  
  // Méthodes utilitaires pour l'affichage des absences
  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (status.toLowerCase()) {
      case 'validée':
      case 'justifié':
        backgroundColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green[700]!;
        icon = Icons.check_circle_outline;
        break;
      case 'en attente':
        backgroundColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange[700]!;
        icon = Icons.access_time;
        break;
      case 'rejetée':
        backgroundColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red[700]!;
        icon = Icons.cancel_outlined;
        break;
      case 'non justifiée':
      case 'non justifié':
        backgroundColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[700]!;
        icon = Icons.error_outline;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[700]!;
        icon = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAbsenceColor(String type) {
    switch (type.toLowerCase()) {
      case 'absence':
        return Colors.red;
      case 'retard':
        return ismOrange;
      case 'sortie anticipée':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  
  void _showAbsenceDetails(BuildContext context, Absence absence) {
    final bool isRetard = absence.type?.toLowerCase() == 'retard';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          isRetard ? 'Détails du retard' : 'Détails de l\'absence',
          style: const TextStyle(color: ismBrownDark),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailItem('Module', absence.module),
            _buildDetailItem('Date', DateFormat('dd/MM/yyyy').format(absence.date)),
            _buildDetailItem('Heure', absence.heure),
            _buildDetailItem('Professeur', absence.professeur ?? 'Non spécifié'),
            _buildDetailItem('Salle', absence.salle ?? 'Non spécifiée'),
            _buildDetailItem('Statut', absence.status),
            if (absence.justification != null && absence.justification!.isNotEmpty)
              _buildDetailItem('Justification', absence.justification!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer', style: TextStyle(color: ismOrange)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ismBrownDark,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: ismBrown),
            ),
          ),
        ],
      ),
    );
  }
}