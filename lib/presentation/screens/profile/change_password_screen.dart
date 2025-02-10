import 'package:flutter/material.dart';
import '../../../core/theme/app_styles.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, // Mengubah warna teks menjadi putih
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Current Password Field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // New Password Field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Update Button
            ElevatedButton(
              onPressed: () {
                // Action for Update Password
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Yellow background
                minimumSize:
                    const Size(double.infinity, 50), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Update',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
