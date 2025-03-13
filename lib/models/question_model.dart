enum QuestionType { multipleChoice, trueFalse, shortAnswer, multipleAnswer, essay }

class Question {
  final String questionText;
  final QuestionType type;
  final List<String>? options;
  final List<int>? correctAnswers;
  final bool? correctBool;
  final String? correctText;

  Question({
    required this.questionText,
    required this.type,
    this.options,
    this.correctAnswers,
    this.correctBool,
    this.correctText,
  });
}
