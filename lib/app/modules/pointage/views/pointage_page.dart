import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';
import './widgets/custom_header_pointage.dart';
import 'widgets/scanner_page.dart'; // Corrected import path
import '../../../data/models/absence.dart';

class PointagePage extends StatefulWidget {
  const PointagePage({Key? key}) : super(key: key);

  @override
  _PointagePageState createState() => _PointagePageState();
}

class _PointagePageState extends State<PointagePage> {
  final Color pageBackgroundColor = const Color.fromARGB(255, 255, 255, 255);
  final Color buttonColor = const Color(0xFF4A2E20);
  final Color accentColor = const Color(0xFFD4A017);
  final Color buttonTextColor = Colors.white;

  final TextEditingController _matriculeController = TextEditingController();
  final PointageController _pointageController = Get.find<PointageController>();

  Absence? _absenceTrouvee;
  String? _messageErreur;

  void _rechercherEtMarquerPresent(String matricule) async { // Combined search and mark present
    if (matricule.isEmpty) {
      setState(() {
        _absenceTrouvee = null;
        _messageErreur = "Le matricule ne peut pas être vide.";
      });
      return;
    }

    final absence = _pointageController.getAbsenceByMatricule(matricule);
    setState(() {
      _absenceTrouvee = absence;
      if (absence == null) {
        _messageErreur = "Aucun étudiant trouvé pour ce matricule.";
      } else {
        _messageErreur = null;
        // Si l'étudiant est trouvé et est absent, le marquer présent
        if (absence.status == 'absent') {
          _pointageController.marquerPresent(matricule).then((_) {
            // Rafraîchir l'affichage de _absenceTrouvee pour refléter le nouveau statut
            setState(() {
              _absenceTrouvee = _pointageController.getAbsenceByMatricule(matricule);
            });
            Get.snackbar(
              'Succès',
              'Pointage effectué pour ${_absenceTrouvee!.prenom} ${_absenceTrouvee!.nom}',
              snackPosition: SnackPosition.BOTTOM,
            );
          }).catchError((error) {
             setState(() {
              // En cas d'erreur lors du marquage, _absenceTrouvee peut toujours être l'ancien état
              // ou vous pouvez choisir de le réinitialiser.
              _messageErreur = "Erreur lors du marquage présent: $error";
            });
            Get.snackbar(
              'Erreur',
              'Impossible de marquer l\'étudiant comme présent: $error',
              snackPosition: SnackPosition.BOTTOM,
            );
          });
        } else if (absence.status == 'present') {
           Get.snackbar(
              'Info',
              '${_absenceTrouvee!.prenom} ${_absenceTrouvee!.nom} est déjà marqué(e) présent(e).',
              snackPosition: SnackPosition.BOTTOM,
            );
        }
      }
    });
  }

  // Conserver _rechercherAbsence pour la recherche manuelle si besoin
   void _rechercherAbsenceManuelle(String matricule) {
    if (matricule.isEmpty) {
      setState(() {
        _absenceTrouvee = null;
        _messageErreur = null;
      });
      return;
    }
    final absence = _pointageController.getAbsenceByMatricule(matricule);
    setState(() {
      _absenceTrouvee = absence;
      _messageErreur = (absence == null) ? "Aucun étudiant trouvé pour ce matricule." : null;
    });
  }

  // La méthode _marquerPresent est maintenant appelée depuis _rechercherEtMarquerPresent
  // ou par le bouton si l'étudiant a été trouvé par recherche manuelle.
  void _marquerPresentManuellement() {
    if (_absenceTrouvee == null || _absenceTrouvee!.status == 'present') return;
    _pointageController.marquerPresent(_absenceTrouvee!.matricule).then((_){
        setState(() {
          _absenceTrouvee = _pointageController.getAbsenceByMatricule(_absenceTrouvee!.matricule);
        });
        Get.snackbar(
          'Succès',
          'Pointage effectué pour ${_absenceTrouvee!.prenom} ${_absenceTrouvee!.nom}',
          snackPosition: SnackPosition.BOTTOM,
        );
    }).catchError((error){
        Get.snackbar(
          'Erreur',
          'Impossible de marquer l\'étudiant comme présent: $error',
          snackPosition: SnackPosition.BOTTOM,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: Column(
        children: [
          const CustomHeaderPointage(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _matriculeController,
                              decoration: InputDecoration(
                                hintText: "Rechercher un étudiant par matricule...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey[600]),
                              ),
                              onSubmitted: (value) {
                                _rechercherAbsenceManuelle(value); // Recherche manuelle
                              },
                              onChanged: (value) {
                                if (_absenceTrouvee != null || _messageErreur != null) {
                                  setState(() {
                                    _absenceTrouvee = null;
                                    _messageErreur = null;
                                  });
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search, color: accentColor, size: 28),
                            onPressed: () {
                              _rechercherAbsenceManuelle(_matriculeController.text); // Recherche manuelle
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                      label: Text(
                        'SCANNER ET MARQUER PRÉSENT',
                        style: TextStyle(color: buttonTextColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 16, // Adjusted font size
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        final matriculeScanne = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(builder: (context) => const ScannerPage()),
                        );
                        if (matriculeScanne != null && matriculeScanne.isNotEmpty) {
                          _matriculeController.text = matriculeScanne; // Optionnel: afficher le matricule scanné
                          _rechercherEtMarquerPresent(matriculeScanne); // Recherche et marque présent
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    // Affichage du résultat de la recherche
                    if (_matriculeController.text.isNotEmpty && _absenceTrouvee != null) // Condition pour afficher la carte
                        Card(
                          elevation: 4,
                          color: const Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informations de l\'étudiant:',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Text('Matricule: ${_absenceTrouvee!.matricule}', style: const TextStyle(color: Colors.black87)),
                                Text('Nom: ${_absenceTrouvee!.nom}', style: const TextStyle(color: Colors.black87)),
                                Text('Prénom: ${_absenceTrouvee!.prenom}', style: const TextStyle(color: Colors.black87)),
                                Text('Classe: ${_absenceTrouvee!.classe}', style: const TextStyle(color: Colors.black87)),
                                Text('Module: ${_absenceTrouvee!.module}', style: const TextStyle(color: Colors.black87)),
                                Text(
                                  'Statut: ${_absenceTrouvee!.status.toUpperCase()}',
                                  style: TextStyle(
                                    color: _absenceTrouvee!.status == 'present' ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Bouton pour marquer présent manuellement si l'étudiant est trouvé et absent
                                if (_absenceTrouvee!.status == 'absent')
                                  Center(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: accentColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      icon: const Icon(Icons.check_circle_outline),
                                      label: const Text('Marquer Présent Manuellement'),
                                      onPressed: _marquerPresentManuellement,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                    else if (_messageErreur != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _messageErreur!,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}