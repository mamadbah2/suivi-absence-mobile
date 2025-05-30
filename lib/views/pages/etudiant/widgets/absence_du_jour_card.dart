import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/models/absence.dart';

class AbsenceDuJourCard extends StatelessWidget {
  final Absence absence;
  final VoidCallback? onToggleAbsence;

  const AbsenceDuJourCard({
    Key? key,
    required this.absence,
    this.onToggleAbsence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  absence.module,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B3926),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        absence.status == 'Justifié'
                            ? Colors.green
                            : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    absence.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(absence.heure, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            if (absence.justification.isNotEmpty) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.note, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Justification: ${absence.justification}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ],
            if (absence.status != 'Justifié') ...[
              SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implémenter la logique de justification
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Justifier l\'absence'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Motif de l\'absence',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Implémenter l'upload du justificatif
                                  },
                                  child: Text('Ajouter un justificatif'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Annuler'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Sauvegarder la justification
                                  Navigator.pop(context);
                                },
                                child: Text('Valider'),
                              ),
                            ],
                          ),
                    );
                  },
                  icon: Icon(Icons.edit_note),
                  label: Text('Justifier l\'absence'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B3926),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
