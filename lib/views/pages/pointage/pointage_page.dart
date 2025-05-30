import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart'; // Supprimé car le QR code n'est plus affiché ici
import './widgets/custom_header_pointage.dart';
import '../scanner/scanner_page.dart'; // Importer la nouvelle page de scan
import '../../../services/etudiant_service.dart'; // Pour la recherche d'étudiant
import '../../../models/etudiant.dart'; // Pour le modèle Etudiant

class PointagePage extends StatefulWidget { // Changé en StatefulWidget
  const PointagePage({Key? key}) : super(key: key);

  @override
  _PointagePageState createState() => _PointagePageState();
}

class _PointagePageState extends State<PointagePage> { // État pour gérer le matricule et l'étudiant
  final Color pageBackgroundColor = const Color.fromARGB(255, 255, 255, 255);
  final Color buttonColor = const Color(0xFF4A2E20);
  final Color accentColor = const Color(0xFFD4A017);
  final Color buttonTextColor = Colors.white;

  final TextEditingController _matriculeController = TextEditingController();
  final EtudiantService _etudiantService = EtudiantService();
  Etudiant? _etudiantTrouve;
  String? _messageErreur;

  Future<void> _rechercherEtudiant(String matricule) async {
    if (matricule.isEmpty) {
      setState(() {
        _etudiantTrouve = null;
        _messageErreur = null;
      });
      return;
    }
    print("Recherche de l'étudiant avec le matricule: $matricule");
    try {
      final etudiant = await _etudiantService.getEtudiantByMatricule(matricule);
      setState(() {
        _etudiantTrouve = etudiant;
        if (etudiant == null) {
          _messageErreur = "Aucun étudiant trouvé pour ce matricule.";
        } else {
          _messageErreur = null;
        }
      });
    } catch (e) {
      setState(() {
        _etudiantTrouve = null;
        _messageErreur = "Erreur lors de la recherche de l'étudiant.";
      });
      print("Erreur recherche étudiant: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: Column(
        children: [
          const CustomHeaderPointage(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView( // Ajout de SingleChildScrollView pour éviter le débordement
                child: Column(
                  children: [
                    // Champ de recherche modifié pour utiliser _matriculeController
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _matriculeController, // Utilisation du contrôleur
                              decoration: InputDecoration(
                                hintText: "Rechercher un étudiant...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey[600]),
                              ),
                              onSubmitted: (value) { // Recherche lors de la soumission
                                _rechercherEtudiant(value);
                              },
                              onChanged: (value) {
                                if (_etudiantTrouve != null || _messageErreur != null) {
                                  setState(() {
                                    _etudiantTrouve = null;
                                    _messageErreur = null;
                                  });
                                }
                              },
                            ),
                          ),
                          IconButton( // Changé en IconButton pour une meilleure sémantique
                            icon: Icon(Icons.search, color: accentColor, size: 28),
                            onPressed: () {
                              _rechercherEtudiant(_matriculeController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                    // const PointageEtudiantSearch(), // Remplacé par le TextField ci-dessus
                    const SizedBox(height: 20),
                    // Bouton "Scanner"
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        print("Scanner button clicked");
                        // Navigation vers l'écran de scan
                        final matriculeScanne = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(builder: (context) => const ScannerPage()),
                        );
                        if (matriculeScanne != null && matriculeScanne.isNotEmpty) {
                          print("Matricule reçu de ScannerPage: $matriculeScanne");
                          _matriculeController.text = matriculeScanne;
                          _rechercherEtudiant(matriculeScanne);
                        }
                      },
                      child: Text(
                        'SCANNER',
                        style: TextStyle(color: buttonTextColor),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Affichage du résultat de la recherche
                    if (_matriculeController.text.isNotEmpty)
                      if (_etudiantTrouve != null)
                        Card(
                          elevation: 4,
                          color: const Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Étudiant Trouvé:', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black87)),
                                const SizedBox(height: 8),
                                Text('Matricule: ${_etudiantTrouve!.matricule}', style: const TextStyle(color: Colors.black87)),
                                Text('Nom: ${_etudiantTrouve!.nom} ${_etudiantTrouve!.prenom}', style: const TextStyle(color: Colors.black87)),
                                Text('Classe: ${_etudiantTrouve!.classe}', style: const TextStyle(color: Colors.black87)),
                                // Ajoutez d'autres informations de l'étudiant ici
                              ],
                            ),
                          ),
                        )
                      else if (_messageErreur != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _messageErreur!,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}