import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/etudiant_controller.dart';
import '../../../../data/models/absence.dart';
import 'absence_item_widget.dart';

// Définition des couleurs ISM avec des nuances améliorées
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);

class AllAbsencesPage extends StatelessWidget {
  const AllAbsencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EtudiantController controller = Get.find<EtudiantController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: ismBrownDark,
        title: const Text(
          'Toutes mes absences',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: ismOrange));
        }
        
        if (controller.mesAbsences.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aucune absence enregistrée !',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vous n\'avez aucune absence pour le moment.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        // Trier les absences par date (du plus récent au plus ancien)
        final sortedAbsences = controller.mesAbsences.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        return RefreshIndicator(
          onRefresh: controller.refreshAbsences,
          color: ismOrange,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedAbsences.length,
            itemBuilder: (context, index) {
              final absence = sortedAbsences[index];
              return AbsenceItemWidget(
                absence: absence,
                onTap: (absence) => _showAbsenceDetails(context, absence),
              );
            },
          ),
        );
      }),
    );
  }

  void _showAbsenceDetails(BuildContext context, Absence absence) {
    final bool isRetard = absence.type?.toLowerCase() == 'retard';
    final String formattedDate = '${absence.date.day}/${absence.date.month}/${absence.date.year}';

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
                absence.module,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ismBrownDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.calendar_today, 'Date', formattedDate),
              _buildDetailRow(
                  isRetard ? Icons.schedule : Icons.event_busy,
                  'Type',
                  absence.type ?? 'Absence'),
              _buildDetailRow(Icons.access_time, 'Heures', absence.heure),
              _buildDetailRow(Icons.person, 'Professeur', absence.professeur ?? 'Non spécifié'),
              _buildDetailRow(Icons.location_on, 'Salle', absence.salle ?? 'Non spécifiée'),
              if (absence.justification != null) 
                _buildDetailRow(Icons.comment, 'Statut', absence.justification!),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ismOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Fermer', style: TextStyle(color: Colors.white)),
                ),
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
}