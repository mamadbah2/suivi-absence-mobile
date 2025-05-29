import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String type;
  final String date;
  final String time;
  final bool isJustified;

  const CourseCard({
    Key? key,
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.isJustified,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isJustified ? Icons.check_circle : Icons.cancel,
            color: isJustified ? Colors.green : Colors.red,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  type,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.menu_book, color: Color(0xFF5B3926)),
        ],
      ),
    );
  }
}
