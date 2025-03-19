import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:progamify/api/discussion_service.dart';
import 'package:progamify/api/user_service.dart';
import 'package:progamify/presentation/screens/topic/topic_course_screen.dart';

class WriteDiscussionScreen extends StatefulWidget {
  final int lessonId;
  final String topicTitle;
  final int topicId;
  final int totalLesson;
  final int totalExercise;
  const WriteDiscussionScreen(
      {super.key,
      required this.lessonId,
      required this.topicTitle,
      required this.topicId,
      required this.totalLesson,
      required this.totalExercise});

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

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicCourseScreen(
                      topicTitle: widget.topicTitle,
                      lessonId: widget.lessonId,
                      courseTitle: "",
                      isFromDisc: true,
                      topicId: widget.topicId,
                      totalLesson: widget.totalLesson,
                      totalExercise: widget.totalExercise,
                    ),
                  ),
                );
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
    return FutureBuilder<Map<String, dynamic>>(
        future: UserService().getCurrentUser(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            Map<String, dynamic> user = snapshot.data!;

            Logger().i(user);

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
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: SvgPicture.asset(
                            "assets/avatars/avatar_male_1.svg",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          user["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("Title",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Type your title...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Question",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
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
          } else {
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
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: SvgPicture.asset(
                            "assets/avatars/avatar_male_1.svg",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Enrico Sirait',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("Title",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Type your title...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Question",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
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
        });
  }
}
