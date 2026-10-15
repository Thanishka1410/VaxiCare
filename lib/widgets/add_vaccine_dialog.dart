import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/vaccine_record.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text_field.dart';

class AddVaccineDialog extends StatefulWidget {
  const AddVaccineDialog({super.key});

  @override
  State<AddVaccineDialog> createState() => _AddVaccineDialogState();
}

class _AddVaccineDialogState extends State<AddVaccineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _doseController = TextEditingController(text: 'Dose 1');
  final _notesController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 14));
  VaccineStatus _status = VaccineStatus.upcoming;

  // Preset suggestions for convenience
  final List<Map<String, String>> _commonVaccines = [
    {'name': 'MMR Booster', 'disease': 'Measles, Mumps, Rubella', 'dose': 'Booster'},
    {'name': 'Typhoid Conjugate', 'disease': 'Typhoid Fever', 'dose': 'Dose 1'},
    {'name': 'Hepatitis A', 'disease': 'Hepatitis A', 'dose': 'Dose 1'},
    {'name': 'Chickenpox (Varicella)', 'disease': 'Varicella', 'dose': 'Dose 1'},
    {'name': 'HPV Vaccine', 'disease': 'Human Papillomavirus', 'dose': 'Dose 1'},
    {'name': 'Influenza (Annual)', 'disease': 'Seasonal Flu', 'dose': 'Annual Shot'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _diseaseController.dispose();
    _doseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyPreset(Map<String, String> item) {
    setState(() {
      _nameController.text = item['name']!;
      _diseaseController.text = item['disease']!;
      _doseController.text = item['dose']!;
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<VaccineProvider>(context, listen: false);
    provider.addVaccineRecord(
      vaccineName: _nameController.text.trim(),
      diseasePrevented: _diseaseController.text.trim(),
      doseNumber: _doseController.text.trim(),
      dueDate: _dueDate,
      status: _status,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Vaccine Dose',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.secondaryText),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Quick Presets:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondaryText),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _commonVaccines.map((item) {
                    return ActionChip(
                      label: Text(item['name']!, style: const TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.primaryLight,
                      side: BorderSide(color: AppColors.primaryBlue.withOpacity(0.2)),
                      onPressed: () => _applyPreset(item),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                AppTextField(
                  controller: _nameController,
                  label: 'Vaccine Name',
                  hint: 'e.g. MMR, Hepatitis B',
                  prefixIcon: Icons.vaccines_outlined,
                  validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _diseaseController,
                  label: 'Disease Prevented',
                  hint: 'e.g. Measles, Mumps, Rubella',
                  prefixIcon: Icons.shield_outlined,
                  validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _doseController,
                  label: 'Dose Label',
                  hint: 'e.g. Dose 1, Booster 2',
                  prefixIcon: Icons.numbers_outlined,
                  validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 14),

                // Due Date selector
                const Text(
                  'Scheduled Due Date',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                    );
                    if (picked != null) {
                      setState(() {
                        _dueDate = picked;
                        if (_dueDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                          _status = VaccineStatus.overdue;
                        } else {
                          _status = VaccineStatus.upcoming;
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateFormat.format(_dueDate),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primaryBlue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                AppTextField(
                  controller: _notesController,
                  label: 'Additional Notes (Optional)',
                  hint: 'Doctor advice, hospital preferred...',
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Add to Schedule',
                        onPressed: _handleSubmit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
