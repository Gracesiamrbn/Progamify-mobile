import 'package:flutter/material.dart';

class MultipleChoiceWidget extends StatelessWidget {
  final Map<String, dynamic> questionData;

  const MultipleChoiceWidget(this.questionData, {super.key, required question});

  @override
  Widget build(BuildContext context) {
    int correctIndex = questionData['correctAnswer'];
    int userIndex = questionData['userAnswer'] ?? -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(questionData['question'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...List.generate(questionData['options'].length, (index) {
          bool isCorrect = index == correctIndex;
          bool isUserChoice = index == userIndex;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUserChoice ? (isCorrect ? Colors.green : Colors.red) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Text(
              "${String.fromCharCode(65 + index)}. ${questionData['options'][index]}",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          );
        }),
      ],
    );
  }
}
