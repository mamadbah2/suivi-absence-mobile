import 'package:get/get.dart';
import '../models/etudiant_model.dart';

class EtudiantProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://votre-api.com/';
    print('EtudiantProvider initialized');
    super.onInit();
  }

  Future<Response> getEtudiantInfo(String email) async {
    print('EtudiantProvider: Récupération des informations de l\'étudiant');
    // Simulation d'un appel API en développement
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      body: {
        'id': '1',
        'nom': 'Doe',
        'prenom': 'John',
        'email': email,
        'classe': 'Classe A',
        'absences': ['2024-01-15', '2024-02-01'],
      },
      statusCode: 200,
    );
  }

  Future<Response> justifierAbsence(
    String absenceId,
    String justification,
  ) async {
    print('EtudiantProvider: Envoi de la justification');
    // Simulation d'un appel API
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      body: {'message': 'Justification enregistrée'},
      statusCode: 200,
    );
  }

  Future<Response> getAbsences(String etudiantId) async {
    print('EtudiantProvider: Récupération des absences');
    // Simulation d'un appel API
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      body: [
        {
          'id': '1',
          'date': '2024-01-15',
          'cours': 'Mathématiques',
          'justifie': false,
        },
        {
          'id': '2',
          'date': '2024-02-01',
          'cours': 'Physique',
          'justifie': true,
        },
      ],
      statusCode: 200,
    );
  }
}
