import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, bool> _toggles = {
    'App Settings': true,
    'User Preferences': true,
    'Notification Settings': true,
    'Privacy Options': false,
    'Theme Selection': true,
    'Language Settings': true,
    'Data Management': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 36),
                  Text(
                    'Pengaturan',
                    style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.inputBg,
                      ),
                      child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // "Manage your preferences" row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Manage your preferences', style: AppTextStyles.caption),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.border),

            // Settings items
            Expanded(
              child: ListView(
                children: _toggles.entries.map((entry) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.settings_outlined, size: 18, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(entry.key, style: AppTextStyles.label),
                            ),
                            Switch(
                              value: entry.value,
                              onChanged: (val) {
                                setState(() => _toggles[entry.key] = val);
                              },
                              activeColor: AppColors.white,
                              activeTrackColor: AppColors.primary,
                              inactiveThumbColor: AppColors.white,
                              inactiveTrackColor: AppColors.border,
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.border),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Power button
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.inputBg,
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: const Icon(Icons.power_settings_new, size: 28, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
