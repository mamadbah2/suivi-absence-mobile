import 'package:get/get.dart';
import '../models/absence.dart';

class EtudiantController extends GetxController {
  // Informations de l'étudiant (à adapter selon ton backend)
  var nom = ''.obs;
  var prenom = ''.obs;
  var classe = ''.obs;

  // Liste des absences
  var absences = <Absence>[].obs;

  // États de chargement et d’erreur
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Exemple de chargement des données (à remplacer par un appel API plus tard)
  Future<void> fetchAbsences() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simule une réponse du backend
      await Future.delayed(Duration(seconds:1));
      List<Absence> fetched = [
        Absence(
          id: '1',
          nom: 'Ndiaye',
          prenom: 'Anna',
          classe: 'Licence 2 GLRS',
          module: 'Développement Flutter',
          date: DateTime(2024, 3, 14),
          heure: '8h - 12h',
          status: 'Absence',
          justification: 'Non justifiée',
          justificatif: '',
        ),
        Absence(
          id: '2',
          nom: 'Ndiaye',
          prenom: 'Anna',
          classe: 'Licence 2 GLRS',
          module: 'Gestion de Projet',
          date: DateTime(2024, 3, 14),
          heure: '13h - 15h',
          status: 'Absence',
          justification: 'Justifiée',
          justificatif: 'certificat.pdf',
        ),
      ];

      absences.assignAll(fetched);

      // Met à jour les infos de l'étudiant à partir de la première absence (exemple)
      if (fetched.isNotEmpty) {
        nom.value = fetched[0].nom;
        prenom.value = fetched[0].prenom;
        classe.value = fetched[0].classe;
      }
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des absences';
    } finally {
      isLoading.value = false;
    }
  }
}