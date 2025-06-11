import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controllers/etudiant_controller.dart';
import '../../../../data/models/absence.dart';
import '../../../../data/controllers/auth_controller.dart';
import '../../../../routes/app_pages.dart';
import './all_absences_page.dart';

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
                Obx(() => Text(
                  '${controller.prenom.value} ${controller.nom.value}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ismBrownDark,
                  ),
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  '${controller.classe.value} - ${controller.matricule.value}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: ismBrown,
                  ),
                )),
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
                      Obx(() => QrImageView(
                        data: controller.matricule.value,
                        version: QrVersions.auto,
                        size: 170.0, // Taille réduite pour être cohérent avec l'écran principal
                        gapless: true,
                        foregroundColor: ismBrownDark,
                      )),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        controller.matricule.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ismBrown,
                        ),
                      )),
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

  Widget _buildAbsenceItemFromAbsence({
    required BuildContext context,
    required Absence absence,
    required bool isSmallScreen,
  }) {
    final bool isRetard = absence.type?.toLowerCase() == 'retard';
    final String formattedDate = '${absence.date.day}/${absence.date.month}/${absence.date.year}';
    final String start = absence.heure;
    // Éviter l'erreur si duree est null
    final String end = absence.duree?.split('-').lastOrNull ?? start;
    
    return _buildAbsenceItemWithStatus(
      context: context,
      course: absence.module,
      type: absence.type ?? 'Absence',
      date: formattedDate,
      start: start,
      end: end,
      isRetard: isRetard,
      status: absence.justification,
      statusColor: absence.justification != null ? 
        (absence.justification!.toLowerCase() == 'justifiée' ? Colors.green : Colors.orange) : 
        null,
      isSmallScreen: isSmallScreen,
      absenceId: absence.id,
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
    required String absenceId,
  }) {
    final Color badgeBg =
        isRetard ? ismOrangeLight.withOpacity(0.18) : ismOrange.withOpacity(0.18);
    final Color badgeText = isRetard ? ismOrangeLight : ismOrange;
    final Color borderColor = isRetard ? ismOrangeLight : ismOrange;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        _showAbsenceDetails(context, course, type, date, start, end, isRetard, absenceId);
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
                
                // N'afficher le bouton d'options que pour les absences
                if (!isRetard)
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: ismBrown),
                    onPressed: () {
                      _showJustificationDialog(context, course, absenceId);
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
    String absenceId,
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
                  // Si c'est un retard, prendre toute la largeur avec le bouton Fermer
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
                  
                  // Afficher le bouton Justifier uniquement si ce n'est pas un retard
                  if (!isRetard) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showJustificationDialog(context, course, absenceId);
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

  void _showJustificationDialog(BuildContext context, String courseName, String absenceId) {
    final EtudiantController controller = Get.find<EtudiantController>();
    // Réinitialiser les images sélectionnées à chaque ouverture du dialogue
    controller.clearSelectedImages();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedReason;
        String comment = '';

        return StatefulBuilder(  // Utiliser StatefulBuilder pour mettre à jour l'état dans le dialogue
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Justifier $courseName',
                        style: const TextStyle(
                          color: ismBrownDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Veuillez sélectionner un motif de justification :'),
                      const SizedBox(height: 12),
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
                          setState(() {
                            selectedReason = value;
                          });
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
                      const SizedBox(height: 16),
                      
                      // Section ajout d'images
                      const Text(
                        'Joindre des justificatifs (optionnel) :',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      
                      // Boutons pour ajouter des images
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Bouton galerie
                          OutlinedButton.icon(
                            icon: const Icon(Icons.photo_library, color: ismOrange),
                            label: const Text('Galerie', style: TextStyle(color: ismOrange)),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(color: ismOrange),
                            ),
                            onPressed: () async {
                              await controller.pickImages();
                              setState(() {}); // Rafraîchir pour afficher les images
                            },
                          ),
                          
                          // Bouton appareil photo
                          OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt, color: ismOrange),
                            label: const Text('Caméra', style: TextStyle(color: ismOrange)),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(color: ismOrange),
                            ),
                            onPressed: () async {
                              await controller.takePhoto();
                              setState(() {}); // Rafraîchir pour afficher les images
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Aperçu des images sélectionnées
                      Obx(() => controller.selectedImages.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Images sélectionnées :',
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: FileImage(controller.selectedImages[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.removeImage(index);
                                              setState(() {}); // Rafraîchir l'UI
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(),
                      ),
                      
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.clearSelectedImages(); // Nettoyer les images
                              Navigator.of(context).pop();
                            },
                            child: const Text('Annuler',
                                style: TextStyle(color: ismBrown)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ismOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              // Vérifier si un motif est sélectionné
                              if (absenceId.isNotEmpty && selectedReason != null) {
                                // Afficher un indicateur de chargement pendant l'envoi
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(color: ismOrange),
                                          SizedBox(width: 20),
                                          Text("Envoi en cours...")
                                        ],
                                      ),
                                    );
                                  },
                                );
                                
                                // Envoyer la justification avec le contrôleur
                                final success = await controller.envoyerJustification(
                                  absenceId, 
                                  selectedReason!, 
                                  comment,
                                );
                                
                                // Fermer le dialogue de chargement
                                Navigator.of(context).pop();
                                
                                // Fermer le dialogue de justification
                                Navigator.of(context).pop();
                                
                                // Afficher un message de confirmation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success 
                                      ? 'Justification pour $courseName envoyée avec succès'
                                      : 'Erreur lors de l\'envoi de la justification'),
                                    backgroundColor: success ? Colors.green : Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              } else {
                                // Afficher un message d'erreur si aucun motif n'est sélectionné
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Veuillez sélectionner un motif de justification'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text('Envoyer',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
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
}