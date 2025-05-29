import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/absence_controller.dart';
import '../etudiant/widgets/absence_du_jour_card.dart';

class HistoriqueAbsencesPage extends StatelessWidget {
  final AbsenceController absenceController = Get.find<AbsenceController>();
  final String matricule = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // Charger l'historique des absences au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      absenceController.getHistoriqueAbsences(matricule);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des absences'),
        backgroundColor: Color(0xFF5B3926),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
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

        if (absenceController.historiqueAbsences.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Aucune absence enregistrée",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await absenceController.getHistoriqueAbsences(matricule);
          },
          child: ListView.builder(
            itemCount: absenceController.historiqueAbsences.length,
            itemBuilder: (context, index) {
              final absence = absenceController.historiqueAbsences[index];
              return AbsenceDuJourCard(
                absence: absence,
                onToggleAbsence:
                    () =>
                        absenceController.toggleAbsence(int.parse(absence.id)),
              );
            },
          ),
        );
      }),
    );
  }
}
