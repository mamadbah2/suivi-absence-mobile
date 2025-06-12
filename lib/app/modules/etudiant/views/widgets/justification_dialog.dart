import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suivi_absence_mobile/app/data/models/absence.dart';
import '../../controllers/etudiant_controller.dart';

// Définition des couleurs ISM avec des nuances améliorées
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);
const Color ismBrownLight = Color(0xFFb56e1e);
const Color ismOrangeLight = Color(0xFFda841f);

class JustificationDialog extends StatefulWidget {
  final Absence absence;
  final Function onSuccess;

  const JustificationDialog({
    Key? key,
    required this.absence,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<JustificationDialog> createState() => _JustificationDialogState();
}

class _JustificationDialogState extends State<JustificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _motifController = TextEditingController();
  final _commentaireController = TextEditingController();
  final _controller = Get.find<EtudiantController>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _motifController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    await _controller.pickImages();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (kIsWeb) {
          _controller.selectedImages.add(image);
        } else {
          _controller.selectedImages.add(File(image.path));
        }
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'accéder à l\'appareil photo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _removeImage(int index) {
    _controller.removeImage(index);
  }

  Future<void> _soumettreJustification() async {
    if (_formKey.currentState!.validate()) {
      if (_controller.selectedImages.isEmpty) {
        // Demander confirmation si aucune image n'est jointe
        final shouldContinue = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Aucun justificatif'),
            content: const Text('Vous n\'avez joint aucune image. Voulez-vous continuer sans justificatif ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continuer'),
              ),
            ],
          ),
        );
        
        if (shouldContinue != true) return;
      }
      
      setState(() {
        _isSubmitting = true;
      });

      try {
        final success = await _controller.envoyerJustification(
          widget.absence.id,
          _motifController.text,
          _commentaireController.text,
          _controller.selectedImages, // Transmettre explicitement les images sélectionnées
        );

        if (success) {
          Navigator.of(context).pop();
          widget.onSuccess();
          
          Get.snackbar(
            'Justification envoyée',
            'Votre justification a été envoyée avec succès.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Erreur',
            'Impossible d\'envoyer la justification.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Une erreur est survenue: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du dialogue
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: ismOrangeLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.note_add, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Justifier une absence',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ismBrownDark,
                            ),
                          ),
                          Text(
                            'Cours: ${widget.absence.module}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Champ du motif
                TextFormField(
                  controller: _motifController,
                  decoration: InputDecoration(
                    labelText: 'Motif*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.subject, color: ismBrown),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un motif';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ du commentaire (optionnel)
                TextFormField(
                  controller: _commentaireController,
                  decoration: InputDecoration(
                    labelText: 'Commentaire (optionnel)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.comment, color: ismBrown),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Section pour les images de justificatifs
                const Text(
                  'Justificatifs (images)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ismBrown,
                  ),
                ),
                const SizedBox(height: 8),

                // Boutons pour ajouter des images
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Galerie'),
                        onPressed: _isSubmitting ? null : _pickImages,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ismBrown,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Appareil photo'),
                        onPressed: _isSubmitting ? null : _pickImageFromCamera,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ismBrown,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Affichage des images sélectionnées
                Obx(() {
                  if (_controller.selectedImages.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Aucune image sélectionnée',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8, top: 8, left: 2),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: _controller.getImageProvider(_controller.selectedImages[index]),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _isSubmitting ? null : () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Boutons d'actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              _controller.clearSelectedImages();
                              Navigator.of(context).pop();
                            },
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _soumettreJustification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ismOrange,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Soumettre'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}