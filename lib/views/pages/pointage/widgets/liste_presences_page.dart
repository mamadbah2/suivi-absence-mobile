import 'package:flutter/material.dart';

class ListePresencesPage extends StatefulWidget {
  const ListePresencesPage({super.key});

  @override
  State<ListePresencesPage> createState() => _ListePresencesPageState();
}

class _ListePresencesPageState extends State<ListePresencesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _etudiants = [
    'Adja Marieme Keita',
    'Bobo Bah',
    'Fatima keita',
    'Ousmane Ba',
    'Fatoumata Binetou Niang',
  ];
  List<String> _filteredEtudiants = [];

  @override
  void initState() {
    super.initState();
    _filteredEtudiants = List.from(_etudiants);
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEtudiants = _etudiants
          .where((e) => e.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFF2D1B11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    '/Users/mac/Downloads/suivi-absence-mobile/image.png',
                    height: 40,
                  ),
                  const Text(
                    'LISTE DES PRÉSENCES',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.logout, color: Color(0xFFFFA500)),
                      SizedBox(width: 6),
                      Text(
                        'Amadou\nDiaw',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un étudiant...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredEtudiants.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage:
                            AssetImage('image copy.png'),
                      ),
                      title: Text(_filteredEtudiants[index]),
                      subtitle: const Text('Présent(e)'),
                      trailing: const Icon(Icons.check_circle,
                          color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListePresencesPage()),
    );
  },
  backgroundColor: const Color(0xFFB67329),
  tooltip: 'Scanner un nouvel étudiant',
  child: const Icon(Icons.qr_code_scanner),
),

    );
  }
}
