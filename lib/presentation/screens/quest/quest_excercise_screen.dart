import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:progamify/api/quest_service.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import '../topic/exercise_result_page.dart';

// import 'quest_menu_screen.dart';

class QuestExcerciseScreen extends StatefulWidget {
  final int userId;
  const QuestExcerciseScreen({super.key, required this.userId});

  @override
  QuestExcerciseScreenState createState() => QuestExcerciseScreenState();
}

class QuestExcerciseScreenState extends State<QuestExcerciseScreen> {
  // int? selectedOption;
  int questId = 0;
  dynamic selectedAnswer;
  List<int> selectedAnswers = [];
  List<Map<String, dynamic>> userAnswers = [];
  Map<String, dynamic> jawabanUser = {};

  late Future<Map<String, dynamic>> _questionsFuture;

  final logger = Logger();

  int _seconds = 2 * 60;
  late Timer _timer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundPlayed = false;

  @override
  void initState() {
    super.initState();
    // logger.i("initState: Fetching quest data for user ${widget.userId}");
    _questionsFuture = Future.delayed(
      const Duration(seconds: 2),
      () => QuestService().getQuest(widget.userId),
    );
    _startTimer();
  }

  void _playSoundEffect() async {
    if (!_isSoundPlayed) {
      _isSoundPlayed = true;
      await _audioPlayer
          .play(AssetSource('audio/spongebob-bubble-transition.mp3'));
    }
  }

  void _stopSoundEffect() async {
    if (_isSoundPlayed) {
      await _audioPlayer.stop();
      _isSoundPlayed = false;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // logger.i("FutureBuilder: Waiting for data...");
          // return const Center(child: CircularProgressIndicator());
          _playSoundEffect();
          return Container(
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: -100,
                  right: -100,
                  child: Center(
                    child: Lottie.asset(
                      'assets/animation/Animation - 1741658093124.json',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width + 200,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Lottie.asset(
                          'assets/animation/Animation - 1741625662616.json'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Search the quest...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          _stopSoundEffect();
          logger.e("FutureBuilder Error: ${snapshot.error}");
          return Center(child: Text('Snapshot hasError: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.hasError) {
          _stopSoundEffect();
          // logger.w("FutureBuilder Warning: No questions available.");
          return const Center(child: Text('No questions available.'));
        } else {
          _stopSoundEffect();

          final response = snapshot.data!;

          questId = response["ID"];

          final question = response["content"];

          final type = response["type"];
          // logger.i(
          //     'FutureBuilder: Data fetched successfully. with question : $question');

          Map<String, dynamic> questions = {};
          if (type == "multiple_choice") {
            // logger.d("Processing multiple_choice question.");
            List<Map<String, dynamic>> options = [];
            response["answers"].forEach((answer) {
              var option = {"id": answer["ID"], "text": answer["content"]};
              options.add(option);
            });
            questions = {
              'id': response["ID"],
              'question': response["content"],
              'options': options,
              'correctAnswer': 1,
              'explanation': response["feedback"],
              'exp': response["exp"],
              'pts': response["point"],
              'type': response["type"]
            };
            // questions.add(q);
          } else if (type == "true_false") {
            // logger.d("Processing true_false question.");
            questions = {
              'id': response["ID"],
              'question': response["content"],
              'options': ["True", "False"],
              'correctAnswer': 0,
              'explanation': response["feedback"],
              'exp': response["exp"],
              'pts': response["point"],
              'type': response["type"]
            };
            // logger.i('Successfully fetching question : $questions');
            // questions.add(q);
          } else if (type == "essay") {
            // logger.d("Processing essay question.");
            questions = {
              'id': response["ID"],
              'question': response["content"],
              'correctAnswer': 0,
              'explanation': response["feedback"],
              'exp': response["exp"],
              'pts': response["point"],
              'type': type
            };
            // questions.add(q);
          } else if (type == "short_answer") {
            // logger.d("Processing short_answer question.");
            questions = {
              'id': question["ID"],
              'question': question["content"],
              'correctAnswer': '-',
              'explanation': response["feedback"],
              'exp': response["exp"],
              'pts': response["point"],
              'type': 'shortAnswer'
            };
            // questions.add(q);
          } else if (question["type"] == "multiple_answer") {
            // logger.d("Processing multiple_answer question.");
            List<Map<String, dynamic>> options = [];
            question["answers"].forEach((answer) {
              var option = {"id": answer["ID"], "text": answer["content"]};
              options.add(option);
            });
            questions = {
              'id': question["ID"],
              'question': question["content"],
              'options': options,
              'correctAnswer': 1,
              'explanation': response["feedback"],
              'exp': response["exp"],
              'pts': response["point"],
              'type': "multiple_answer"
            };
            // questions.add(q);
          } else {
            logger.w("Unknown question type: ${response["type"]}");
          }

          // final question = questions[currentQuestionIndex];

          // int exp = response['exp'];
          // logger.i("Sucess fetch exp : ${response["exp"]}");
          // int pts = response['point'];
          // logger.i("Sucess fetch point : ${response["point"]}");

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFFE7F4E8),
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      response['difficulty'] ?? 'Easy',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formatTime(_seconds),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showExitConfirmationDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
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
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Html(data: response["content"], style: {
                      "p": Style(
                          fontSize: FontSize(18), textAlign: TextAlign.justify),
                    }),
                    const SizedBox(height: 20),
                    _buildOptions(questions),
                    const SizedBox(height: 40),
                    // const Spacer(),
                    // const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: selectedAnswer != null
                          ? () => _showConfirmationDialog(questions)
                          : null,
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildOptions(dynamic question) {
    final String type = question['type'];
    final options = question['options'] ?? [];

    if (type == 'essay') {
      TextEditingController textController = TextEditingController();

      if (selectedAnswer != null) {
        textController.text = selectedAnswer;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: textController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Masukkan jawaban Anda...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            selectedAnswer = value;
            _saveUserAnswer(selectedAnswer, 0, question);
          },
        ),
      );
    }

    if (type == 'shortAnswer') {
      TextEditingController textController = TextEditingController();

      if (selectedAnswer != null) {
        textController.text = selectedAnswer;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: textController,
          maxLines: 1, // Biar textarea lebih besar
          decoration: InputDecoration(
            hintText: "Masukkan jawaban Anda...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            selectedAnswer = value;
            _saveUserAnswer(selectedAnswer, 0, question);
          },
        ),
      );
    }

    if (options.isEmpty) {
      return const Text("No options available",
          style: TextStyle(color: Colors.red));
    }

    if (type == 'true_false') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(options.length, (index) {
          return _buildTrueFalseCard(question, index, options[index]);
        }),
      );
    } else if (type == 'multiple_answer') {
      return SizedBox(
        height: MediaQuery.of(context).size.height *
            0.5, // Maksimal 50% tinggi layar
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return _buildCheckboxOption(
                question, index, options[index]["text"]);
          },
        ),
      );
    } else {
      return Column(
        children: List.generate(options.length, (index) {
          return _buildOptionCard(question, index, options[index]["text"]);
        }),
      );
    }
  }

  Widget _buildCheckboxOption(dynamic question, int index, String text) {
    bool isSelected = selectedAnswers.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedAnswers.remove(index);
          } else {
            selectedAnswers.add(index);
          }
          _saveUserAnswer(text, index, question);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedAnswers.add(index);
                  } else {
                    selectedAnswers.remove(index);
                  }
                });
              },
            ),
            const SizedBox(width: 10),
            Flexible(
                fit: FlexFit.loose,
                child: Html(
                  data: text,
                  style: {"p": Style(fontSize: FontSize(16))},
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(dynamic question, int index, String text) {
    bool isSelected = selectedAnswer == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = index;
          _saveUserAnswer(text, index, question);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isSelected ? Colors.blue : const Color(0xFFD9D9D9),
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              fit: FlexFit.loose,
              // Wrap Html with Expanded to give it space
              child: Html(
                data: text,
                style: {
                  "p": Style(
                      textAlign: TextAlign.justify, fontSize: FontSize(16)),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrueFalseCard(dynamic question, int index, String text) {
    bool isSelected = selectedAnswer == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = index;
          _saveUserAnswer(text, index, question);
        });
      },
      child: Container(
        width: 142, // Ukuran kartu biar pas berdampingan
        height: 142,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(dynamic questions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Submit',
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
                'Are you sure to submit the answer?',
                textAlign: TextAlign.center,
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
              onPressed: () async {
                if (selectedAnswer != null) {
                  var result =
                      await QuestService().submitQuest(questId, jawabanUser);

                  Logger().i(result);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExerciseResultScreen(
                              userAnswers: [result],
                            )),
                  );
                }
                // Navigator.pop(context);
                // Navigator.pop(context);
              },
              child: const Text(
                'Submit',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
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
                'Your progress will not be saved and you will not get the reward',
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

  void _saveUserAnswer(String answer, int indexJawaban, dynamic question) {
    // jawabanUser[indexSoal] = answer;

    if (question["type"] == "multiple_choice") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answer_id": question["options"][indexJawaban]["id"],
        "answer_text": question["options"][indexJawaban]["text"],
        "index_jawaban": indexJawaban
      };
      // jawabanUser[indexSoal] = detailJawaban;
      jawabanUser = detailJawaban;
    } else if (question["type"] == "true_false") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answer_text": question["options"][indexJawaban],
        "index_jawaban": indexJawaban
      };
      // jawabanUser[indexSoal] = detailJawaban;
      jawabanUser = detailJawaban;
    } else if (question["type"] == "essay" ||
        question["type"] == "shortAnswer") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "index_jawaban": answer,
      };
      // jawabanUser[indexSoal] = detailJawaban;
      jawabanUser = detailJawaban;
    } else if (question["type"] == "multiple_answer") {
      List<Map<String, dynamic>> answers = [];
      if (selectedAnswers.isNotEmpty) {
        selectedAnswers.forEach((ans) {
          answers.add({
            "answer_id": question["options"][ans]["id"],
            "answer_text": question["options"][ans]["text"],
          });
        });
      }
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answers": answers,
        "index_jawaban": selectedAnswers
      };
      // jawabanUser[indexSoal] = detailJawaban;
      jawabanUser = detailJawaban;
    }

    logger.i(jawabanUser);
  }
}
