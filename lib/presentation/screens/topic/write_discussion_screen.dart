import 'package:flutter/material.dart';

class WriteDiscussionScreen extends StatefulWidget {
  const WriteDiscussionScreen({super.key});

  @override
  _WriteDiscussionScreenState createState() => _WriteDiscussionScreenState();
}

class _WriteDiscussionScreenState extends State<WriteDiscussionScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Add Discussion",
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Enrico Sirait',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Type your title...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Question",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: questionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Type your question...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Handle post action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
