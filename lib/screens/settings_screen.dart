import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/vaccine_provider.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const SettingsScreen({super.key, required this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailReminders = true;
  bool _browserNotifications = true;
  bool _smsAlerts = false;
  int _reminderLeadDays = 3;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final vaccine = Provider.of<VaccineProvider>(context);

    return MaxWidthContainer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings & Preferences',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Configure reminders, project details, and simulated account settings.',
              style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 24),

            // Profile Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        auth.userName.isNotEmpty ? auth.userName[0] : 'U',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            auth.userEmail,
                            style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Guardian Account (Simulated)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.successGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notification preferences
            _buildSectionHeader('Smart Reminder Alerts'),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Email Reminders', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: const Text('Receive digest emails when vaccination due dates approach.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                    value: _emailReminders,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (val) => setState(() => _emailReminders = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Web Browser Notifications', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: const Text('Show web alert banners for overdue and today’s doses.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                    value: _browserNotifications,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (val) => setState(() => _browserNotifications = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('SMS Reminders', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: const Text('Receive text alerts 48 hours prior to pediatric clinic appointments.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                    value: _smsAlerts,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (val) => setState(() => _smsAlerts = val),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alert Lead Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            Text('Send reminder days ahead of dose', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                          ],
                        ),
                        DropdownButton<int>(
                          value: _reminderLeadDays,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1 day before')),
                            DropdownMenuItem(value: 3, child: Text('3 days before')),
                            DropdownMenuItem(value: 7, child: Text('1 week before')),
                            DropdownMenuItem(value: 14, child: Text('2 weeks before')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _reminderLeadDays = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lab / Project Information Card
            _buildSectionHeader('B.Tech CSE Project Information'),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'VaxiCare: A Smart Vaccination Reminder and Tracking Application',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.primaryText),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tagline: Never Miss a Dose. Protect Every Tomorrow.',
                      style: TextStyle(fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Architecture: Flutter Web (Material 3) with Provider state management and SharedPreferences browser-local persistent storage. Automated CI/CD pipeline deploys release bundles directly to GitHub Pages.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.secondaryText, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildTechBadge('Flutter 3.x'),
                        const SizedBox(width: 8),
                        _buildTechBadge('Dart'),
                        const SizedBox(width: 8),
                        _buildTechBadge('Material 3'),
                        const SizedBox(width: 8),
                        _buildTechBadge('GitHub Actions'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Reset & Data Actions
            _buildSectionHeader('Data Management'),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.refresh_rounded, color: AppColors.primaryBlue),
                    title: const Text('Reset Demo Data', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Restores default sample children and immunization records for presentation.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () async {
                      final confirmed = await ConfirmationDialog.show(
                        context,
                        title: 'Reset Demo Data?',
                        message: 'This will restore sample children (Aarav & Ananya) and realistic vaccination milestones.',
                        confirmText: 'Reset Now',
                      );
                      if (confirmed == true) {
                        await vaccine.resetDemoData();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Demo data reloaded successfully!')),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.errorRed),
                    title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.errorRed)),
                    subtitle: const Text('Return to simulated authentication screen.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () async {
                      final confirmed = await ConfirmationDialog.show(
                        context,
                        title: 'Sign Out?',
                        message: 'You can sign back in anytime or use Instant Demo Access.',
                        confirmText: 'Sign Out',
                        confirmColor: AppColors.errorRed,
                        icon: Icons.logout,
                      );
                      if (confirmed == true) {
                        await auth.logout();
                        widget.onLogout();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryText,
        ),
      ),
    );
  }

  Widget _buildTechBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.slateLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryText),
      ),
    );
  }
}
