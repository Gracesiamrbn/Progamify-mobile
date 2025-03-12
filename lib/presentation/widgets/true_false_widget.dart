import 'package:flutter/material.dart';

class TrueFalseWidget extends StatelessWidget {
  final Map<String, dynamic> questionData;

  const TrueFalseWidget(this.questionData, {super.key, required question});

  @override
  Widget build(BuildContext context) {
    bool correctAnswer = questionData['correctAnswer'];
    bool userAnswer = questionData['userAnswer'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(questionData['question'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Text(userAnswer ? 'True' : 'False', style: TextStyle(color: userAnswer == correctAnswer ? Colors.green : Colors.red)),
          ],
        ),
      ],
    );
  }
}
