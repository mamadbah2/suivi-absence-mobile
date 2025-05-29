import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/main.dart';
import 'package:suivi_absence_mobile/views/pages/login/login_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated
        ? const HomePage()
        : const LoginPage();
  }
}