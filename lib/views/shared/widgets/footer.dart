import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2024 Suivi Absence',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.home, size: 20),
                onPressed: () {
                  // Naviguer vers la page d'accueil
                  Navigator.of(context).pushNamed('/home');
                },
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, size: 20),
                onPressed: () {
                  // Naviguer vers la page à propos
                  Navigator.of(context).pushNamed('/about');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}