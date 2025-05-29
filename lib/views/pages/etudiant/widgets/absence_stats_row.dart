import 'package:flutter/material.dart';
import 'absence_stat_card.dart';

class AbsenceStatsRow extends StatelessWidget {
  final List<Map<String, String>> stats;

  const AbsenceStatsRow({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            stats
                .map(
                  (stat) => AbsenceStatCard(
                    label: stat['label']!,
                    value: stat['value']!,
                  ),
                )
                .toList(),
      ),
    );
  }
}
