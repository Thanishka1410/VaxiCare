import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/child_profile.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/add_child_dialog.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/responsive_layout.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Consumer<VaccineProvider>(
      builder: (context, provider, _) {
        final profiles = provider.profiles;
        final selectedId = provider.selectedChildId;

        return MaxWidthContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Family & Profiles',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage dependents, immunization histories, and age tracking.',
                          style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => const AddChildDialog(),
                        );
                      },
                      icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                      label: const Text('Add Profile'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                if (profiles.isEmpty)
                  EmptyStateWidget(
                    icon: Icons.people_outline_rounded,
                    title: 'No Family Profiles Added',
                    description: 'Add your child or family member to start monitoring schedules.',
                    actionText: 'Add Child',
                    onAction: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => const AddChildDialog(),
                      );
                    },
                  )
                else
                  ...profiles.map((child) {
                    final isCurrentActive = child.id == selectedId;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: isCurrentActive ? AppColors.primaryBlue : AppColors.border,
                          width: isCurrentActive ? 1.8 : 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: isCurrentActive ? AppColors.primaryLight : AppColors.slateLight,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isCurrentActive ? AppColors.primaryBlue.withOpacity(0.3) : AppColors.border,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(child.avatarEmoji, style: const TextStyle(fontSize: 28)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            child.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          if (isCurrentActive)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryLight,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                                              ),
                                              child: const Text(
                                                'Active View',
                                                style: TextStyle(
                                                  color: AppColors.primaryBlue,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${child.ageFormatted} • Born ${dateFormat.format(child.dateOfBirth)}',
                                        style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Blood Group: ${child.bloodGroup} • Gender: ${child.gender}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Divider(height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!isCurrentActive)
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    onPressed: () => provider.selectChild(child.id),
                                    icon: const Icon(Icons.switch_account_outlined, size: 16),
                                    label: const Text('Switch to Child'),
                                  )
                                else
                                  Row(
                                    children: const [
                                      Icon(Icons.check_circle, size: 16, color: AppColors.primaryBlue),
                                      SizedBox(width: 6),
                                      Text(
                                        'Currently Selected',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 20),
                                      tooltip: 'Edit Profile',
                                      color: AppColors.secondaryText,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AddChildDialog(initialChild: child),
                                        );
                                      },
                                    ),
                                    if (profiles.length > 1)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.errorRed),
                                        tooltip: 'Delete Profile',
                                        onPressed: () async {
                                          final confirmed = await ConfirmationDialog.show(
                                            context,
                                            title: 'Delete ${child.name}?',
                                            message: 'All recorded doses and upcoming immunization schedules for this profile will be permanently removed.',
                                            confirmText: 'Delete',
                                            confirmColor: AppColors.errorRed,
                                            icon: Icons.delete_outline,
                                          );
                                          if (confirmed == true) {
                                            provider.deleteChildProfile(child.id);
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
