import 'package:flutter/material.dart';

class PointageEtudiantList extends StatelessWidget {
  const PointageEtudiantList({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final List<Map<String, String>> etudiants = [
      {
        'nom': 'DIOP',
        'prenom': 'Aminata',
        'matricule': 'MAT2023001',
        'classe': 'L3 Informatique'
      },
      {
        'nom': 'NDIAYE',
        'prenom': 'Moussa',
        'matricule': 'MAT2023002',
        'classe': 'L3 Informatique'
      },
      {
        'nom': 'SOW',
        'prenom': 'Fatou',
        'matricule': 'MAT2023003',
        'classe': 'L3 Informatique'
      },
      {
        'nom': 'BA',
        'prenom': 'Ibrahima',
        'matricule': 'MAT2023004',
        'classe': 'L3 Informatique'
      },
      {
        'nom': 'GUEYE',
        'prenom': 'Aissatou',
        'matricule': 'MAT2023005',
        'classe': 'L3 Informatique'
      },
      // Ajoutez d'autres étudiants ici...
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(args?['etudiantNom'] != null 
            ? 'Pointage: ${args!['etudiantNom']}' 
            : 'Pointage des Étudiants'),
        backgroundColor: const Color(0xFF43291B),
        foregroundColor: Colors.white,
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un étudiant...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF77491C)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFB56E1E)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Color(0xFFF89620)),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section Liste
            Expanded(
              child: ListView.separated(
                itemCount: etudiants.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFDA841F)),
                itemBuilder: (context, index) {
                  return _buildStudentItem(etudiants[index], index);
                },
              ),
            ),

            // Section Actions
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF77491C),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _saveData(context),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF43291B)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler', style: TextStyle(color: Color(0xFF43291B))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentItem(Map<String, String> etudiant, int index) {
    String dropdownValue = 'Présent';
    
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF89620),
          child: Text(
            '${etudiant['nom']?.substring(0, 1)}${etudiant['prenom']?.substring(0, 1)}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          '${etudiant['nom']} ${etudiant['prenom']}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF43291B)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matricule: ${etudiant['matricule']}'),
            Text('Classe: ${etudiant['classe']}'),
          ],
        ),
        trailing: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFB56E1E)),
          items: <String>['Présent', 'Absent', 'Retard'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Color(0xFF43291B))),
            );
          }).toList(),
          onChanged: (String? newValue) {
            dropdownValue = newValue!;
          },
          underline: Container(
            height: 1,
            color: const Color(0xFFDA841F),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer', style: TextStyle(color: Color(0xFF43291B))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Aujourd\'hui'),
              value: true,
              activeColor: const Color(0xFFF89620),
              onChanged: (_) {},
            ),
            CheckboxListTile(
              title: const Text('Cette semaine'),
              value: false,
              activeColor: const Color(0xFFF89620),
              onChanged: (_) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('APPLIQUER', style: TextStyle(color: Color(0xFF43291B))),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _saveData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Données enregistrées avec succès!'),
        backgroundColor: const Color(0xFF43291B),
        action: SnackBarAction(
          label: 'OK',
          textColor: const Color(0xFFF89620),
          onPressed: () {},
        ),
      ),
    );
  }
}