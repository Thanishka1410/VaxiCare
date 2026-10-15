import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_animations.dart';
import '../models/vaccine_record.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/vaccine_card.dart';
import '../widgets/vaccine_detail_dialog.dart';
import '../widgets/add_vaccine_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/hover_scale_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime _selectedCalendarDate = DateTime.now();
  bool _showCalendar = false;

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
                        const SizedBox(width: 10),
                        // Calendar toggle button
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: _showCalendar ? AppColors.primaryLight : Colors.white,
                            foregroundColor: AppColors.primaryBlue,
                            side: BorderSide(
                              color: _showCalendar ? AppColors.primaryBlue : AppColors.border,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(14),
                          ),
                          onPressed: () => setState(() => _showCalendar = !_showCalendar),
                          icon: Icon(_showCalendar ? Icons.view_list_rounded : Icons.calendar_month_rounded, size: 20),
                          tooltip: _showCalendar ? 'Show List View' : 'Show Calendar View',
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showAddVaccineModal(context);
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

              // Calendar View or Vaccine List View
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppAnimations.normal,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showCalendar
                      ? _buildCalendarView(provider)
                      : _buildListView(filteredList, provider),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListView(List<VaccineRecord> filteredList, VaccineProvider provider) {
    if (filteredList.isEmpty) {
      return EmptyStateWidget(
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
            _showAddVaccineModal(context);
          }
        },
      );
    }

    return ListView.builder(
      key: const ValueKey('list_view'),
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
    );
  }

  Widget _buildCalendarView(VaccineProvider provider) {
    final childVaccines = provider.childVaccines;

    // Filter doses matching selected calendar date month
    final monthDoses = childVaccines.where((v) {
      return v.dueDate.year == _selectedCalendarDate.year &&
          v.dueDate.month == _selectedCalendarDate.month;
    }).toList();

    final monthName = DateFormat('MMMM yyyy').format(_selectedCalendarDate);

    return SingleChildScrollView(
      key: const ValueKey('calendar_view'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Selector Card
          HoverScaleCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedCalendarDate = DateTime(
                          _selectedCalendarDate.year,
                          _selectedCalendarDate.month - 1,
                        );
                      });
                    },
                  ),
                  Text(
                    monthName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedCalendarDate = DateTime(
                          _selectedCalendarDate.year,
                          _selectedCalendarDate.month + 1,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            'Doses in $monthName (${monthDoses.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),

          if (monthDoses.isEmpty)
            HoverScaleCard(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(Icons.event_available, color: AppColors.secondaryMint, size: 36),
                    SizedBox(height: 10),
                    Text(
                      'No doses scheduled for this month.',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            )
          else
            ...monthDoses.map((vac) => VaccineCard(
                  vaccine: vac,
                  onTap: () => _openDetail(context, provider, vac),
                  onMarkDone: () => _openDetail(context, provider, vac),
                )),
        ],
      ),
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
      selectedColor: accentColor.withValues(alpha: 0.12),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? accentColor : AppColors.border,
        width: 1.2,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  void _showAddVaccineModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Vaccine',
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
      pageBuilder: (ctx, _, __) => const AddVaccineDialog(),
    );
  }

  void _openDetail(BuildContext context, VaccineProvider provider, VaccineRecord vaccine) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Vaccine Detail',
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
