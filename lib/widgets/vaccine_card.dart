import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/vaccine_record.dart';
import 'status_badge.dart';
import 'hover_scale_card.dart';

class VaccineCard extends StatelessWidget {
  final VaccineRecord vaccine;
  final VoidCallback? onTap;
  final VoidCallback? onMarkDone;

  const VaccineCard({
    super.key,
    required this.vaccine,
    this.onTap,
    this.onMarkDone,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    Color iconBgColor;
    Color iconColor;
    IconData cardIcon;

    if (vaccine.isCompleted) {
      iconBgColor = AppColors.successLight;
      iconColor = AppColors.successGreen;
      cardIcon = Icons.verified_user_rounded;
    } else if (vaccine.isOverdue) {
      iconBgColor = AppColors.errorLight;
      iconColor = AppColors.errorRed;
      cardIcon = Icons.warning_amber_rounded;
    } else {
      iconBgColor = AppColors.primaryLight;
      iconColor = AppColors.primaryBlue;
      cardIcon = Icons.medical_services_outlined;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: HoverScaleCard(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      cardIcon,
                      color: iconColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaccine.vaccineName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Protects against: ${vaccine.diseasePrevented}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: vaccine.status),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.slateLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          vaccine.doseNumber,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            vaccine.isCompleted ? Icons.event_available : Icons.event,
                            size: 14,
                            color: AppColors.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vaccine.isCompleted
                                ? 'Given: ${vaccine.administeredDate != null ? dateFormat.format(vaccine.administeredDate!) : "Completed"}'
                                : 'Due: ${dateFormat.format(vaccine.dueDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: vaccine.isOverdue
                                  ? AppColors.errorRed
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!vaccine.isCompleted) ...[
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _openCalendarLink(context, vaccine),
                          icon: const Icon(Icons.event_note_rounded, size: 16, color: AppColors.primaryBlue),
                          label: const Text('Calendar', style: TextStyle(fontSize: 11, color: AppColors.primaryBlue)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (!vaccine.isCompleted && onMarkDone != null)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: onMarkDone,
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text(
                            'Mark Given',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        )
                      else
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: AppColors.secondaryText,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCalendarLink(BuildContext context, VaccineRecord vac) {
    final title = Uri.encodeComponent('VaxiCare: ${vac.vaccineName} (${vac.doseNumber})');
    final details = Uri.encodeComponent('Scheduled immunization for ${vac.vaccineName} against ${vac.diseasePrevented}. Recorded via VaxiCare.');
    final dateStr = DateFormat('yyyyMMdd').format(vac.dueDate);
    final googleUrl = 'https://calendar.google.com/calendar/render?action=TEMPLATE&text=$title&dates=${dateStr}T090000Z/${dateStr}T100000Z&details=$details';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('Reminder ready for ${vac.vaccineName}.')),
          ],
        ),
        action: SnackBarAction(
          label: 'Open Calendar',
          textColor: AppColors.secondaryMint,
          onPressed: () {
            // In web environments, window.open or navigating launches the link
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Add to Google Calendar'),
                content: SelectableText('Copy or open your calendar link:\n\n$googleUrl'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
