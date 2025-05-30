import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/views/pages/qrcode/widgets/student_header.dart';
import 'package:suivi_absence_mobile/views/pages/qrcode/widgets/qr_code_card.dart';

class QrCodePage extends StatelessWidget {
  final String studentName;
  final String studentMatricule;
  final String photoUrl;

  const QrCodePage({
    Key? key,
    required this.studentName,
    required this.studentMatricule,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            StudentHeader(
              studentName: studentName,
              photoUrl: photoUrl,
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 32),
            QrCodeCard(data: studentMatricule),
          ],
        ),
      ),
    );
  }
}
