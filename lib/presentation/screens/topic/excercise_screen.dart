import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progamify/api/exercise_service.dart';
import 'package:progamify/presentation/screens/topic/exercise_result_page.dart';
import 'package:logger/logger.dart';

class ExerciseScreen extends StatefulWidget {
  final int exerciseId;
  const ExerciseScreen({super.key, required this.exerciseId});

  @override
  ExerciseScreenState createState() => ExerciseScreenState();
}

class ExerciseScreenState extends State<ExerciseScreen> {
  int currentQuestionIndex = 0;
  dynamic selectedAnswer;
  final ScrollController _scrollController = ScrollController();
  List<int> selectedAnswers = [];
  List<Map<String, dynamic>> userAnswers = [];
  Map<int, dynamic> jawabanUser = {};

  late Future<Map<String, dynamic>> _questionsFuture;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _questionsFuture = ExerciseService().getExercise(widget.exerciseId);
  }

  void _nextQuestion(dynamic questions) {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;

        if (jawabanUser[currentQuestionIndex] != null) {
          selectedAnswer = jawabanUser[currentQuestionIndex]["index_jawaban"];
        } else {
          selectedAnswer = null;
        }

        _scrollToCurrentQuestion();
      });
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;

        if (jawabanUser[currentQuestionIndex] != null) {
          selectedAnswer = jawabanUser[currentQuestionIndex]["index_jawaban"];
        } else {
          selectedAnswer = null;
        }
        _scrollToCurrentQuestion();
      });
    }
  }

  void _scrollToCurrentQuestion() {
    _scrollController.animateTo(
      currentQuestionIndex * 50.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final question = questions[currentQuestionIndex];
    // int exp = question['exp'];
    // int pts = question['pts'];

    return FutureBuilder<Map<String, dynamic>>(
      future: _questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No questions available.'));
        }

        final response = snapshot.data!;
        final questionsData = response["questions"];

        List<Map<String, dynamic>> questions = [];
        for (int i = 0; i < questionsData.length; i++) {
          var question = questionsData[i];
          if (question["type"] == "multiple_choice") {
            List<Map<String, dynamic>> options = [];
            question["answers"].forEach((answer) {
              var option = {"id": answer["ID"], "text": answer["content"]};
              options.add(option);
            });
            var q = {
              'id': question["ID"],
              'question': question["content"],
              'options': options,
              'correctAnswer': 1,
              'explanation': question["feedback"],
              'exp': question["exp"],
              'pts': question["point"],
              'type': question["type"]
            };
            questions.add(q);
          } else if (question["type"] == "true_false") {
            var q = {
              'id': question["ID"],
              'question': question["content"],
              'options': ["True", "False"],
              'correctAnswer': 0,
              'explanation': question["feedback"],
              'exp': question["exp"],
              'pts': question["point"],
              'type': question["type"]
            };
            questions.add(q);
          } else if (question["type"] == "essay") {
            var q = {
              'id': question["ID"],
              'question': question["content"],
              'correctAnswer': 0,
              'explanation': question["feedback"],
              'exp': question["exp"],
              'pts': question["point"],
              'type': question["type"]
            };
            questions.add(q);
          } else if (question["type"] == "short_answer") {
            var q = {
              'id': question["ID"],
              'question': question["content"],
              'correctAnswer': '-',
              'explanation': question["feedback"],
              'exp': question["exp"],
              'pts': question["point"],
              'type': 'shortAnswer'
            };
            questions.add(q);
          } else if (question["type"] == "multiple_answer") {
            List<Map<String, dynamic>> options = [];
            question["answers"].forEach((answer) {
              var option = {"id": answer["ID"], "text": answer["content"]};
              options.add(option);
            });
            var q = {
              'id': question["ID"],
              'question': question["content"],
              'options': options,
              'correctAnswer': 1,
              'explanation': question["feedback"],
              'exp': question["exp"],
              'pts': question["point"],
              'type': "multiple_answer"
            };
            questions.add(q);
          }
        }

        // logger.i(questions);

        final question = questions[currentQuestionIndex];

        int exp = question['exp'];
        int pts = question['pts'];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+$exp exp',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '+$pts pts',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _showExitConfirmationDialog,
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _goToQuestion(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == currentQuestionIndex
                                  ? const Color(0xFF6FBAFF)
                                  : Colors.grey[300],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                color: index == currentQuestionIndex
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Html(data: question["question"], style: {
                    "p": Style(
                        fontSize: FontSize(18), textAlign: TextAlign.justify),
                  }),
                  // Text(
                  //   "${question['id']}",
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  _buildOptions(questions),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            currentQuestionIndex > 0 ? _previousQuestion : null,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFFFFFFF),
                        ),
                        label: const Text(
                          'Previous',
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentQuestionIndex > 0
                              ? const Color(0xFF6FBAFF)
                              : Colors.grey[400],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: currentQuestionIndex < questions.length - 1
                            ? () => _nextQuestion(questions)
                            : () => _showSubmitDialog(questions),
                        icon: Icon(
                            currentQuestionIndex < questions.length - 1
                                ? Icons.arrow_forward
                                : Icons.check,
                            color: const Color(0xFFFFFFFF)),
                        label: Text(
                          currentQuestionIndex < questions.length - 1
                              ? 'Next'
                              : 'Submit',
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              currentQuestionIndex < questions.length - 1
                                  ? const Color(0xFF6FBAFF)
                                  : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCard(dynamic question, int index, String text) {
    bool isSelected = selectedAnswer == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = index;
          _saveUserAnswer(currentQuestionIndex, text, index, question);
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
              backgroundColor: isSelected ? Colors.blue : Colors.grey.shade400,
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
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

  void _saveUserAnswer(
      int indexSoal, String answer, int indexJawaban, dynamic question) {
    // jawabanUser[indexSoal] = answer;

    if (question["type"] == "multiple_choice") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answer_id": question["options"][indexJawaban]["id"],
        "answer_text": question["options"][indexJawaban]["text"],
        "index_jawaban": indexJawaban
      };
      jawabanUser[indexSoal] = detailJawaban;
    } else if (question["type"] == "true_false") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answer_text": question["options"][indexJawaban],
        "index_jawaban": indexJawaban
      };
      jawabanUser[indexSoal] = detailJawaban;
    } else if (question["type"] == "essay" ||
        question["type"] == "shortAnswer") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "index_jawaban": answer,
      };
      jawabanUser[indexSoal] = detailJawaban;
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
      jawabanUser[indexSoal] = detailJawaban;
    }

    logger.i(jawabanUser);
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;

      if (jawabanUser[currentQuestionIndex] != null) {
        selectedAnswer = jawabanUser[currentQuestionIndex]["index_jawaban"];
      } else {
        selectedAnswer = null;
      }
    });
    _scrollToCurrentQuestion();
  }

  void _showSubmitDialog(dynamic questions) {
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
              onPressed: () {
                if (selectedAnswer != null) {
                  // _saveUserAnswer(
                  //   currentQuestionIndex,
                  //   questions[currentQuestionIndex]['options'][selectedAnswer],
                  // );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExerciseResultScreen(
                            userAnswers: [],
                          )),
                );
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

  Widget _buildOptions(dynamic questions) {
    final question = questions[currentQuestionIndex];
    final String type = question['type'];
    final options = question['options'] ?? []; // Pastikan options tidak null

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
            _saveUserAnswer(currentQuestionIndex, selectedAnswer, 0, question);
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
            _saveUserAnswer(currentQuestionIndex, selectedAnswer, 0, question);
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
          _saveUserAnswer(currentQuestionIndex, text, index, question);
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
            Expanded(
                child: Html(
              data: text,
              style: {"p": Style(fontSize: FontSize(16))},
            )),
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
          _saveUserAnswer(currentQuestionIndex, text, index, question);
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
}
