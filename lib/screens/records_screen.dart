import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_animations.dart';
import '../models/vaccine_record.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/vaccine_detail_dialog.dart';
import '../widgets/hover_scale_card.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Consumer<VaccineProvider>(
      builder: (context, provider, _) {
        final activeChild = provider.selectedChild;
        if (activeChild == null) {
          return const Center(child: Text('No active profile.'));
        }

        final completedDoses = provider.childVaccines
            .where((v) => v.status == VaccineStatus.completed)
            .toList();

        return MaxWidthContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top digital card summary with hover effect
                HoverScaleCard(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(activeChild.avatarEmoji, style: const TextStyle(fontSize: 28)),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeChild.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'DOB: ${dateFormat.format(activeChild.dateOfBirth)} • ${activeChild.bloodGroup} • ${activeChild.gender}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.successLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.verified, size: 14, color: AppColors.successGreen),
                                  SizedBox(width: 6),
                                  Text(
                                    'Digital Pass',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.successGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniStat('Completed Doses', '${completedDoses.length}', AppColors.successGreen),
                            _buildMiniStat('Pending Doses', '${provider.upcomingCount + provider.overdueCount}', AppColors.warningAmber),
                            _buildMiniStat('Overall Protection', '${(provider.completionProgress * 100).round()}%', AppColors.primaryBlue),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Digital Immunization Record Table / Card List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Verified Vaccination Passbook',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.print_outlined, color: AppColors.secondaryText),
                      tooltip: 'Print / Export Passbook',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passbook export ready. In web browser, use Ctrl+P / Cmd+P to save as PDF.'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (completedDoses.isEmpty)
                  const EmptyStateWidget(
                    icon: Icons.assignment_outlined,
                    title: 'No Completed Records Yet',
                    description: 'Mark doses as completed from the Dashboard or Schedule tab to populate this passbook.',
                  )
                else
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: completedDoses.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final record = completedDoses[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: AppColors.successLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: AppColors.successGreen, size: 20),
                          ),
                          title: Text(
                            record.vaccineName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          subtitle: Text(
                            '${record.doseNumber} • Given: ${record.administeredDate != null ? dateFormat.format(record.administeredDate!) : "Completed"}\n${record.administeredLocation ?? "Health Clinic"}${record.batchNumber != null ? " • Batch: ${record.batchNumber}" : ""}',
                            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText, size: 20),
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: 'Record Detail',
                              transitionDuration: AppAnimations.normal,
                              transitionBuilder: (context, anim, _, child) {
                                return Transform.scale(
                                  scale: 0.95 + (0.05 * anim.value),
                                  child: Opacity(
                                    opacity: anim.value,
                                    child: child,
                                  ),
                                );
                              },
                              pageBuilder: (ctx, _, __) => VaccineDetailDialog(
                                vaccine: record,
                                onMarkAdministered: (adminDate, location, batch, notes) {
                                  provider.markVaccineAdministered(
                                    vaccineId: record.id,
                                    administeredDate: adminDate,
                                    location: location,
                                    batchNumber: batch,
                                    notes: notes,
                                  );
                                },
                                onDelete: () {
                                  provider.deleteVaccineRecord(record.id);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
