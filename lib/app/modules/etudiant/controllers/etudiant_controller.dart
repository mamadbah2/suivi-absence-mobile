import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../data/models/absence.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../data/providers/etudiant_provider.dart';

class EtudiantController extends GetxController {
  final RxList<Absence> mesAbsences = <Absence>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final AuthController _authController = Get.find<AuthController>();
  final EtudiantProvider _etudiantProvider = Get.find<EtudiantProvider>();

  // Modifier la liste pour qu'elle puisse contenir les deux types (File et XFile)
  RxList<dynamic> selectedImages = RxList<dynamic>([]);

  // Stats des absences
  final RxInt absenceCumulee = 31.obs; // en heures
  final RxInt absenceSoumise = 2.obs;
  final RxInt retardsCumules = 8.obs;
  final RxInt absenceRestante = 41.obs;

  // Infos étudiant
  final RxString nom = ''.obs;
  final RxString prenom = ''.obs;
  final RxString classe = 'Licence 2 CLRS'.obs;
  final RxString matricule = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    initialiserInfosEtudiant();
    chargerAbsences();
  }

  void initialiserInfosEtudiant() {
    // Récupérer les informations de l'utilisateur connecté
    if (_authController.currentUser.value != null) {
      nom.value = _authController.currentUser.value!.nom;
      prenom.value = _authController.currentUser.value!.prenom;
      matricule.value = _authController.currentUser.value?.matricule ?? 'DK-30352';
    } else {
      // Valeurs par défaut si aucun utilisateur n'est connecté
      nom.value = 'Diallo';
      prenom.value = 'Mamadou';
      matricule.value = 'DK-30352';
    }
  }
  
  // Modification du type de retour de void à Future<void>
  Future<void> chargerAbsences() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Récupérer les absences depuis l'API
      final absences = await _etudiantProvider.getAbsencesEtudiant(matricule.value);
      
      // Compléter les informations manquantes dans les absences
      final List<Absence> absencesCompletes = absences.map((absence) => 
        absence.copyWith(
          nom: nom.value,
          prenom: prenom.value,
          classe: classe.value
        )
      ).toList();
      
      mesAbsences.assignAll(absencesCompletes);
      
    } catch (e) {
      error.value = "Erreur lors du chargement des absences: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour sélectionner des images depuis la galerie
  Future<void> pickImages() async {
    try {
      final List<XFile>? images = await ImagePicker().pickMultiImage(
        imageQuality: 70, // Réduire la qualité pour optimiser la taille
        maxWidth: 1000,
      );
      
      if (images != null && images.isNotEmpty) {
        // Ajouter les nouvelles images sélectionnées à la liste
        for (var image in images) {
          if (kIsWeb) {
            // Sur le web, on stocke directement l'objet XFile
            selectedImages.add(image);
          } else {
            // Sur mobile, on peut utiliser File
            selectedImages.add(File(image.path));
          }
        }
      }
    } catch (e) {
      print('Erreur lors de la sélection d\'images: $e');
    }
  }

  // Méthode pour prendre une photo avec la caméra
  Future<void> takePhoto() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1000,
      );
      
      if (photo != null) {
        if (kIsWeb) {
          // Sur le web, on stocke directement l'objet XFile
          selectedImages.add(photo);
        } else {
          // Sur mobile, on peut utiliser File
          selectedImages.add(File(photo.path));
        }
      }
    } catch (e) {
      print('Erreur lors de la prise de photo: $e');
    }
  }

  // Supprimer une image de la liste des images sélectionnées
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // Vider la liste des images sélectionnées
  void clearSelectedImages() {
    selectedImages.clear();
  }

  // Méthodes pour la justification des absences
  Future<bool> envoyerJustification(
      String absenceId, String motif, String commentaire, [List<dynamic>? images]) async {
    try {
      // Utiliser les images passées en paramètre ou les images sélectionnées
      final dynamicImages = images ?? selectedImages;
      
      // Convertir les images en List<File> comme attendu par l'API
      List<File> imageFiles = [];
      for (var img in dynamicImages) {
        if (img is File) {
          imageFiles.add(img);
        } else if (img is XFile) {
          imageFiles.add(File(img.path));
        }
      }
      
      // Afficher des informations de débogage
      print('Envoi de justification pour absence ID: $absenceId');
      print('Motif: $motif');
      print('Nombre d\'images jointes: ${imageFiles.length}');
      
      // Appeler l'API pour envoyer la justification avec les images
      final success = await _etudiantProvider.soumettreJustificationAvecImages(
        absenceId, 
        motif, 
        commentaire, 
        imageFiles,
      );
      
      // Si succès, vider les images et rafraîchir les données
      if (success) {
        clearSelectedImages();
        await fetchAbsences(); // Rafraîchir les absences
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de l\'envoi de la justification: $e');
      return false;
    }
  }

  // Méthode pour mettre à jour une justification sans image
  Future<bool> updateJustification(String absenceId, String justification) async {
    try {
      print('Mise à jour de la justification pour absence ID: $absenceId');
      print('Justification: $justification');
      
      // Appeler l'API pour mettre à jour la justification sans image
      final success = await _etudiantProvider.updateAbsenceJustification(
        absenceId, 
        justification,
      );
      
      // Si succès, rafraîchir les données
      if (success) {
        await fetchAbsences(); // Rafraîchir les absences
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la mise à jour de la justification: $e');
      return false;
    }
  }

  // Obtenir les absences pour aujourd'hui uniquement  
  List<Absence> getAbsencesForToday() {
    final today = DateTime.now();
    return mesAbsences.where((absence) => 
      absence.date.year == today.year && 
      absence.date.month == today.month && 
      absence.date.day == today.day
    ).toList();
  }
  
  // Rafraîchir les données - maintenant le await fonctionne correctement
  Future<void> refreshAbsences() async {
    await chargerAbsences();
  }

  // Méthode pour rafraîchir les absences (utilisée après l'envoi d'une justification)
  Future<void> fetchAbsences() async {
    await chargerAbsences();
  }

  // Méthode pour construire le widget d'image approprié selon la plateforme
  Widget buildImageWidget(dynamic image, {BoxFit fit = BoxFit.cover}) {
    if (kIsWeb) {
      if (image is XFile) {
        // Pour le web, on utilise NetworkImage avec l'URL de l'image
        return Image.network(
          image.path,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => 
            Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            ),
        );
      } else if (image is Uint8List) {
        // Si l'image est déjà en bytes (Uint8List) pour le web
        return Image.memory(
          image,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => 
            Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            ),
        );
      } else {
        // Fallback pour d'autres types sur le web
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported, size: 50),
        );
      }
    } else {
      // Pour les plateformes mobiles
      if (image is File) {
        return Image.file(
          image,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => 
            Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            ),
        );
      } else if (image is XFile) {
        return Image.file(
          File(image.path),
          fit: fit,
          errorBuilder: (context, error, stackTrace) => 
            Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50),
            ),
        );
      } else {
        // Fallback pour d'autres types sur mobile
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported, size: 50),
        );
      }
    }
  }

  // Nouvelle méthode pour obtenir l'ImageProvider selon la plateforme
  ImageProvider getImageProvider(dynamic image) {
    if (kIsWeb) {
      if (image is XFile) {
        return NetworkImage(image.path);
      } else if (image is Uint8List) {
        return MemoryImage(image);
      } else if (image is String) {
        // Pour les URL sur le web
        return NetworkImage(image);
      } else {
        // Fallback - image placeholder
        return const AssetImage('assets/images/logo.png');
      }
    } else {
      if (image is File) {
        return FileImage(image);
      } else if (image is XFile) {
        return FileImage(File(image.path));
      } else if (image is String) {
        // Vérifie si c'est une URL ou un chemin de fichier local
        if (image.startsWith('http')) {
          return NetworkImage(image);
        } else {
          return FileImage(File(image));
        }
      } else if (image is Uint8List) {
        // Ajout du support pour Uint8List sur mobile
        return MemoryImage(image);
      } else {
        // Fallback - image placeholder
        return const AssetImage('assets/images/logo.png');
      }
    }
  }
}