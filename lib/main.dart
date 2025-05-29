import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/views/pages/etudiant/widgets/etudiant_absence_list.dart';


void main() {
  runApp(const SuiviAbsenceApp());
}

class SuiviAbsenceApp extends StatelessWidget {
  const SuiviAbsenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suivi Absence ISM',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF43291B, {
          // ignore: deprecated_member_use
          50: Color(0xFF43291B).withOpacity(0.1),
          // ignore: deprecated_member_use
          100: Color(0xFF43291B).withOpacity(0.2),
          // ignore: deprecated_member_use
          200: Color(0xFF43291B).withOpacity(0.3),
          // ignore: deprecated_member_use
          300: Color(0xFF43291B).withOpacity(0.4),
          // ignore: deprecated_member_use
          400: Color(0xFF43291B).withOpacity(0.5),
          // ignore: deprecated_member_use
          500: Color(0xFF43291B).withOpacity(0.6),
          // ignore: deprecated_member_use
          600: Color(0xFF43291B).withOpacity(0.7),
          // ignore: deprecated_member_use
          700: Color(0xFF43291B).withOpacity(0.8),
          // ignore: deprecated_member_use
          800: Color(0xFF43291B).withOpacity(0.9),
          900: Color(0xFF43291B),
        }),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF43291B), // Marron foncé ISM
          secondary: const Color(0xFFF89620), // Orange ISM
          surface: const Color(0xFFFAFAFA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF43291B),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF77491C), // Marron ISM
          foregroundColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF43291B),
          contentTextStyle: TextStyle(color: Colors.white),
          actionTextColor: Color(0xFFF89620), // Orange ISM
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Absences ISM'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/images/ism_logo.png'),
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EtudiantAbsenceList(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43291B),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Gérer les Absences',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Navigation vers d'autres fonctionnalités
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF43291B)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Statistiques',
                style: TextStyle(fontSize: 18, color: Color(0xFF43291B)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action supplémentaire
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}