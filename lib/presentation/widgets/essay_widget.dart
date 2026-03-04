import 'package:flutter/material.dart';
import 'package:progamify/models/question_model.dart';

class EssayWidget extends StatelessWidget {
  final Question question;
  final TextEditingController _controller = TextEditingController();

  EssayWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.questionText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextField(
          controller: _controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: "Write your answer here...",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
