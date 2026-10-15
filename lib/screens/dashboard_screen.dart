import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/vaccine_record.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/child_profile_card.dart';
import '../widgets/progress_summary_card.dart';
import '../widgets/vaccine_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/vaccine_detail_dialog.dart';
import '../widgets/add_vaccine_dialog.dart';
import '../widgets/add_child_dialog.dart';
import '../widgets/responsive_layout.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToSchedule;

  const DashboardScreen({super.key, required this.onNavigateToSchedule});

  @override
  Widget build(BuildContext context) {
    return Consumer<VaccineProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final selectedChild = provider.selectedChild;
        if (selectedChild == null) {
          return EmptyStateWidget(
            icon: Icons.child_care_rounded,
            title: 'No Profiles Found',
            description: 'Add your first child or family profile to start tracking vaccinations.',
            actionText: 'Add Child Profile',
            onAction: () {
              showDialog(
                context: context,
                builder: (ctx) => const AddChildDialog(),
              );
            },
          );
        }

        final overdue = provider.overdueVaccines;
        final upcoming = provider.upcomingVaccines;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: MaxWidthContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header with greeting and profile picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back,',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          selectedChild.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        foregroundColor: AppColors.primaryBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.primaryBlue.withOpacity(0.2)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => const AddVaccineDialog(),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Dose', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Family Profiles Selector Ribbon
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.profiles.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index == provider.profiles.length) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => const AddChildDialog(),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline, color: AppColors.primaryBlue, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Add Child',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final child = provider.profiles[index];
                      return SizedBox(
                        width: 220,
                        child: ChildProfileCard(
                          child: child,
                          isSelected: child.id == selectedChild.id,
                          onTap: () => provider.selectChild(child.id),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Overall Immunization Progress Banner
                ProgressSummaryCard(
                  completed: provider.completedCount,
                  upcoming: provider.upcomingCount,
                  overdue: provider.overdueCount,
                  progress: provider.completionProgress,
                ),
                const SizedBox(height: 28),

                // Overdue Doses Alert Section (If any)
                if (overdue.isNotEmpty) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Attention Needed (${overdue.length} Overdue)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.errorRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...overdue.map((vac) => VaccineCard(
                        vaccine: vac,
                        onTap: () => _showDetailModal(context, provider, vac),
                        onMarkDone: () => _showDetailModal(context, provider, vac),
                      )),
                  const SizedBox(height: 24),
                ],

                // Upcoming Next Doses
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upcoming Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    TextButton(
                      onPressed: onNavigateToSchedule,
                      child: const Row(
                        children: [
                          Text('View Full Schedule', style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (upcoming.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.check_circle_outline, color: AppColors.successGreen, size: 36),
                        SizedBox(height: 8),
                        Text(
                          'All caught up!',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'No upcoming vaccinations due in the immediate schedule.',
                          style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                else
                  ...upcoming.take(4).map((vac) => VaccineCard(
                        vaccine: vac,
                        onTap: () => _showDetailModal(context, provider, vac),
                        onMarkDone: () => _showDetailModal(context, provider, vac),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailModal(BuildContext context, VaccineProvider provider, VaccineRecord vaccine) {
    showDialog(
      context: context,
      builder: (ctx) => VaccineDetailDialog(
        vaccine: vaccine,
        onMarkAdministered: (adminDate, location, batch, notes) {
          provider.markVaccineAdministered(
            vaccineId: vaccine.id,
            administeredDate: adminDate,
            location: location,
            batchNumber: batch,
            notes: notes,
          );
        },
        onDelete: () {
          provider.deleteVaccineRecord(vaccine.id);
        },
      ),
    );
  }
}
