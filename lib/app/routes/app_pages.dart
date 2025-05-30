import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pointage/bindings/pointage_binding.dart';
import '../modules/pointage/views/pointage_page.dart';
import '../modules/marquage/bindings/marquage_binding.dart';

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
      page: () => const PointagePage(),
      binding: PointageBinding(),
    ),
    GetPage(
      name: _Paths.MARQUAGE,
      page: () {
        // Cette route est utilisée principalement pour le binding
        // Normalement, MarquagePresencePage sera affichée via Navigator.push avec les paramètres appropriés
        // Mais pour satisfaire le système de routes, on fournit une page par défaut qui sera redirigée
        Get.toNamed(_Paths.POINTAGE);
        return Container(); // Page placeholder qui ne sera jamais affichée
      },
      binding: MarquageBinding(),
    )
  ];
}