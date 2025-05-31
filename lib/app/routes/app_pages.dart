import 'package:get/get.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/etudiant/bindings/etudiant_binding.dart';
import '../modules/etudiant/views/etudiant_view.dart';
import '../modules/justification/bindings/justification_binding.dart';
import '../modules/justification/views/justification_view.dart';
import '../modules/absences/bindings/absences_binding.dart';
import '../modules/absences/views/absences_view.dart';
import '../modules/pointage/bindings/pointage_binding.dart';
import '../modules/pointage/views/pointage_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.ETUDIANT,
      page: () => const EtudiantView(),
      binding: EtudiantBinding(),
    ),
    GetPage(
      name: Routes.JUSTIFICATION,
      page: () => const JustificationView(),
      binding: JustificationBinding(),
    ),
    GetPage(
      name: Routes.ABSENCES,
      page: () => const AbsencesView(),
      binding: AbsencesBinding(),
    ),
    GetPage(
      name: Routes.POINTAGE,
      page: () => const PointageView(),
      binding: PointageBinding(),
    ),
  ];
}
