import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/absence.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../data/providers/etudiant_provider.dart';

class EtudiantController extends GetxController {
  final RxList<Absence> mesAbsences = <Absence>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final AuthController _authController = Get.find<AuthController>();
  final EtudiantProvider _etudiantProvider = Get.find<EtudiantProvider>();
  final ImagePicker _picker = ImagePicker();
  final RxList<File> selectedImages = <File>[].obs;

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
      final List<XFile>? images = await _picker.pickMultiImage(
        imageQuality: 70, // Réduire la qualité pour optimiser la taille
        maxWidth: 1000,
      );
      
      if (images != null && images.isNotEmpty) {
        // Ajouter les nouvelles images sélectionnées à la liste
        for (var image in images) {
          selectedImages.add(File(image.path));
        }
      }
    } catch (e) {
      print('Erreur lors de la sélection d\'images: $e');
    }
  }

  // Méthode pour prendre une photo avec la caméra
  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1000,
      );
      
      if (photo != null) {
        selectedImages.add(File(photo.path));
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
      String absenceId, String motif, String commentaire, [List<File>? images]) async {
    try {
      // Utiliser les images passées en paramètre ou les images sélectionnées
      final imagesToSend = images ?? selectedImages;
      
      // Afficher des informations de débogage
      print('Envoi de justification pour absence ID: $absenceId');
      print('Motif: $motif');
      print('Nombre d\'images jointes: ${imagesToSend.length}');
      
      // Appeler l'API pour envoyer la justification avec les images
      final success = await _etudiantProvider.soumettreJustificationAvecImages(
        absenceId, 
        motif, 
        commentaire,
        imagesToSend
      );
      
      if (success) {
        // Trouver et mettre à jour l'absence dans la liste locale
        final index = mesAbsences.indexWhere((absence) => absence.id == absenceId);
        if (index != -1) {
          final absence = mesAbsences[index];
          final updatedAbsence = absence.copyWith(
            justification: 'En attente',
            // Ajouter le nombre d'images jointes dans le statut pour information
            status: imagesToSend.isNotEmpty ? 'En attente (${imagesToSend.length} justificatifs)' : 'En attente'
          );
          
          mesAbsences[index] = updatedAbsence;
          
          // Vider la liste des images après l'envoi réussi
          clearSelectedImages();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Erreur lors de l\'envoi de la justification: $e');
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
}