import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/etudiant_controller.dart';
import './widgets/etudiant_absence_list.dart';

class EtudiantPage extends StatelessWidget {
  const EtudiantPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Nous utilisons directement le widget EtudiantAbsenceList comme vue principale
    // Ce widget contient déjà toutes les fonctionnalités nécessaires
    return const EtudiantAbsenceList();
  }
}