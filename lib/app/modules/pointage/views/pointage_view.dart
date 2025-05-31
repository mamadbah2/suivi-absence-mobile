import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';
import '../../../core/theme/colors.dart';

class PointageView extends GetView<PointageController> {
  const PointageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pointage des Étudiants',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ismBrownDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section Recherche
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Champ de recherche par matricule
                    TextField(
                      onChanged: controller.updateMatricule,
                      decoration: InputDecoration(
                        hintText: 'Entrer le matricule de l\'étudiant...',
                        prefixIcon: const Icon(Icons.search, color: ismBrown),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: ismBrownLight),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filtre par classe
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => DropdownButtonFormField<String>(
                                value: controller.selectedClasse.value,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: controller.classes
                                    .map((classe) => DropdownMenuItem(
                                          value: classe,
                                          child: Text(classe),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.updateClasse(value);
                                  }
                                },
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Liste des étudiants
            Expanded(
              child: Obx(() {
                if (controller.filteredEtudiants.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun étudiant trouvé',
                      style: TextStyle(
                        fontSize: 16,
                        color: ismBrownDark,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: controller.filteredEtudiants.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: ismOrangeLight),
                  itemBuilder: (context, index) {
                    final etudiant = controller.filteredEtudiants[index];
                    return _buildStudentItem(etudiant);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentItem(dynamic etudiant) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ismOrange,
          child: Text(
            '${etudiant.nom.substring(0, 1)}${etudiant.prenom.substring(0, 1)}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          '${etudiant.nom} ${etudiant.prenom}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ismBrownDark,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matricule: ${etudiant.matricule}'),
            Text('Classe: ${etudiant.classe}'),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                etudiant.status == 'Présent' ? Colors.green : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => controller.markPresent(etudiant.matricule),
          child: Text(
            etudiant.status,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
