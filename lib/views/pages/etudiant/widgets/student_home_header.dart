import 'package:flutter/material.dart';

class StudentHomeHeader extends StatelessWidget {
  final String studentName;
  final String photoUrl;
  final VoidCallback onLogout;

  const StudentHomeHeader({
    Key? key,
    required this.studentName,
    required this.photoUrl,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF5B3926),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.calendar_month, color: Colors.white),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                studentName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Vous pouvez ajouter la filière ici si besoin
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}
