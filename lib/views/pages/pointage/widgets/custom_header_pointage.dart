import 'package:flutter/material.dart';

class CustomHeaderPointage extends StatelessWidget {
  final Color headerColor = const Color(0xFF4A2E20);
  final Color accentColor = const Color(0xFFD4A017);
  final Color textColor = Colors.white;

  const CustomHeaderPointage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo ISM (Supprimé)
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0),
              //   child: Icon(Icons.calendar_today, color: accentColor, size: 30),
              // ),
              const SizedBox(width: 40), // Espace pour équilibrer la suppression du logo
              // Infos Utilisateur & Déconnexion
              Row(
                children: [
                  Text(
                    "Amadou Diaw",
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.logout, color: accentColor, size: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Titre "POINTAGE ETUDIANTS" et Icône "X"
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  "POINTAGE ETUDIANTS",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    print("Close button clicked");
                    // Action pour fermer, par exemple Navigator.pop(context) si c\'est une modale/nouvelle page
                  },
                  child: CircleAvatar(
                    backgroundColor: accentColor,
                    radius: 15,
                    child: Icon(Icons.close, color: headerColor, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
