import 'package:flutter/material.dart';

class PointageEtudiantSearch extends StatelessWidget {
  final Color accentColor = const Color(0xFFD4A017);
  final Color searchFieldBackgroundColor = const Color(0xFFE0E0E0);

  const PointageEtudiantSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: searchFieldBackgroundColor,
        borderRadius: BorderRadius.circular(30.0), // Forme de pilule
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un étudiant...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              onChanged: (value) {
                print("Search term: $value");
              },
            ),
          ),
          Icon(Icons.search, color: accentColor, size: 28),
        ],
      ),
    );
  }
}
