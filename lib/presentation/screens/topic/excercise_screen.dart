import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:progamify/api/exercise_service.dart';
import 'package:progamify/presentation/screens/topic/exercise_result_page.dart';
import 'package:logger/logger.dart';

class ExerciseScreen extends StatefulWidget {
  final int exerciseId;
  final int topicId;
  final String topicTitle;
  final int totalLesson;
  final int totalExercise;
  const ExerciseScreen(
      {super.key,
      required this.exerciseId,
      required this.topicId,
      required this.topicTitle,
      required this.totalLesson,
      required this.totalExercise});

  @override
  ExerciseScreenState createState() => ExerciseScreenState();
}

class ExerciseScreenState extends State<ExerciseScreen> {
  bool isLoading = false;
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

  Future<void> _submitExercise() async {
    setState(() {
      isLoading = true;
    });

    Navigator.pop(context);

    _showSubmitDialog();

    try {
      var result = await ExerciseService()
          .submitExercise(widget.exerciseId, jawabanUser);

      Logger().i("Result: $result");

      // Cek apakah result memiliki achievement
      if (result["achievement"] != null && result["achievement"].isNotEmpty) {
        await _showPopUpAchievement(result["achievement"]);
      }

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseResultScreen(
            userAnswers: [result],
            topicId: widget.topicId,
            topicTitle: widget.topicTitle,
            totalExercise: widget.totalExercise,
            totalLesson: widget.totalLesson,
          ),
        ),
      );
    } catch (e) {
      Logger().e("Error submitting exercise: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _nextQuestion(dynamic questions) {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;

        if (jawabanUser[currentQuestionIndex] != null) {
          selectedAnswer = jawabanUser[currentQuestionIndex]["index_jawaban"];
          if (jawabanUser[currentQuestionIndex]["type"] == "multiple_answer") {
            logger.i(selectedAnswers);
            selectedAnswers.clear();
            selectedAnswers
                .addAll(jawabanUser[currentQuestionIndex]["index_jawaban"]);
            logger.i(selectedAnswers);
          }
        } else {
          selectedAnswer = null;
          selectedAnswers.clear();
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
          if (jawabanUser[currentQuestionIndex]["type"] == "multiple_answer") {
            logger.i(selectedAnswers);
            selectedAnswers.clear();
            selectedAnswers
                .addAll(jawabanUser[currentQuestionIndex]["index_jawaban"]);
            logger.i(selectedAnswers);
          }
        } else {
          selectedAnswer = null;
          selectedAnswers.clear();
        }
        _scrollToCurrentQuestion();
      });
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;

      if (jawabanUser[currentQuestionIndex] != null) {
        selectedAnswer = jawabanUser[currentQuestionIndex]["index_jawaban"];
        if (jawabanUser[currentQuestionIndex]["type"] == "multiple_answer") {
          logger.i(selectedAnswers);
          selectedAnswers.clear();
          selectedAnswers
              .addAll(jawabanUser[currentQuestionIndex]["index_jawaban"]);
          logger.i(jawabanUser[currentQuestionIndex]);
        }
      } else {
        selectedAnswer = null;
        selectedAnswers.clear();
      }
    });
    _scrollToCurrentQuestion();
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
          } else if (question["type"] == "matching") {
            List<String> keywords = [];
            List<String> explanations = [];
            Set<String> uniqueExplanations = {};

            // Try to parse content as JSON if it's a string
            dynamic matchingData = question["content"];
            if (matchingData is String) {
              try {
                matchingData = jsonDecode(matchingData);
              } catch (e) {
                // If not JSON, treat as regular content
                logger.w("Failed to parse matching content as JSON: $e");
                matchingData = [];
              }
            }

            // Extract from parsed data
            if (matchingData is List) {
              matchingData.forEach((item) {
                if (item is Map) {
                  if (item["keyword"] != null) {
                    keywords.add(item["keyword"].toString());
                  }
                  if (item["explanation"] != null) {
                    uniqueExplanations.add(item["explanation"].toString());
                  }
                }
              });
            }

            // Also try from answers if keywords still empty
            if (keywords.isEmpty && question["answers"] != null) {
              question["answers"].forEach((answer) {
                if (answer["keyword"] != null) {
                  keywords.add(answer["keyword"].toString());
                }
                if (answer["explanation"] != null) {
                  uniqueExplanations.add(answer["explanation"].toString());
                }
              });
            }

            explanations = uniqueExplanations.toList();

            // Debug logging
            logger.i("Matching keywords: $keywords");
            logger.i("Matching explanations: $explanations");

            var q = {
              'id': question["ID"],
              'question': question["content"],
              'keywords': keywords,
              'explanations': explanations,
              'correctAnswer': 1,
              'explanation': question["feedback"],
              'exp': question["exp"],
              'pts': question["point"],
              'type': "matching"
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
                  if (question['type'] != 'matching')
                    Html(data: question["question"], style: {
                      "p": Style(
                          fontSize: FontSize(18), textAlign: TextAlign.justify),
                    }),
                  if (question['type'] != 'matching')
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
                            : () => _showSubmitDialog(),
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

  Widget _buildMatching(dynamic question) {
    final List<String> keywords = question['keywords'] ?? [];
    final List<String> explanations = question['explanations'] ?? [];

    if (jawabanUser[currentQuestionIndex] == null) {
      jawabanUser[currentQuestionIndex] = {
        "question_id": question["id"],
        "answers": List<Map<String, dynamic>>.filled(explanations.length, {}),
        "type": "matching"
      };
    }

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Explanation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 140,
                child: Text(
                  'Keyword',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Matching Items - Display Explanation on Left, Keyword Dropdown on Right
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: explanations.length,
          itemBuilder: (context, index) {
            return _buildMatchingCard(
              question,
              index,
              explanations[index],
              keywords,
            );
          },
        ),
      ],
    );
  }

  Widget _buildMatchingCard(
    dynamic question,
    int index,
    String explanation,
    List<String> keywords,
  ) {
    final answers = jawabanUser[currentQuestionIndex]?["answers"]
        as List<Map<String, dynamic>>?;
    String? selectedKeyword = answers?[index]?['keyword'];

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.transparent),
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
          // Explanation Text (Left Side)
          Expanded(
            child: Html(
              data: '${index + 1}. $explanation',
              style: {
                "p": Style(
                  fontSize: FontSize(13),
                  textAlign: TextAlign.justify,
                ),
              },
            ),
          ),
          const SizedBox(width: 12),
          // Keyword Dropdown (Right Side)
          SizedBox(
            width: 140,
            child: DropdownButtonFormField<String>(
              value: selectedKeyword,
              hint: const Text('Select'),
              items: keywords
                  .map((kw) => DropdownMenuItem<String>(
                        value: kw,
                        child: Text(
                          kw,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    final answers = jawabanUser[currentQuestionIndex]
                        ?["answers"] as List<Map<String, dynamic>>?;
                    if (answers != null && index < answers.length) {
                      // Save pair: {keyword: selected, explanation: static}
                      answers[index] = {
                        'keyword': value,
                        'explanation': explanation,
                      };
                      _saveUserAnswer(currentQuestionIndex, '', 0, question);
                    }
                  });
                }
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
        "index_jawaban": indexJawaban,
        "type": question["type"]
      };
      jawabanUser[indexSoal] = detailJawaban;
    } else if (question["type"] == "true_false") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answer_text": question['options'][indexJawaban] as String,
        "index_jawaban": indexJawaban,
        "type": question["type"]
      };
      jawabanUser[indexSoal] = detailJawaban;
    } else if (question["type"] == "essay" ||
        question["type"] == "shortAnswer") {
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "index_jawaban": answer,
        "type": question["type"]
      };
      jawabanUser[indexSoal] = detailJawaban;
    } else if (question["type"] == "multiple_answer") {
      List<Map<String, dynamic>> answers = [];
      List<int> indexJawaban = [];
      if (selectedAnswers.isNotEmpty) {
        selectedAnswers.forEach((ans) {
          answers.add({
            "answer_id": question["options"][ans]["id"],
            "answer_text": question["options"][ans]["text"],
          });
          indexJawaban.add(ans);
        });
      }
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answers": answers,
        "index_jawaban": indexJawaban,
        "type": question["type"]
      };
      jawabanUser[indexSoal] = detailJawaban;
    } else if (question["type"] == "matching") {
      List<Map<String, dynamic>> matchingAnswers = [];
      if (jawabanUser[indexSoal] != null &&
          jawabanUser[indexSoal]["answers"] != null) {
        matchingAnswers = jawabanUser[indexSoal]["answers"];
      }
      Map<String, dynamic> detailJawaban = {
        "question_id": question["id"],
        "answers": matchingAnswers,
        "type": question["type"],
        "index_jawaban": 0,
      };
      jawabanUser[indexSoal] = detailJawaban;
    }
  }

  void _showSubmitDialog() {
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
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      await _submitExercise();

                      setState(() {
                        isLoading = false;
                      });
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Yes, Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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

    if (type == 'matching') {
      return _buildMatching(question);
    }

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

  Future<void> _showPopUpAchievement(List<dynamic> achievements) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Achievement Unlocked!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: achievements.map((ach) {
              return ListTile(
                leading: Icon(Icons.emoji_events, color: Colors.amber),
                title: Text(ach["title"]),
                subtitle: Text(ach["description"]),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
