import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            ElevatedButton(
              onPressed: () {
                // Action for Profile
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold, // Bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Change Password Section
            ElevatedButton(
              onPressed: () {
                // Action for Change Password
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold, // Bold
                  ),
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
