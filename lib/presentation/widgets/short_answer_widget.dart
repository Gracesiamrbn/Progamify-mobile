import 'package:flutter/material.dart';

class ShortAnswerWidget extends StatelessWidget {
  final Map<String, dynamic> questionData;

  const ShortAnswerWidget(this.questionData, {super.key, required question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(questionData['question'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Your Answer: ${questionData['userAnswer']}', style: const TextStyle(color: Colors.blue)),
        Text('Correct Answer: ${questionData['correctAnswer']}', style: const TextStyle(color: Colors.green)),
      ],
    );
  }
}
