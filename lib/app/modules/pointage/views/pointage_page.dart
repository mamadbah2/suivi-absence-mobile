import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suivi_absence_mobile/app/modules/pointage/views/widgets/scanner_page.dart';
import '../controllers/pointage_controller.dart';
import './widgets/custom_header_pointage.dart';
import '../../../data/models/absence.dart';
import '../../marquage/views/marquage_presence_page.dart'; // Import de la nouvelle page

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

  // Nouvelle méthode qui recherche un étudiant en utilisant l'API
  Future<void> _rechercherEtudiantAPI(String matricule) async {
    if (matricule.isEmpty) {
      setState(() {
        _absenceTrouvee = null;
        _messageErreur = "Le matricule ne peut pas être vide.";
      });
      return;
    }

    setState(() {
      _messageErreur = "Recherche en cours...";
      _absenceTrouvee = null;
    });

    try {
      // Utiliser la nouvelle méthode qui fait appel à l'API
      final absence = await _pointageController.rechercherEtudiantParMatricule(matricule);
      
      setState(() {
        _absenceTrouvee = absence;
        if (absence == null) {
          _messageErreur = "Aucun étudiant trouvé pour ce matricule.";
        } else {
          _messageErreur = null;
          // Si l'étudiant est trouvé et est absent, naviguer vers la page de détail
          if (absence.status == 'absent') {
            // Navigation différée pour permettre la mise à jour de l'état d'abord
            Future.microtask(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarquagePresencePage(
                    absence: absence,
                    onPresenceMarked: () {
                      // Cette fonction sera appelée après que l'étudiant ait été marqué présent
                      setState(() {
                        // Rafraîchir l'état après marquage
                        _absenceTrouvee = _pointageController.getAbsenceByMatricule(matricule);
                      });
                    },
                  ),
                ),
              );
            });
          } else if (absence.status == 'present') {
            Get.snackbar(
              'Info',
              '${absence.prenom} ${absence.nom} est déjà marqué(e) présent(e).',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      });
    } catch (e) {
      setState(() {
        _messageErreur = "Erreur lors de la recherche: $e";
      });
      Get.snackbar(
        'Erreur',
        'Problème lors de la recherche: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // void _rechercherEtMarquerPresent(String matricule) async { // Combined search and mark present
  //   if (matricule.isEmpty) {
  //     setState(() {
  //       _absenceTrouvee = null;
  //       _messageErreur = "Le matricule ne peut pas être vide.";
  //     });
  //     return;
  //   }

  //   final absence = _pointageController.getAbsenceByMatricule(matricule);
  //   setState(() {
  //     _absenceTrouvee = absence;
  //     if (absence == null) {
  //       _messageErreur = "Aucun étudiant trouvé pour ce matricule.";
  //     } else {
  //       _messageErreur = null;
  //       // Si l'étudiant est trouvé et est absent, le marquer présent
  //       if (absence.status == 'absent') {
  //         _pointageController.marquerPresent(matricule).then((_) {
  //           // Rafraîchir l'affichage de _absenceTrouvee pour refléter le nouveau statut
  //           setState(() {
  //             _absenceTrouvee = _pointageController.getAbsenceByMatricule(matricule);
  //           });
  //           Get.snackbar(
  //             'Succès',
  //             'Pointage effectué pour ${_absenceTrouvee!.prenom} ${_absenceTrouvee!.nom}',
  //             snackPosition: SnackPosition.BOTTOM,
  //           );
  //         }).catchError((error) {
  //            setState(() {
  //             // En cas d'erreur lors du marquage, _absenceTrouvee peut toujours être l'ancien état
  //             // ou vous pouvez choisir de le réinitialiser.
  //             _messageErreur = "Erreur lors du marquage présent: $error";
  //           });
  //           Get.snackbar(
  //             'Erreur',
  //             'Impossible de marquer l\'étudiant comme présent: $error',
  //             snackPosition: SnackPosition.BOTTOM,
  //           );
  //         });
  //       } else if (absence.status == 'present') {
  //          Get.snackbar(
  //             'Info',
  //             '${_absenceTrouvee!.prenom} ${_absenceTrouvee!.nom} est déjà marqué(e) présent(e).',
  //             snackPosition: SnackPosition.BOTTOM,
  //           );
  //       }
  //     }
  //   });
  // }

  void _rechercherEtAfficherDetails(String matricule) {
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
        // Si l'étudiant est trouvé et est absent, naviguer vers la page de détail
        if (absence.status == 'absent') {
          // Utiliser Navigator.push au lieu de Get.to pour conserver la navigation native
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MarquagePresencePage(
                absence: absence,
                onPresenceMarked: () {
                  // Cette fonction sera appelée après que l'étudiant ait été marqué présent
                  // Mettre à jour l'état local et montrer une notification
                  setState(() {
                    // Rafraîchir l'état après marquage
                    _absenceTrouvee = _pointageController.getAbsenceByMatricule(matricule);
                  });
                },
              ),
            ),
          );
        } else if (absence.status == 'present') {
          Get.snackbar(
            'Info',
            '${absence.prenom} ${absence.nom} est déjà marqué(e) présent(e).',
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

  void _pointerEtudiant(String matricule) async {
    try {
      await _pointageController.marquerPresent(matricule);
      setState(() {
        _absenceTrouvee = _pointageController.getAbsenceByMatricule(matricule);
      });
      Get.snackbar(
        'Succès',
        'Pointage effectué pour ${_absenceTrouvee!.prenom} ${_absenceTrouvee!.nom}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de pointer l\'étudiant: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // En-tête personnalisé
            const CustomHeaderPointage(),
            // Contenu principal avec défilement
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 200, // Hauteur minimale contrainte
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Important pour éviter l'expansion infinie
                      children: [
                        // Barre de recherche
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
                                    _rechercherEtudiantAPI(value);
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
                                  _rechercherEtudiantAPI(_matriculeController.text);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Bouton scanner
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
                              fontSize: 16,
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
                              _matriculeController.text = matriculeScanne;
                              _rechercherEtudiantAPI(matriculeScanne);
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        // Carte de résultat
                        if (_matriculeController.text.isNotEmpty && _absenceTrouvee != null)
                          Card(
                            elevation: 4,
                            color: const Color(0xFFF5F5F5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min, // Important pour éviter l'expansion infinie
                                children: [
                                  Text(
                                    'Informations de l\'étudiant:',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Matricule: ${_absenceTrouvee!.matricule}', style: const TextStyle(color: Colors.black87)),
                                  Text('Nom: ${_absenceTrouvee!.nom}', style: const TextStyle(color: Colors.black87)),
                                  Text('Prénom: ${_absenceTrouvee!.prenom}', style: const TextStyle(color: Colors.black87)),
                                  Text('Module: ${_absenceTrouvee!.module}', style: const TextStyle(color: Colors.black87)),
                                  Text(
                                    'Statut: ${_absenceTrouvee!.status.toUpperCase()}',
                                    style: TextStyle(
                                      color: _absenceTrouvee!.status == 'present' ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Bouton pour pointer
                                  Center(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _absenceTrouvee!.status == 'present' ? Colors.grey : accentColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      icon: Icon(_absenceTrouvee!.status == 'present' ? Icons.check_circle : Icons.person_add),
                                      label: Text(_absenceTrouvee!.status == 'present' ? 'Déjà pointé' : 'Pointer l\'étudiant'),
                                      onPressed: _absenceTrouvee!.status == 'present' 
                                        ? null // Désactiver le bouton si déjà présent
                                        : () => _pointerEtudiant(_absenceTrouvee!.matricule),
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
                        // Espace supplémentaire en bas pour éviter que le contenu soit caché par les barres système
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}