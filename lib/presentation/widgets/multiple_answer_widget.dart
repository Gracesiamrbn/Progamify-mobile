import 'package:flutter/material.dart';
import 'package:progamify/models/question_model.dart';

class MultipleAnswerWidget extends StatefulWidget {
  final Question question;

  const MultipleAnswerWidget({super.key, required this.question});

  @override
  _MultipleAnswerWidgetState createState() => _MultipleAnswerWidgetState();
}

class _MultipleAnswerWidgetState extends State<MultipleAnswerWidget> {
  List<int> selectedAnswers = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question.questionText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...List.generate(widget.question.options!.length, (index) {
          return CheckboxListTile(
            title: Text(widget.question.options![index]),
            value: selectedAnswers.contains(index),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedAnswers.add(index);
                } else {
                  selectedAnswers.remove(index);
                }
              });
            },
          );
        }),
      ],
    );
  }
}
