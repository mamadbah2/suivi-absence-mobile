import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/controllers/auth_controller.dart';

class CustomHeaderPointage extends StatelessWidget {
  final Color headerColor = const Color(0xFF4A2E20);
  final Color accentColor = const Color(0xFFD4A017);
  final Color textColor = Colors.white;

  const CustomHeaderPointage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupérer le contrôleur d'authentification
    final AuthController authController = Get.find<AuthController>();
    
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
              const SizedBox(width: 40), // Espace pour équilibrer la suppression du logo
              // Infos Utilisateur & Déconnexion
              Row(
                children: [
                  // Utilisation d'Obx pour observer les changements de l'utilisateur connecté
                  Obx(() {
                    final user = authController.currentUser.value;
                    final displayName = user != null 
                        ? "${user.prenom} ${user.nom}"
                        : "Utilisateur";
                    
                    return Text(
                      displayName,
                      style: TextStyle(color: textColor, fontSize: 16),
                    );
                  }),
                  const SizedBox(width: 8),
                  // Ajout d'un InkWell/GestureDetector pour rendre l'icône cliquable
                  GestureDetector(
                    onTap: () {
                      // Utilisation de Get.offAllNamed pour rediriger vers la page login
                      // et effacer toute la pile de navigation
                      Get.offAllNamed('/login');
                      print("Déconnexion... Redirection vers la page login");
                    },
                    child: Icon(Icons.logout, color: accentColor, size: 24),
                  ),
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
                    // Action pour fermer, par exemple Navigator.pop(context) si c'est une modale/nouvelle page
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
