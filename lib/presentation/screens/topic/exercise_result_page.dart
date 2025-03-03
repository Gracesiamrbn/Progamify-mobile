// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/topic/exercise_review.dart';

class ExerciseResultScreen extends StatelessWidget {
  const ExerciseResultScreen({super.key, required this.userAnswers});
  final List<Map<String, dynamic>> userAnswers;


  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Questions total : 10',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              'Exp Reward    : 100 exp',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              'Coin Reward   : 100 coin',
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            // Card Ringkasan Hasil
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary of your attempt',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Divider(),
                    Text(
                      'Grade               : 90 / 100',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Correct Answer : 9/10',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Exp gain           : 90',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Coin gain         : 90',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Time submitted  : Tuesday, 25 February 2025, 11:12 AM',
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
                            ReviewExerciseScreen(userAnswers: userAnswers),
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
