import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/child_profile.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_text_field.dart';

class AddChildDialog extends StatefulWidget {
  final ChildProfile? initialChild;

  const AddChildDialog({super.key, this.initialChild});

  @override
  State<AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<AddChildDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late DateTime _dob;
  late String _gender;
  late String _bloodGroup;
  late String _avatarEmoji;

  final List<String> _emojis = ['👶', '👦', '👧', '👼', '⭐', '🎈'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialChild?.name ?? '');
    _dob = widget.initialChild?.dateOfBirth ?? DateTime.now().subtract(const Duration(days: 90));
    _gender = widget.initialChild?.gender ?? 'Male';
    _bloodGroup = widget.initialChild?.bloodGroup ?? 'O+';
    _avatarEmoji = widget.initialChild?.avatarEmoji ?? '👶';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<VaccineProvider>(context, listen: false);

    if (widget.initialChild == null) {
      provider.addChildProfile(
        name: _nameController.text.trim(),
        dateOfBirth: _dob,
        gender: _gender,
        bloodGroup: _bloodGroup,
        avatarEmoji: _avatarEmoji,
      );
    } else {
      provider.updateChildProfile(
        widget.initialChild!.copyWith(
          name: _nameController.text.trim(),
          dateOfBirth: _dob,
          gender: _gender,
          bloodGroup: _bloodGroup,
          avatarEmoji: _avatarEmoji,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final isEditing = widget.initialChild != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
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
                    Text(
                      isEditing ? 'Edit Profile' : 'Add Child Profile',
                      style: const TextStyle(
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
                const SizedBox(height: 16),

                // Avatar Selector
                const Text(
                  'Choose Avatar Icon',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _emojis.map((emoji) {
                    final isSelected = _avatarEmoji == emoji;
                    return InkWell(
                      onTap: () => setState(() => _avatarEmoji = emoji),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primaryLight : AppColors.slateLight,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                AppTextField(
                  controller: _nameController,
                  label: "Child's Full Name",
                  hint: 'e.g. Aarav Sharma',
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter name' : null,
                ),
                const SizedBox(height: 14),

                // Date of Birth
                const Text(
                  'Date of Birth',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dob,
                      firstDate: DateTime(2005),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _dob = picked);
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
                        Text(dateFormat.format(_dob), style: const TextStyle(fontWeight: FontWeight.w600)),
                        const Icon(Icons.cake_outlined, size: 18, color: AppColors.primaryBlue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    // Gender
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gender',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _gender = v);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Blood Group
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Blood Group',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _bloodGroup,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _bloodGroup = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // National / International Guideline Selector
                const Text(
                  'Immunization Guideline Preset',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryText),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: 'IAP (Indian Academy of Pediatrics)',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'IAP (Indian Academy of Pediatrics)',
                      child: Text('IAP Recommended Schedule (Standard)'),
                    ),
                    DropdownMenuItem(
                      value: 'UIP (Universal Immunization Programme)',
                      child: Text('UIP National Programme (Govt of India)'),
                    ),
                    DropdownMenuItem(
                      value: 'WHO (World Health Organization)',
                      child: Text('WHO Global Pediatric Guidelines'),
                    ),
                  ],
                  onChanged: (v) {},
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
                        text: isEditing ? 'Update Profile' : 'Save & Generate',
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
