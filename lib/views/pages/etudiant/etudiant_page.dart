import 'package:flutter/material.dart';
import 'widgets/student_home_header.dart';
import 'widgets/student_info_card.dart';
import 'widgets/absence_stats_row.dart';
import 'widgets/today_section.dart';

class EtudiantHomePage extends StatelessWidget {
  const EtudiantHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StudentHomeHeader(
                studentName: "Anna Ndiaye",
                photoUrl: "assets/images/student_photo.jpg",
                onLogout: () {
                  // TODO: Implémenter la déconnexion
                },
              ),
              StudentInfoCard(
                title: "Absence-Retard",
                filiere: "Licence 2 GLRS",
                matricule: "DK-30352",
                qrData: "DK-30352",
              ),
              AbsenceStatsRow(
                stats: [
                  {"label": "Absence cum.", "value": "31h"},
                  {"label": "Absence journée", "value": "2h"},
                  {"label": "Retard cum.", "value": "8h"},
                  {"label": "Absence restantes", "value": "41h"},
                ],
              ),
              TodaySection(
                courses: [
                  {
                    "title": "Developpement Flutter",
                    "type": "Absence | Non justifiée",
                    "date": "14/03/2024",
                    "time": "8h - 12h",
                    "isJustified": "false",
                  },
                  {
                    "title": "Gestion de Projet",
                    "type": "Absence | Justifiée",
                    "date": "14/03/2024",
                    "time": "13h - 15h",
                    "isJustified": "true",
                  },
                  {
                    "title": "Developpement Flutter",
                    "type": "Retard | Non justifié",
                    "date": "14/03/2024",
                    "time": "16h - 18h",
                    "isJustified": "false",
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
