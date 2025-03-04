import 'package:flutter/material.dart';

class ReviewExerciseScreen extends StatefulWidget {
  @override
  _ReviewExerciseScreenState createState() => _ReviewExerciseScreenState();
}

class _ReviewExerciseScreenState extends State<ReviewExerciseScreen> {
  int currentQuestionIndex = 0;

  final List<Map<String, dynamic>> userAnswers = [
    {
      'question': 'Who invented Turing Machine?',
      'options': [
        'Enrico Hezkiel Sirait',
        'Boy Martahana Sitorus',
        'Emely Angelica Lestari',
        'Alan Turing'
      ],
      'correctAnswer': 3,
      'userAnswer': 3,
      'explanation':
          'The Turing machine was invented in 1936 by Alan Turing, who called it an "a-machine" (automatic machine).',
      'exp': 10,
      'pts': 10
    },
    {
      'question': 'What is the capital of France?',
      'options': ['Berlin', 'Madrid', 'Paris', 'Rome'],
      'correctAnswer': 2,
      'userAnswer': 1,
      'explanation': 'The capital of France is Paris.',
      'exp': 0,
      'pts': 0
    },
  ];

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionData = userAnswers[currentQuestionIndex];
    int correctIndex = (questionData['correctAnswer'] ?? -1) as int;
    int userIndex = (questionData['userAnswer'] ?? -1) as int;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${questionData['exp']} exp',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${questionData['pts']} pts',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Exit',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.exit_to_app, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Progress Bar
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(userAnswers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                        backgroundColor: currentQuestionIndex == index
                            ? Colors.white
                            : Colors.grey,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                              color: currentQuestionIndex == index
                                  ? Colors.blue
                                  : Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questionData['question'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      // Options
                      ...List.generate(questionData['options'].length, (index) {
                        bool isCorrect = index == correctIndex;
                        bool isUserChoice = index == userIndex;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUserChoice
                                ? (isCorrect ? Colors.green : Colors.red)
                                : Colors.white,
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
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        );
                      }),

                      const SizedBox(height: 10),
                      const Text("Reward Gain"),
                      Row(
                        children: [
                          Text(
                            "+${questionData['exp']} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Image.asset("assets/icons/exp_point_1.png",
                              height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Explanation Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // ✅ Gunakan Container, bukan Expanded
              width: double.infinity,
              height:
                  MediaQuery.of(context).size.height * 0.35, // FIX 1/2 layar
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    // ✅ Expanded hanya untuk konten yang bisa discroll
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Answer Explanation",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Answer: ${String.fromCharCode(65 + correctIndex)}. ${questionData['options'][correctIndex]}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Your Answer: ${String.fromCharCode(65 + userIndex)}. ${questionData['options'][userIndex]}",
                            style: TextStyle(
                                color: userIndex == correctIndex
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Explanation:\n${questionData['explanation']}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ Tombol Next & Previous tetap ada di dalam panel biru
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: currentQuestionIndex > 0
                              ? () => _goToQuestion(currentQuestionIndex - 1)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("⬅ Previous"),
                        ),
                        ElevatedButton(
                          onPressed: currentQuestionIndex <
                                  userAnswers.length - 1
                              ? () => _goToQuestion(currentQuestionIndex + 1)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Next ➡"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Want to Quit ?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'assets/icons/exit_icon.png',
                height: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your progress will not be saved and you will not get the XP',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text(
                'Yes, Quit',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
