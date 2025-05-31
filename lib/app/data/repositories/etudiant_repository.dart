import 'package:get/get.dart';
import '../models/etudiant_model.dart';
import '../providers/etudiant_provider.dart';

class EtudiantRepository {
  final EtudiantProvider _etudiantProvider = Get.find<EtudiantProvider>();

  Future<EtudiantModel?> getEtudiantInfo(String email) async {
    try {
      final response = await _etudiantProvider.getEtudiantInfo(email);
      if (response.status.isOk) {
        return EtudiantModel.fromJson(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des informations: $e');
      return null;
    }
  }

  Future<bool> justifierAbsence(String absenceId, String justification) async {
    try {
      final response = await _etudiantProvider.justifierAbsence(
        absenceId,
        justification,
      );
      return response.status.isOk;
    } catch (e) {
      print('Erreur lors de la justification: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAbsences(String etudiantId) async {
    try {
      final response = await _etudiantProvider.getAbsences(etudiantId);
      if (response.status.isOk) {
        return List<Map<String, dynamic>>.from(response.body);
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des absences: $e');
      return [];
    }
  }
}
