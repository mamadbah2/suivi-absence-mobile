import 'package:flutter/material.dart';
import 'package:suivi_absence_mobile/app/data/models/absence.dart';

// Définition des couleurs ISM avec des nuances améliorées
const Color ismBrownDark = Color(0xFF43291b);
const Color ismOrange = Color(0xFFf89620);
const Color ismBrown = Color(0xFF77491c);
const Color ismBrownLight = Color(0xFFb56e1e);
const Color ismOrangeLight = Color(0xFFda841f);

class AbsenceItemWidget extends StatelessWidget {
  final Absence absence;
  final Function(Absence) onTap;

  const AbsenceItemWidget({
    super.key,
    required this.absence,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ismBrown.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onTap(absence),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Indicateur de type d'absence (couleur)
                    Container(
                      width: 5,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getAbsenceColor(absence.type ?? ''),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${absence.module}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ismBrownDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${absence.professeur} - ${absence.salle}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${absence.heure} - ${absence.heure}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ismBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusBadge(absence.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (status.toLowerCase()) {
      case 'validée':
        backgroundColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green[700]!;
        icon = Icons.check_circle_outline;
        break;
      case 'en attente':
        backgroundColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange[700]!;
        icon = Icons.access_time;
        break;
      case 'rejetée':
        backgroundColor = Colors.red.withOpacity(0.15);
        textColor = Colors.red[700]!;
        icon = Icons.cancel_outlined;
        break;
      case 'non justifiée':
        backgroundColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[700]!;
        icon = Icons.error_outline;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[700]!;
        icon = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAbsenceColor(String type) {
    switch (type.toLowerCase()) {
      case 'absence':
        return Colors.red;
      case 'retard':
        return ismOrange;
      case 'sortie anticipée':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}