import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentInfoCard extends StatelessWidget {
  final String title;
  final String filiere;
  final String matricule;
  final String qrData;

  const StudentInfoCard({
    Key? key,
    required this.title,
    required this.filiere,
    required this.matricule,
    required this.qrData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF5B3926),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 4),
          Text(filiere, style: TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(height: 4),
          Text(
            matricule,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap:
                () => Get.toNamed(
                  '/qrcode',
                  arguments: {
                    'studentName': matricule.split('-')[0],
                    'studentMatricule': matricule,
                    'photoUrl': 'assets/images/student_photo.jpg',
                  },
                ),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 100.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
