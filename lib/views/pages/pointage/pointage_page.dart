import 'package:flutter/material.dart';

class PointagePage extends StatelessWidget {
  const PointagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pointage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Bienvenue sur la page de pointage',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Action de pointage ici
              },
              child: const Text('Pointer'),
            ),
          ],
        ),
      ),
    );
  }
}