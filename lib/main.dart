import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/pages/etudiant/etudiant_page.dart';
import 'views/pages/historique_absences/historique_absences_page.dart';
import 'views/pages/justification/justification_page.dart';
import 'views/pages/login/login_page.dart';
import 'views/pages/pointage/pointage_page.dart';
import 'views/pages/qrcode/qrcode_page.dart';
import 'services/etudiant_service.dart';

void main() {
  // Initialiser les services
  Get.put(EtudiantService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Suivi Absence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        "/pointage": (context) => PointagePage(),
        "/login": (context) => LoginPage(),
        "/justification": (context) => JustificationPage(),
        "/historique-absences": (context) => HistoriqueAbsencesPage(),
        "/qrcode":
            (context) => QrCodePage(
              studentName: "Anna",
              studentMatricule: "DK-30352",
              photoUrl: "assets/images/student_photo.jpeg",
            ),
      },
      home: EtudiantHomePage(),
    );
  }
}
