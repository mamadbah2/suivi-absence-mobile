import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Définition des couleurs ISM avec des nuances améliorées
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);
const Color ismBrownLight = Color(0xFFb56e1e);
const Color ismOrangeLight = Color(0xFFda841f);

class SchoolMapPage extends StatelessWidget {
  const SchoolMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Coordonnées de l'école (exemple: ISM Dakar)
    final LatLng schoolLocation = LatLng(14.6937, -17.4441);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ismBrownDark,
        title: const Text(
          'Localisation de l\'école',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: schoolLocation,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.suivi_absence_mobile.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: schoolLocation,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.school,
                        color: ismOrange,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Institut Supérieur de Management (ISM)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ismBrownDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Adresse: Dakar, Sénégal',
                  style: TextStyle(
                    fontSize: 16,
                    color: ismBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coordonnées: ${schoolLocation.latitude}, ${schoolLocation.longitude}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoButton(
                      context,
                      Icons.phone,
                      'Appeler',
                      () {
                        // Logique pour appeler l'école
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Appel de l\'école...')),
                        );
                      },
                    ),
                    _buildInfoButton(
                      context,
                      Icons.email,
                      'Email',
                      () {
                        // Logique pour envoyer un email
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ouverture de l\'email...')),
                        );
                      },
                    ),
                    _buildInfoButton(
                      context,
                      Icons.web,
                      'Site Web',
                      () {
                        // Logique pour visiter le site web
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ouverture du site web...')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: ismOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: ismOrange),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: ismBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}