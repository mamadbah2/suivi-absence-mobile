import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/pointage_controller.dart';
import '../../../../data/models/absence.dart';

class AbsencesListWidget extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onRefresh;
  
  const AbsencesListWidget({
    Key? key, 
    required this.accentColor,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PointageController controller = Get.find<PointageController>();
    
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (controller.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Erreur de chargement',
                style: TextStyle(color: Colors.red[700], fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                controller.error.value,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red[500]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualiser'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: accentColor,
                ),
              ),
            ],
          ),
        );
      } else if (controller.absences.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Aucune absence trouvée',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualiser'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: accentColor,
                ),
              ),
            ],
          ),
        );
      } else {
        return RefreshIndicator(
          onRefresh: () async {
            onRefresh();
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.absences.length,
            itemBuilder: (context, index) {
              final absence = controller.absences[index];
              return _buildAbsenceCard(context, absence);
            },
          ),
        );
      }
    });
  }

  Widget _buildAbsenceCard(BuildContext context, Absence absence) {
    final isPresent = absence.status.toLowerCase() == 'present';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isPresent ? Colors.green.shade200 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAbsenceDetails(context, absence),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isPresent ? Colors.green.shade50 : Colors.orange.shade50,
                    child: Icon(
                      isPresent ? Icons.check_circle : Icons.person_outline,
                      color: isPresent ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${absence.prenom} ${absence.nom}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          absence.matricule,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPresent ? Colors.green.shade100 : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isPresent ? 'Présent' : 'Absent',
                      style: TextStyle(
                        color: isPresent ? Colors.green.shade700 : Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.school, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    absence.classe,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.book, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    absence.module,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbsenceDetails(BuildContext context, Absence absence) {
    final isPresent = absence.status.toLowerCase() == 'present';
    final PointageController controller = Get.find<PointageController>();
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isPresent ? Colors.green.shade50 : Colors.orange.shade50,
                    radius: 24,
                    child: Icon(
                      isPresent ? Icons.check_circle : Icons.person_outline,
                      color: isPresent ? Colors.green : Colors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${absence.prenom} ${absence.nom}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          absence.matricule,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Classe:', absence.classe),
              _buildDetailRow('Module:', absence.module),
              _buildDetailRow('Date:', absence.date.toString().split(' ')[0]),
              _buildDetailRow('Heure:', absence.heure),
              _buildDetailRow('Statut:', isPresent ? 'Présent' : 'Absent'),
              const SizedBox(height: 24),
              if (!isPresent)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.marquerPresent(absence.matricule).then((_) {
                        Navigator.pop(context);
                        Get.snackbar(
                          'Succès',
                          'Présence marquée pour ${absence.prenom} ${absence.nom}',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }).catchError((error) {
                        Get.snackbar(
                          'Erreur',
                          'Impossible de marquer l\'étudiant comme présent: $error',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      });
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Marquer présent'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}