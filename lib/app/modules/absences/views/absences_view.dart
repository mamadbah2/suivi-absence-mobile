import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/absences_controller.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/absence_model.dart';

class AbsencesView extends GetView<AbsencesController> {
  const AbsencesView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: ismCream,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentProfileWithQR(context, isSmallScreen),
            _buildStatistics(),
            const SizedBox(height: 24),
            _buildFilterSection(),
            const SizedBox(height: 12),
            _buildAbsencesList(isSmallScreen),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
      actions: const [
        Padding(
          padding:  EdgeInsets.only(right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:  [
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
    );
  }

  Widget _buildStudentProfileWithQR(BuildContext context, bool isSmallScreen) {
    return GestureDetector(
      onTap: () => _showFullSizeProfile(context),
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
                  child: const Icon(Icons.qr_code, color: ismOrange, size: 20),
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

  Widget _buildStatistics() {
    return Container(
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
        children:  [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text('Absence cumulée',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
              SizedBox(height: 8),
              Text('Absence soumise',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
              SizedBox(height: 8),
              Text('Retards cumulés',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
              SizedBox(height: 8),
              Text('Absence restante',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
            ],
          ),
          Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${controller.absenceCumulee}h',
                      style: const TextStyle(
                          color: ismOrange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${controller.absenceSoumise}h',
                      style: const TextStyle(
                          color: ismOrange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${controller.retardsCumules}h',
                      style: const TextStyle(
                          color: ismOrange, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${controller.absenceRestante}h',
                      style: const TextStyle(
                          color: ismBrownDark, fontWeight: FontWeight.bold)),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: ismBrownDark, size: 20),
          const SizedBox(width: 8),
          Obx(() => DropdownButton<String>(
                value: controller.selectedPeriod.value,
                items: ['Aujourd\'hui', 'Cette semaine', 'Ce mois', 'Tout']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.setPeriodFilter(newValue);
                  }
                },
              )),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: ismOrange),
            onSelected: (String value) {
              if (['Tous', 'Retards', 'Absences'].contains(value)) {
                controller.setTypeFilter(value);
              } else {
                controller.setStatusFilter(value);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'Tous',
                child: Text('Tous les types'),
              ),
              const PopupMenuItem(
                value: 'Retards',
                child: Text('Retards uniquement'),
              ),
              const PopupMenuItem(
                value: 'Absences',
                child: Text('Absences uniquement'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'Tous',
                child: Text('Tous les statuts'),
              ),
              const PopupMenuItem(
                value: 'Justifiée',
                child: Text('Justifiées'),
              ),
              const PopupMenuItem(
                value: 'Non justifiée',
                child: Text('Non justifiées'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbsencesList(bool isSmallScreen) {
    return Obx(() => Column(
          children: controller.filteredAbsences.map((absence) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildAbsenceItem(
                context: Get.context!,
                absence: absence,
                isSmallScreen: isSmallScreen,
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildAbsenceItem({
    required BuildContext context,
    required AbsenceModel absence,
    required bool isSmallScreen,
  }) {
    final Color badgeBg = absence.isRetard
        ? ismOrangeLight.withOpacity(0.18)
        : ismOrange.withOpacity(0.18);
    final Color badgeText = absence.isRetard ? ismOrangeLight : ismOrange;
    final Color borderColor = absence.isRetard ? ismOrangeLight : ismOrange;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showAbsenceDetails(context, absence),
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
                    absence.cours,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: ismBrownDark,
                    ),
                  ),
                ),
                if (absence.status != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (absence.status == 'Justifiée'
                              ? Colors.green
                              : Colors.orange)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: absence.status == 'Justifiée'
                              ? Colors.green
                              : Colors.orange),
                    ),
                    child: Text(
                      absence.status!,
                      style: TextStyle(
                        color: absence.status == 'Justifiée'
                            ? Colors.green
                            : Colors.orange,
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
                        absence.isRetard ? Icons.schedule : Icons.event_busy,
                        color: badgeText,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${absence.type} • ${absence.date}',
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
                Text(
                  '${absence.heureDebut} - ${absence.heureFin}',
                  style: TextStyle(
                    color: ismBrown,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: ismBrown),
                  onPressed: () => _showJustificationDialog(context, absence),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ismOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAbsenceDetails(BuildContext context, AbsenceModel absence) {
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
                absence.cours,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ismBrownDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.calendar_today, 'Date', absence.date),
              _buildDetailRow(
                absence.isRetard ? Icons.schedule : Icons.event_busy,
                'Type',
                absence.type,
              ),
              _buildDetailRow(
                Icons.access_time,
                'Heures',
                '${absence.heureDebut} - ${absence.heureFin}',
              ),
              _buildDetailRow(Icons.person, 'Professeur', absence.professeur),
              _buildDetailRow(Icons.location_on, 'Salle', absence.salle),
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
                        side: const BorderSide(color: ismOrange),
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
                        _showJustificationDialog(context, absence);
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

  void _showJustificationDialog(BuildContext context, AbsenceModel absence) {
    String? selectedReason;
    String comment = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Justifier ${absence.cours}',
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
                    value: 'Maladie',
                    child: Text('Maladie'),
                  ),
                  DropdownMenuItem(
                    value: 'Problème familial',
                    child: Text('Problème familial'),
                  ),
                  DropdownMenuItem(
                    value: 'Problème de transport',
                    child: Text('Problème de transport'),
                  ),
                  DropdownMenuItem(
                    value: 'Autre',
                    child: Text('Autre'),
                  ),
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
              child: const Text('Annuler', style: TextStyle(color: ismBrown)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ismOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (selectedReason != null) {
                  controller.submitJustification(
                    absence.id,
                    selectedReason!,
                    comment.isNotEmpty ? comment : null,
                  );
                } else {
                  Get.snackbar(
                    'Erreur',
                    'Veuillez sélectionner un motif',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child:
                  const Text('Envoyer', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
