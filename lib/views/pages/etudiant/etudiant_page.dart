import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/etudiant_controller.dart';
import '../../../controllers/absence_controller.dart';
import '../../../models/absence.dart';
import 'widgets/student_home_header.dart';
import 'widgets/student_info_card.dart';
import 'widgets/absence_stats_row.dart';
import 'widgets/course_card.dart';
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
                  Column(
                    children: [
                      AbsenceDuJourCard(
                        absence: Absence(
                          id: "1",
                          nom: "John",
                          prenom: "Doe",
                          classe: "L1",
                          module: "Mathématiques",
                          date: DateTime.now(),
                          heure: "08:00-10:00",
                          status: "Non justifié",
                          justification: "",
                          justificatif: "",
                        ),
                        onToggleAbsence: () {},
                      ),
                      AbsenceDuJourCard(
                        absence: Absence(
                          id: "2",
                          nom: "John",
                          prenom: "Doe",
                          classe: "L1",
                          module: "Physique",
                          date: DateTime.now(),
                          heure: "10:30-12:30",
                          status: "Justifié",
                          justification: "Certificat médical",
                          justificatif: "certificat.pdf",
                        ),
                        onToggleAbsence: () {},
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      "Cours du jour",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B3926),
                      ),
                    ),
                  ),
                  ...controller.courses.map(
                    (course) => CourseCard(
                      title: course['title'],
                      type: course['type'],
                      date: course['date'],
                      time: course['time'],
                      professeur: course['professeur'],
                      salle: course['salle'],
                      module: course['module'],
                      isJustified: course['isJustified'],
                      justification: course['justification'],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
