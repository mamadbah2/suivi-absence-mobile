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
  bool _isUploading = false;

  @override
  void dispose() {
    _motifController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  // Méthode pour sélectionner des images depuis la galerie (utilise l'upload Supabase)
  Future<void> _pickImages() async {
    setState(() {
      _isUploading = true;
    });
    
    try {
      await _controller.pickImages();
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Méthode pour prendre une photo avec la caméra (utilise l'upload Supabase)
  Future<void> _pickImageFromCamera() async {
    setState(() {
      _isUploading = true;
    });
    
    try {
      await _controller.takePhoto();
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Supprimer une image
  void _removeImage(int index) {
    _controller.removeImage(index);
  }

  // Soumettre la justification avec les URLs des images Supabase
  Future<void> _soumettreJustification() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Utiliser la méthode qui enverra les URLs des images
        final success = await _controller.envoyerJustification(
          widget.absence.id,
          _motifController.text,
          _commentaireController.text,
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
                        onPressed: (_isSubmitting || _isUploading) ? null : _pickImages,
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
                        onPressed: (_isSubmitting || _isUploading) ? null : _pickImageFromCamera,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ismBrown,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Message d'upload
                if (_isUploading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ismOrange),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upload en cours...',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: ismBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Affichage des images sélectionnées avec indicateur de succès
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Compteur d'URLs uploadées
                      if (_controller.uploadedImageUrls.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${_controller.uploadedImageUrls.length} image(s) prête(s) à être envoyée(s)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      // Liste des images
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _controller.selectedImages.length,
                          itemBuilder: (context, index) {
                            final bool isUploaded = index < _controller.uploadedImageUrls.length;
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
                                    border: Border.all(
                                      color: isUploaded ? Colors.green : Colors.grey.shade400,
                                      width: isUploaded ? 2 : 1,
                                    ),
                                  ),
                                ),
                                // Indicateur d'upload réussi
                                if (isUploaded)
                                  const Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                // Bouton de suppression
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: (_isSubmitting || _isUploading) ? null : () => _removeImage(index),
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
                      ),
                    ],
                  );
                }),
                
                const SizedBox(height: 24),

                // Boutons d'actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: (_isSubmitting || _isUploading)
                          ? null
                          : () {
                              _controller.clearSelectedImages();
                              Navigator.of(context).pop();
                            },
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: (_isSubmitting || _isUploading) ? null : _soumettreJustification,
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