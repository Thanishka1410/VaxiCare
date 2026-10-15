import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/vaccine_record.dart';

class StatusBadge extends StatelessWidget {
  final VaccineStatus status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case VaccineStatus.completed:
        bg = AppColors.successLight;
        textColor = AppColors.successGreen;
        label = 'Completed';
        icon = Icons.check_circle_rounded;
        break;
      case VaccineStatus.overdue:
        bg = AppColors.errorLight;
        textColor = AppColors.errorRed;
        label = 'Overdue';
        icon = Icons.error_outline_rounded;
        break;
      case VaccineStatus.upcoming:
        bg = AppColors.primaryLight;
        textColor = AppColors.primaryBlue;
        label = 'Upcoming';
        icon = Icons.schedule_rounded;
        break;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
