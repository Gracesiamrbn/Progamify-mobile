import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:progamify/api/user_service.dart';

class SettingProfileScreen extends StatefulWidget {
  const SettingProfileScreen({super.key});

  @override
  SettingProfileScreenState createState() => SettingProfileScreenState();
}

class SettingProfileScreenState extends State<SettingProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _angkatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: UserService().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;

            Logger().i(user);

            _nameController.text = "${user['name']}";
            _emailController.text = "${user['email']}";
            _nimController.text = "${user['nim']}";
            _angkatanController.text = "${user['angkatan']}";

            return Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Form Fields
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true, //dev
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true, //dev
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nimController,
                      decoration: InputDecoration(
                        labelText: 'ID Student',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true, //dev
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _angkatanController,
                      decoration: InputDecoration(
                        labelText: 'Year of Join',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true, //dev
                    ),
                    const SizedBox(height: 30),

                    // Update Button
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Action for Update
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.yellow, // Yellow background
                    //     minimumSize: const Size(
                    //         double.infinity, 50), // Full width button
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    //   child: const Text(
                    //     'Update',
                    //     style: TextStyle(
                    //         fontSize: 18, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
