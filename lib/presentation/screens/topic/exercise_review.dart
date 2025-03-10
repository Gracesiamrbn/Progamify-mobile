import 'package:flutter/material.dart';

class ReviewExerciseScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userAnswers;

  const ReviewExerciseScreen({Key? key, required this.userAnswers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Exercise")),
      body: ListView.builder(
        itemCount: userAnswers.length,
        itemBuilder: (context, index) {
          final answer = userAnswers[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Q${index + 1}: ${answer['question']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Your Answer: ${answer['userAnswer']}",
                    style: TextStyle(
                      color: answer['isCorrect'] ? Colors.green : Colors.red,
                    ),
                  ),
                  Text("Correct Answer: ${answer['correctAnswer']}"),
                  Text("Explanation: ${answer['explanation']}"),
                  Text("Points: ${answer['points']} | Exp: ${answer['exp']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
