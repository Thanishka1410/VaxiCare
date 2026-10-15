import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/vaccine_record.dart';
import 'status_badge.dart';

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

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: vaccine.isCompleted
                          ? AppColors.successLight
                          : (vaccine.isOverdue ? AppColors.errorLight : AppColors.primaryLight),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      vaccine.isCompleted
                          ? Icons.verified_user_rounded
                          : (vaccine.isOverdue
                              ? Icons.warning_amber_rounded
                              : Icons.medical_services_outlined),
                      color: vaccine.isCompleted
                          ? AppColors.successGreen
                          : (vaccine.isOverdue ? AppColors.errorRed : AppColors.primaryBlue),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      const SizedBox(width: 12),
                      Row(
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
                  if (!vaccine.isCompleted && onMarkDone != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        foregroundColor: AppColors.primaryBlue,
                      ),
                      onPressed: onMarkDone,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Mark Given', style: TextStyle(fontSize: 12)),
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
        ),
      ),
    );
  }
}
