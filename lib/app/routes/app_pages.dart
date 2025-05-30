import 'package:get/get.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pointage/bindings/pointage_binding.dart';
import '../modules/pointage/views/pointage_page.dart'; // Correction du chemin d'importation

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;
  

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.POINTAGE,
      page: () => const PointagePage(), // Correction du nom de classe
      binding: PointageBinding(),
    )
  ];
}