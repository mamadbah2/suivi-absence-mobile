import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/etudiant_controller.dart';
import '../../../controllers/absence_controller.dart';
import 'widgets/student_home_header.dart';
import 'widgets/student_info_card.dart';
import 'widgets/absence_stats_row.dart';
import 'widgets/absence_du_jour_card.dart';

class EtudiantHomePage extends StatelessWidget {
  final EtudiantController controller = Get.put(EtudiantController());
  final AbsenceController absenceController = Get.put(AbsenceController());

  @override
  Widget build(BuildContext context) {
    // Charger les absences au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.matricule.value.isNotEmpty) {
        absenceController.getAbsencesDuJour(controller.matricule.value);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage.value),
                  ElevatedButton(
                    onPressed: controller.refreshData,
                    child: Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
              await absenceController.getAbsencesDuJour(
                controller.matricule.value,
              );
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StudentHomeHeader(
                    studentName: controller.studentName.value,
                    photoUrl: controller.photoUrl.value,
                    onLogout: controller.handleLogout,
                  ),
                  StudentInfoCard(
                    title: "Absence-Retard",
                    filiere: controller.filiere.value,
                    matricule: controller.matricule.value,
                    qrData: controller.matricule.value,
                  ),
                  AbsenceStatsRow(stats: controller.stats),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      "Absences du jour",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B3926),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (absenceController.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (absenceController.error != null) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            absenceController.error!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    if (absenceController.absencesDuJour.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Aucune absence aujourd'hui",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children:
                          absenceController.absencesDuJour.map((absence) {
                            return AbsenceDuJourCard(
                              absence: absence,
                              onToggleAbsence:
                                  () => absenceController.toggleAbsence(
                                    int.parse(absence.id),
                                  ),
                            );
                          }).toList(),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
