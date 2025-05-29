import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String type;
  final String date;
  final String time;
  final String professeur;
  final String salle;
  final String module;
  final bool isJustified;
  final String? justification;

  const CourseCard({
    Key? key,
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.professeur,
    required this.salle,
    required this.module,
    required this.isJustified,
    this.justification,
  }) : super(key: key);

  Color _getStatusColor() {
    if (type.contains('Présent')) return Colors.green;
    if (type.contains('Retard')) return Colors.orange;
    return isJustified ? Colors.blue : Colors.red;
  }

  IconData _getStatusIcon() {
    if (type.contains('Présent')) return Icons.check_circle;
    if (type.contains('Retard')) return Icons.timer;
    return isJustified ? Icons.check_circle : Icons.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getStatusIcon(), color: _getStatusColor(), size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      module,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.menu_book, color: Color(0xFF5B3926)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(professeur, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(salle, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text('$date - $time', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          if (justification != null && justification!.isNotEmpty) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Justification: $justification',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
