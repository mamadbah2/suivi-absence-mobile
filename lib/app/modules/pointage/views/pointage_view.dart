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
            // Section Filtres
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Barre de recherche
                    TextField(
                      onChanged: controller.updateSearch,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un étudiant...',
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
                    // Filtres supplémentaires
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
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: ismOrange),
                          onPressed: () => _showFilterDialog(context),
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
              child: Obx(() => ListView.separated(
                    itemCount: controller.filteredEtudiants.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: ismOrangeLight),
                    itemBuilder: (context, index) {
                      final etudiant = controller.filteredEtudiants[index];
                      return _buildStudentItem(etudiant);
                    },
                  )),
            ),

            // Boutons d'action
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Enregistrer',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ismBrown,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => controller.savePointage(),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ismBrownDark),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('Annuler',
                        style: TextStyle(color: ismBrownDark)),
                  ),
                ],
              ),
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
        trailing: Container(
          width: 120,
          child: DropdownButton<String>(
            value: etudiant.status,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: ismBrownLight),
            items: <String>['Présent', 'Absent', 'Retard'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(
                      color: value == 'Présent'
                          ? Colors.green
                          : value == 'Absent'
                              ? Colors.red
                              : Colors.orange,
                    )),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.updateEtudiantStatus(etudiant.matricule, newValue);
              }
            },
            underline: Container(
              height: 1,
              color: ismOrangeLight,
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer par période',
            style: TextStyle(color: ismBrownDark)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => CheckboxListTile(
                  title: const Text('Aujourd\'hui'),
                  value: controller.selectedFilter.value == 'Aujourd\'hui',
                  activeColor: ismOrange,
                  onChanged: (bool? value) {
                    if (value == true) {
                      controller.updateFilter('Aujourd\'hui');
                      Get.back();
                    }
                  },
                )),
            Obx(() => CheckboxListTile(
                  title: const Text('Cette semaine'),
                  value: controller.selectedFilter.value == 'Cette semaine',
                  activeColor: ismOrange,
                  onChanged: (bool? value) {
                    if (value == true) {
                      controller.updateFilter('Cette semaine');
                      Get.back();
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
