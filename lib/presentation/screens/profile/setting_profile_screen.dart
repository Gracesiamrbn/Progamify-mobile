import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:progamify/api/user_service.dart';

class SettingProfileScreen extends StatefulWidget {
  const SettingProfileScreen({super.key});

  @override
  SettingProfileScreenState createState() => SettingProfileScreenState();
}

class SettingProfileScreenState extends State<SettingProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _angkatanController = TextEditingController();

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await UserService().updateUser(
          _nameController.text.trim(),
          _nimController.text.trim(),
          int.parse(_angkatanController.text.trim()),
        );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('User data updated successfully.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nimController,
                        decoration: InputDecoration(
                          labelText: 'ID Student',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'ID Student is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _angkatanController,
                        decoration: InputDecoration(
                          labelText: 'Year of Join',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Year of Join is required';
                          } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                            return 'Year must be 4 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _updateUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
