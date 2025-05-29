import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/etudiant_controller.dart';
import 'widgets/student_home_header.dart';
import 'widgets/student_info_card.dart';
import 'widgets/absence_stats_row.dart';
import 'widgets/course_card.dart';

class EtudiantHomePage extends StatelessWidget {
  final EtudiantController controller = Get.put(EtudiantController());

  @override
  Widget build(BuildContext context) {
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
            onRefresh: controller.refreshData,
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
                      "Aujourd'hui",
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
