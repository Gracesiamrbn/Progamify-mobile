import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/topic/exercise_review.dart';
import 'package:intl/intl.dart';

class ExerciseResultScreen extends StatelessWidget {
  const ExerciseResultScreen({super.key, required this.userAnswers});
  final List<Map<String, dynamic>> userAnswers;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> result = userAnswers[0];

    DateTime dateTime = DateTime.parse(result["CreatedAt"]);
    String createdAt = DateFormat('EEEE, dd MMMM yyyy').format(dateTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Exercise',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Exercise 1 : Preliminary',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // Gambar (Ganti dengan asset yang sesuai)
            Center(
              child: Image.asset(
                'assets/icons/exam_icon.png', // Ganti dengan path gambarmu
                height: 100,
              ),
            ),

            const SizedBox(height: 15),

            // Detail soal
            Text(
              'Questions total : ${result["total_question"]}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Exp Reward    : ${result["total_exp"]}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Coin Reward   : ${result["total_point"]}',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            // Card Ringkasan Hasil
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary of your attempt',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Divider(),
                    Text(
                      'Grade               : ${result["score"] * 100} / 100',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Correct Answer : ${result["total_correct"]}/${result["total_question"]}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Exp gain           : ${result["total_exp"]}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Point gain         : ${result["total_point"]}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Time submitted  : $createdAt',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Button View Detail
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReviewExerciseScreen(userAnswers: [result]),
                      ),
                    );
                  },
                  icon: const Text(
                    'View Detail',
                    style: TextStyle(color: Colors.white),
                  ),
                  label: const Icon(Icons.visibility, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
