import 'dart:io';
import 'dart:convert'; // Ajout pour la conversion Base64
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../data/models/absence.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../data/providers/etudiant_provider.dart';
import '../../../data/services/supabase_service.dart'; // Import du service Supabase

class EtudiantController extends GetxController {
  final RxList<Absence> mesAbsences = <Absence>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final AuthController _authController = Get.find<AuthController>();
  final EtudiantProvider _etudiantProvider = Get.find<EtudiantProvider>();

  // Modifier la liste pour qu'elle puisse contenir les deux types (File et XFile)
  RxList<dynamic> selectedImages = RxList<dynamic>([]);

  // Liste pour stocker les URLs des images uploadées sur Supabase
  RxList<String> uploadedImageUrls = RxList<String>([]);

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
        print('\n========= DÉBUT UPLOAD IMAGES GALERIE (${images.length}) =========');
        
        // Uploader les images sur Supabase immédiatement
        for (var image in images) {
          // Ajouter l'image à la liste pour affichage temporaire
          if (kIsWeb) {
            selectedImages.add(image);
          } else {
            selectedImages.add(File(image.path));
          }
          
          // Upload de l'image sur Supabase
          final url = await SupabaseService.uploadImage(image);
          if (url != null) {
            uploadedImageUrls.add(url);
            print('\n✅ IMAGE UPLOADÉE AVEC SUCCÈS:');
            print('📋 URL: $url');
            print('📊 Total URLs disponibles: ${uploadedImageUrls.length}');
          } else {
            print('\n❌ ÉCHEC UPLOAD IMAGE');
          }
        }
        
        // Afficher toutes les URLs
        print('\n📊 RÉCAPITULATIF DES URLS:');
        for (int i = 0; i < uploadedImageUrls.length; i++) {
          print('   URL #${i+1}: ${uploadedImageUrls[i]}');
        }
        print('========= FIN UPLOAD IMAGES =========\n');
      }
    } catch (e) {
      print('\n❌ ERREUR UPLOAD: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
        print('\n========= DÉBUT UPLOAD PHOTO CAMÉRA =========');
        
        // Ajouter la photo à la liste pour affichage temporaire
        if (kIsWeb) {
          selectedImages.add(photo);
        } else {
          selectedImages.add(File(photo.path));
        }
        
        // Upload de l'image sur Supabase
        final url = await SupabaseService.uploadImage(photo);
        if (url != null) {
          uploadedImageUrls.add(url);
          print('\n✅ PHOTO UPLOADÉE AVEC SUCCÈS:');
          print('📋 URL: $url');
          print('📊 Total URLs disponibles: ${uploadedImageUrls.length}');
        } else {
          print('\n❌ ÉCHEC UPLOAD PHOTO');
        }
        
        // Afficher toutes les URLs
        print('\n📊 RÉCAPITULATIF DES URLS:');
        for (int i = 0; i < uploadedImageUrls.length; i++) {
          print('   URL #${i+1}: ${uploadedImageUrls[i]}');
        }
        print('========= FIN UPLOAD PHOTO =========\n');
      }
    } catch (e) {
      print('\n❌ ERREUR UPLOAD PHOTO: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de prendre une photo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Supprimer une image de la liste des images sélectionnées
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      // Supprimer également l'URL correspondante si disponible
      if (index < uploadedImageUrls.length) {
        uploadedImageUrls.removeAt(index);
      }
    }
  }

  // Vider la liste des images sélectionnées
  void clearSelectedImages() {
    selectedImages.clear();
    uploadedImageUrls.clear();
  }

  // Méthodes pour la justification des absences avec URLs d'images Supabase
  Future<bool> envoyerJustification(
      String absenceId, String motif, String commentaire, [List<dynamic>? images]) async {
    try {
      // Utiliser les URLs d'images uploadées
      final urls = uploadedImageUrls;
      
      print('\n========= ENVOI DE JUSTIFICATION AU BACKEND =========');
      print('📝 Absence ID: $absenceId');
      print('📝 Motif: $motif');
      print('📝 Commentaire: $commentaire');
      print('🖼️ Nombre d\'URLs d\'images: ${urls.length}');
      
      if (urls.isNotEmpty) {
        print('\n📤 URLS DES IMAGES ENVOYÉES AU BACKEND:');
        for (int i = 0; i < urls.length; i++) {
          print('   URL #${i+1}: ${urls[i]}');
        }
      }
      
      // Appeler l'API pour envoyer la justification avec les URLs des images
      final success = await _etudiantProvider.soumettreJustificationAvecUrls(
        absenceId, 
        motif, 
        commentaire, 
        urls,
      );
      
      // Si succès, vider les images et rafraîchir les données
      if (success) {
        print('\n✅ JUSTIFICATION ENVOYÉE AVEC SUCCÈS');
        clearSelectedImages();
        await fetchAbsences(); // Rafraîchir les absences
        return true;
      } else {
        print('\n❌ ÉCHEC DE L\'ENVOI DE LA JUSTIFICATION');
        return false;
      }
    } catch (e) {
      print('\n❌ ERREUR LORS DE L\'ENVOI DE LA JUSTIFICATION: $e');
      return false;
    } finally {
      print('========= FIN ENVOI JUSTIFICATION =========\n');
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