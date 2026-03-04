import 'package:flutter/material.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  bool isSubmitted = false;

  final List<String?> userAnswers = List.filled(4, null);

  /// SOAL PEMROGRAMAN
  final List<String> questions = [
    'Digunakan untuk menyimpan nilai atau data di dalam program.',
    'Digunakan untuk pengambilan keputusan berdasarkan kondisi tertentu.',
    'Digunakan untuk menjalankan blok kode secara berulang.',
    'Digunakan untuk mengelompokkan kode agar dapat dipanggil kembali.',
  ];

  /// JAWABAN BENAR
  final List<String> correctAnswers = [
    'Variable',
    'Conditional',
    'Loop',
    'Function',
  ];

  /// OPSI DROPDOWN
  final List<String> options = [
    'Variable',
    'Conditional',
    'Loop',
    'Function',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Matching Programming Concept'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return _questionItem(index);
                },
              ),
            ),
            if (isSubmitted) ...[
              const SizedBox(height: 8),
              _rewardGain(),
              const SizedBox(height: 12),
              _answerExplanation(),
            ],
            const SizedBox(height: 12),
            _bottomAction(),
          ],
        ),
      ),
    );
  }

  /// HEADER
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Question',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 140,
            child: Text(
              'Answer',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// QUESTION ITEM
  Widget _questionItem(int index) {
    final bool isCorrect = userAnswers[index] == correctAnswers[index];

    Color borderColor = Colors.transparent;
    Color bgColor = Colors.white;

    if (isSubmitted) {
      borderColor = isCorrect ? Colors.green : Colors.red;
      bgColor = isCorrect ? Colors.green.shade50 : Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// QUESTION
          Expanded(
            child: Text(
              '${index + 1}. ${questions[index]}',
              style: const TextStyle(fontSize: 13),
            ),
          ),

          const SizedBox(width: 12),

          /// DROPDOWN
          SizedBox(
            width: 140,
            child: DropdownButtonFormField<String>(
              initialValue: userAnswers[index],
              hint: const Text('Select'),
              items: options
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: isSubmitted
                  ? null
                  : (value) {
                      setState(() {
                        userAnswers[index] = value;
                      });
                    },
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// REWARD
  Widget _rewardGain() {
    return const Row(
      children: [
        Text(
          'Reward Gain',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Icon(Icons.star, color: Colors.orange, size: 18),
        SizedBox(width: 4),
        Text('+10 exp'),
        SizedBox(width: 12),
        Icon(Icons.diamond, color: Colors.purple, size: 18),
        SizedBox(width: 4),
        Text('+10 point'),
      ],
    );
  }

  /// EXPLANATION
  Widget _answerExplanation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(questions.length, (index) {
          final isCorrect = userAnswers[index] == correctAnswers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${index + 1}. Your answer is ${isCorrect ? "correct" : "incorrect"}'
              '${isCorrect ? "" : ". Correct answer is ${correctAnswers[index]}"}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          );
        }),
      ),
    );
  }

  /// BUTTON
  Widget _bottomAction() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isSubmitted = false;
              for (int i = 0; i < userAnswers.length; i++) {
                userAnswers[i] = null;
              }
            });
          },
          child: const Text('Previous'),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isSubmitted = true;
            });
          },
          child: const Text('Next'),
        ),
      ],
    );
  }
}
