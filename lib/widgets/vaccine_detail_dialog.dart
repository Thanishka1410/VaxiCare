import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../models/vaccine_record.dart';
import '../models/vaccine_factsheet.dart';
import 'primary_button.dart';
import 'app_text_field.dart';

class VaccineDetailDialog extends StatefulWidget {
  final VaccineRecord vaccine;
  final Function(DateTime administeredDate, String? location, String? batchNumber, String? notes) onMarkAdministered;
  final VoidCallback onDelete;

  const VaccineDetailDialog({
    super.key,
    required this.vaccine,
    required this.onMarkAdministered,
    required this.onDelete,
  });

  @override
  State<VaccineDetailDialog> createState() => _VaccineDetailDialogState();
}

class _VaccineDetailDialogState extends State<VaccineDetailDialog> {
  bool _isMarking = false;
  bool _showFactsheet = false;
  late DateTime _administeredDate;
  final _locationController = TextEditingController();
  final _batchController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _administeredDate = widget.vaccine.administeredDate ?? DateTime.now();
    _locationController.text = widget.vaccine.administeredLocation ?? '';
    _batchController.text = widget.vaccine.batchNumber ?? '';
    _notesController.text = widget.vaccine.notes ?? '';
  }

  @override
  void dispose() {
    _locationController.dispose();
    _batchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final factsheet = VaccineFactsheet.getFactsheet(widget.vaccine.vaccineName);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vaccine.vaccineName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.vaccine.doseNumber} • ${widget.vaccine.diseasePrevented}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.secondaryText),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),

              if (!_isMarking) ...[
                // Info Grid
                _buildInfoRow('Status', widget.vaccine.status.name.toUpperCase(),
                    color: widget.vaccine.isCompleted
                        ? AppColors.successGreen
                        : (widget.vaccine.isOverdue ? AppColors.errorRed : AppColors.primaryBlue)),
                _buildInfoRow('Target Due Date', dateFormat.format(widget.vaccine.dueDate)),
                if (widget.vaccine.isCompleted && widget.vaccine.administeredDate != null)
                  _buildInfoRow('Administered On', dateFormat.format(widget.vaccine.administeredDate!)),
                if (widget.vaccine.administeredLocation != null && widget.vaccine.administeredLocation!.isNotEmpty)
                  _buildInfoRow('Clinic / Hospital', widget.vaccine.administeredLocation!),
                if (widget.vaccine.batchNumber != null && widget.vaccine.batchNumber!.isNotEmpty)
                  _buildInfoRow('Batch / Lot #', widget.vaccine.batchNumber!),
                if (widget.vaccine.notes != null && widget.vaccine.notes!.isNotEmpty)
                  _buildInfoRow('Clinical Notes', widget.vaccine.notes!),

                const SizedBox(height: 14),

                // Vaccine Factsheet & Clinical Guidance Accordion
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: _showFactsheet,
                      onExpansionChanged: (exp) => setState(() => _showFactsheet = exp),
                      leading: const Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 20),
                      title: const Text(
                        'Vaccine Factsheet & Care Guide',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        _buildGuideItem(
                          icon: Icons.healing_outlined,
                          title: 'Common Post-Vaccine Reactions',
                          content: factsheet.sideEffects,
                          color: AppColors.warningAmber,
                        ),
                        const SizedBox(height: 10),
                        _buildGuideItem(
                          icon: Icons.favorite_outline,
                          title: 'Parent Care & Soothing Tips',
                          content: factsheet.careTips,
                          color: AppColors.secondaryMint,
                        ),
                        const SizedBox(height: 10),
                        _buildGuideItem(
                          icon: Icons.emergency_outlined,
                          title: 'When to Consult Pediatrician',
                          content: factsheet.emergencyAlert,
                          color: AppColors.errorRed,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.errorRed),
                      tooltip: 'Delete Dose',
                      onPressed: () {
                        widget.onDelete();
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    if (!widget.vaccine.isCompleted)
                      PrimaryButton(
                        text: 'Record Administration',
                        icon: Icons.check_circle_outline,
                        onPressed: () {
                          setState(() => _isMarking = true);
                        },
                      )
                    else
                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Update Details'),
                        onPressed: () {
                          setState(() => _isMarking = true);
                        },
                      ),
                  ],
                ),
              ] else ...[
                // Form to mark as given
                const Text(
                  'Record Vaccine Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 16),

                // Date Picker row
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _administeredDate,
                      firstDate: DateTime(2010),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _administeredDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Administered Date', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                            const SizedBox(height: 2),
                            Text(dateFormat.format(_administeredDate), style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Icon(Icons.calendar_today, size: 18, color: AppColors.primaryBlue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                AppTextField(
                  controller: _locationController,
                  label: 'Hospital / Pediatric Clinic',
                  hint: 'e.g. Apollo Cradle Clinic',
                  prefixIcon: Icons.local_hospital_outlined,
                ),
                const SizedBox(height: 14),

                AppTextField(
                  controller: _batchController,
                  label: 'Batch Number (Optional)',
                  hint: 'e.g. VAC-2026-X1',
                  prefixIcon: Icons.qr_code,
                ),
                const SizedBox(height: 14),

                AppTextField(
                  controller: _notesController,
                  label: 'Observations / Reaction Notes',
                  hint: 'e.g. Mild fever, instructed to give paracetamol',
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _isMarking = false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Save Record',
                        backgroundColor: AppColors.successGreen,
                        onPressed: () {
                          widget.onMarkAdministered(
                            _administeredDate,
                            _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
                            _batchController.text.trim().isEmpty ? null : _batchController.text.trim(),
                            _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color ?? AppColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.primaryText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
