import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Créer le contrôleur avec torche désactivée par défaut
  late final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // Commencer avec la caméra arrière par défaut
    facing: CameraFacing.back,
    // Formats pris en charge par le scanner
    formats: const [BarcodeFormat.qrCode],
  );

  bool _isProcessing = false;
  bool _isTorchOn = false; // Pour suivre l'état de la torche

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner le Code QR'),
        actions: [
          // Bouton pour activer/désactiver la torche
          IconButton(
            color: Colors.white,
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? Colors.yellow : Colors.grey,
            ),
            iconSize: 32.0,
            onPressed: () {
              controller.toggleTorch();
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          ),
          // Bouton pour changer de caméra
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.cameraswitch),
            iconSize: 32.0,
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scanner de code QR
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isProcessing) return;

              final List<Barcode> barcodes = capture.barcodes;

              if (barcodes.isNotEmpty) {
                setState(() {
                  _isProcessing = true;
                });

                final String? scannedValue = barcodes.first.rawValue;

                if (scannedValue != null && scannedValue.isNotEmpty) {
                  print("QR Code Scanné: $scannedValue");
                  // Retourner la valeur scannée à la page précédente
                  Navigator.pop(context, scannedValue);
                } else {
                  // Gérer le cas où le code QR est vide
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code QR non valide ou vide.')),
                  );
                  setState(() {
                    _isProcessing = false; // Permettre d'autres scans
                  });
                }
              }
            },
          ),
          // Overlay pour indiquer la zone de scan
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
