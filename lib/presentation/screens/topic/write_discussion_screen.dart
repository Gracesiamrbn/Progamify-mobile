import 'package:flutter/material.dart';
import 'package:progamify/api/discussion_service.dart';

class WriteDiscussionScreen extends StatefulWidget {
  final int lessonId;
  const WriteDiscussionScreen({super.key, required this.lessonId});

  @override
  WriteDiscussionScreenState createState() => WriteDiscussionScreenState();
}

class WriteDiscussionScreenState extends State<WriteDiscussionScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController questionController = TextEditingController();

  Future<void> _submitDiscussion() async {
    _showLoadingDialog();

    try {
      await DiscussionService().submitDiscussion(
          widget.lessonId, titleController.text, questionController.text);
      Navigator.pop(context); // Close loading dialog
      _showSuccessDialog();
    } catch (error) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog(error.toString());
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Posting your discussion...")
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Discussion successfully posted!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to post discussion: $message"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

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
            const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(width: 10),
                Text(
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
                onPressed: _submitDiscussion,
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
