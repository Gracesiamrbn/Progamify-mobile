import 'package:flutter/material.dart';
import '../../../core/theme/app_styles.dart';
import 'setting_profile_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            ElevatedButton(
              onPressed: () {
                // Action for Profile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Light grey background
                minimumSize:
                    const Size(double.infinity, 50), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft, // Rata kiri
                child: Text(
                  'Profile',
                  style: AppStyles.cardTitleStyle,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Change Password Section
            ElevatedButton(
              onPressed: () {
                // Action for Change Password
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Light grey background
                minimumSize:
                    const Size(double.infinity, 50), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft, // Rata kiri
                child: Text(
                  'Change Password',
                  style: AppStyles.cardTitleStyle,
                ),
              ),
            ),
            const Spacer(),

            // Sign Out Button
            ElevatedButton(
              onPressed: () {
                // Action for Sign Out
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red background
                minimumSize:
                    const Size(double.infinity, 50), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
