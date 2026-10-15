import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/vaccine_record.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/vaccine_card.dart';
import '../widgets/vaccine_detail_dialog.dart';
import '../widgets/add_vaccine_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/responsive_layout.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VaccineProvider>(
      builder: (context, provider, _) {
        final activeChild = provider.selectedChild;
        final filteredList = provider.filteredVaccines;

        if (activeChild == null) {
          return const Center(child: Text('No active profile.'));
        }

        return MaxWidthContainer(
          child: Column(
            children: [
              // Search & Filter Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => provider.setSearchQuery(val),
                            decoration: InputDecoration(
                              hintText: 'Search vaccine or disease (e.g. Polio, MMR)',
                              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.secondaryText),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        provider.setSearchQuery('');
                                      },
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => const AddVaccineDialog(),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Dose'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Filter chips row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'All Doses (${provider.childVaccines.length})',
                            isSelected: provider.statusFilter == null,
                            onTap: () => provider.setStatusFilter(null),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Upcoming (${provider.upcomingCount})',
                            isSelected: provider.statusFilter == VaccineStatus.upcoming,
                            onTap: () => provider.setStatusFilter(VaccineStatus.upcoming),
                            accentColor: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Overdue (${provider.overdueCount})',
                            isSelected: provider.statusFilter == VaccineStatus.overdue,
                            onTap: () => provider.setStatusFilter(VaccineStatus.overdue),
                            accentColor: AppColors.errorRed,
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Completed (${provider.completedCount})',
                            isSelected: provider.statusFilter == VaccineStatus.completed,
                            onTap: () => provider.setStatusFilter(VaccineStatus.completed),
                            accentColor: AppColors.successGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Vaccine List View
              Expanded(
                child: filteredList.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'No Vaccines Found',
                        description: provider.searchQuery.isNotEmpty
                            ? 'No doses match "${provider.searchQuery}". Try a different keyword.'
                            : 'No vaccines recorded under this category.',
                        actionText: provider.searchQuery.isNotEmpty ? 'Clear Search' : 'Add Vaccine',
                        onAction: () {
                          if (provider.searchQuery.isNotEmpty) {
                            _searchController.clear();
                            provider.setSearchQuery('');
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => const AddVaccineDialog(),
                            );
                          }
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final vac = filteredList[index];
                          return VaccineCard(
                            vaccine: vac,
                            onTap: () => _openDetail(context, provider, vac),
                            onMarkDone: () => _openDetail(context, provider, vac),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color accentColor = AppColors.primaryBlue,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? accentColor : AppColors.secondaryText,
      ),
      selectedColor: accentColor.withOpacity(0.12),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? accentColor : AppColors.border,
        width: 1.2,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  void _openDetail(BuildContext context, VaccineProvider provider, VaccineRecord vaccine) {
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
