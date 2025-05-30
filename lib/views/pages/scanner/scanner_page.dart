import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _handleBarcodeDetection(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? matricule = barcodes.first.rawValue;
      if (matricule != null && matricule.isNotEmpty) {
        print("Matricule scanné: $matricule");
        _scannerController.stop(); // Arrêter le scan après une détection réussie

        // Afficher une pop-up et revenir en arrière avec le matricule
        showDialog(
          context: context,
          barrierDismissible: false, // Empêche de fermer en cliquant à l'extérieur
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Matricule Scanné"),
              content: Text("Le matricule est : $matricule"),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Ferme la pop-up
                    Navigator.of(context).pop(matricule); // Revient à la page PointagePage avec le matricule
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner le QR Code'),
        backgroundColor: const Color(0xFF4A2E20), // Couleur du header de PointagePage
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcodeDetection,
            errorBuilder: (context, error, child) {
              print(error);
              return Center(
                child: Text(
                  'Erreur du scanner: ${error.errorDetails?.message ?? 'Erreur inconnue'}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          // Vous pouvez ajouter une surcouche ici (par exemple, un viseur)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
