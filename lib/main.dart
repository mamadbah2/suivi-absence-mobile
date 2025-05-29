import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/views/pages/etudiant/etudiant_page.dart';
import 'package:suivi_absence_mobile/views/pages/justification/justification_page.dart';
import 'package:suivi_absence_mobile/views/pages/login/login_page.dart';
import 'package:suivi_absence_mobile/views/pages/pointage/pointage_page.dart';
import 'package:suivi_absence_mobile/views/pages/qrcode/qrcode_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suivi Absence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        "/pointage": (context) => PointagePage(),
        "/login": (context) => LoginPage(),
        "/justification": (context) => JustificationPage(),
        "/qrcode": (context) => QrCodePage(
              studentName: "Issa KABORE",
              studentMatricule: "DK-30352",
              photoUrl: "assets/images/student_photo.jpeg",
            ),
      },
      home: EtudiantHomePage(),
    );
  }
}
