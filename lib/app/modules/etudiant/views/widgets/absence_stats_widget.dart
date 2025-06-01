import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/app/data/models/absence_stats.dart';

// Définition des couleurs ISM avec des nuances améliorées
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);
const Color ismBrownLight = Color(0xFFb56e1e);
const Color ismOrangeLight = Color(0xFFda841f);

class AbsenceStatsWidget extends StatelessWidget {
  final AbsenceStats stats;

  const AbsenceStatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ismBrown.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: ismBrown.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Absence cumulée',
                  style: TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
              SizedBox(height: 8),
              Text('Absence soumise',
                  style: TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
              SizedBox(height: 8),
              Text('Retards cumulés',
                  style: TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
              SizedBox(height: 8),
              Text('Absence restante',
                  style: TextStyle(fontWeight: FontWeight.w600, color: ismBrown)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(stats.absenceCumulee,
                  style: const TextStyle(color: ismOrange, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(stats.absenceSoumise,
                  style: const TextStyle(color: ismOrange, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(stats.retardsCumules,
                  style: const TextStyle(color: ismOrange, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(stats.absenceRestante,
                  style: const TextStyle(color: ismBrownDark, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}