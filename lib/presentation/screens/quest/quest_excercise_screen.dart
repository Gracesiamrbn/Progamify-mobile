import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:progamify/api/quest_service.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class QuestExcerciseScreen extends StatefulWidget {
  final int userId;
  const QuestExcerciseScreen({super.key, required this.userId});

  @override
  QuestExcerciseScreenState createState() => QuestExcerciseScreenState();
}

class QuestExcerciseScreenState extends State<QuestExcerciseScreen> {
  // Quest
  int questId = 0;
  dynamic selectedAnswer;
  List<int> selectedAnswers = [];
  List<Map<String, dynamic>> userAnswers = [];
  Map<String, dynamic> jawabanUser = {};
  late Future<Map<String, dynamic>> _questionsFuture;
  Map<String, dynamic>? result;

  // Logger
  final logger = Logger();

  // Timer
  int _seconds = 0;
  Timer? _timer;

  // Audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundPlayed = false;

  // State UI
  bool isPreview = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _questionsFuture = Future.delayed(const Duration(seconds: 2), () async {
      var data = await QuestService().getQuest(widget.userId);
      int fetchedTimer = (data["timer"] ?? 2) * 60;

      setState(() {
        _seconds = fetchedTimer;
      });

      _startTimer();
      return data;
    });
  }

  void _playSoundEffect(audioPath) async {
    if (!_isSoundPlayed) {
      print("[AUDIO] Playing sound: $audioPath");
      _isSoundPlayed = true;
      await _audioPlayer.play(AssetSource(audioPath));
      print("[AUDIO] Sound started: $audioPath");
    } else {
      print("[AUDIO] Sound already playing, skipping: $audioPath");
    }
  }

  void _stopSoundEffect() async {
    if (_audioPlayer.state == PlayerState.playing) {
      print("[AUDIO] Stopping sound...");
      await _audioPlayer.stop();
      await _audioPlayer.release();
      _isSoundPlayed = false;
      print("[AUDIO] Sound stopped and released.");
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        timer.cancel();
        _submitAnswers();
      }
    });
  }

  void _submitAnswers() async {
    setState(() {
      isPreview = true;
    });
    try {
      var response = await QuestService().submitQuest(questId, jawabanUser);
      // _showSubmissionResult(response);
      _showResultDialog(
        context,
        result?["quest"]["is_correct"] ?? false,
        'audio/correct-answer-new.mp3',
        'audio/070-challenge-lose.mp3',
        result?["quest"]['answer']['exp_gained'],
        result?["quest"]['answer']['point_gained'],
        result?["badge"],
      );
      _timer?.cancel();
    } catch (e) {
      // logger.e("Submission failed: $e");
    }
  }

  void _showBadges(List<dynamic> badges, int index) {
    if (index >= badges.length) return;

    var badge = badges[index]["Badge"];

    _playSoundEffect('audio/mixkit-winning-chimes-2015.wav');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Anda mendapat Badge!",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCD7F32),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: Lottie.asset(
                              'assets/animation/Animation - 1740145323974.json',
                              fit: BoxFit.contain,
                              repeat: true,
                            ),
                          ),
                          SvgPicture.asset(
                            badge["picture"]!,
                            width: 120,
                            height: 120,
                          ),
                        ],
                      ),
                      Text(
                        badge["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          color: Color(0xFFFFBB28),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        badge["description"]!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _stopSoundEffect();

                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              _showBadges(badges, index + 1);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9A215),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Lanjutkan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isPreview) {
            return true;
          } else {
            _showExitConfirmationDialog();
            return false;
          }
        },
        child: FutureBuilder<Map<String, dynamic>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              _playSoundEffect('audio/spongebob-bubble-transition.mp3');
              return _buildLoadingScreen();
            }

            if (snapshot.hasError) {
              _stopSoundEffect();
              return Center(
                  child: Text('Snapshot hasError: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.hasError) {
              _stopSoundEffect();
              return const Center(child: Text('No questions available.'));
            } else {
              _stopSoundEffect();

              final response = snapshot.data!;

              questId = response["ID"];

              final question = response["content"];

              final type = response["type"];

              Map<String, dynamic> questions = {};
              if (type == "multiple_choice") {
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
              } else if (type == "true_false") {
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
              } else if (type == "essay") {
                questions = {
                  'id': response["ID"],
                  'question': response["content"],
                  'correctAnswer': 0,
                  'explanation': response["feedback"],
                  'exp': response["exp"],
                  'pts': response["point"],
                  'type': type
                };
              } else if (type == "short_answer") {
                questions = {
                  'id': response["ID"],
                  'question': response["content"],
                  'correctAnswer': '-',
                  'explanation': response["feedback"],
                  'exp': response["exp"],
                  'pts': response["point"],
                  'type': 'shortAnswer'
                };
              } else if (type == "multiple_answer") {
                logger.i("Processing multiple_answer question...");

                List<Map<String, dynamic>> options = [];
                response["answers"].forEach((answer) {
                  var option = {"id": answer["ID"], "text": answer["content"]};
                  options.add(option);

                  // Log setiap jawaban yang diproses
                  logger.d(
                      "Added answer option: ID=${answer["ID"]}, Text=${answer["content"]}");
                });

                // Log hasil list options setelah semua jawaban diproses
                logger.i("Final options list: $options");

                questions = {
                  'id': response["ID"],
                  'question': response["content"],
                  'options': options,
                  'correctAnswer': 1,
                  'explanation': response["feedback"],
                  'exp': response["exp"],
                  'pts': response["point"],
                  'type': "multiple_answer"
                };

                // Log informasi akhir tentang pertanyaan yang diproses
                logger.i(
                    "Question processed successfully: ID=${response["ID"]}, Type=multiple_answer");
              } else {
                logger.w("Unknown question type: ${response["type"]}");
              }
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFFE7F4E8),
                  elevation: 0,
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
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
                        onTap: () {
                          if (isPreview) {
                            Navigator.pop(context);
                          } else {
                            _showExitConfirmationDialog();
                          }
                        },
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Html(data: response["content"], style: {
                          "p": Style(
                              fontSize: FontSize(18),
                              textAlign: TextAlign.justify),
                        }),
                        const SizedBox(height: 20),
                        if (isPreview)
                          _buildPreviewMode(questions, result?["quest"])
                        else
                          _buildAnswerMode(questions)
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }

  Widget _buildLoadingScreen() {
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

  Widget _buildAnswerMode(Map<String, dynamic> questions) {
    return Column(
      children: [
        _buildOptions(questions),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: ((selectedAnswer != null) || (selectedAnswers.isNotEmpty))
              ? () => _showConfirmationDialog(questions)
              : null,
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewMode(dynamic question, dynamic result) {
    if (result == null) {
      Navigator.of(context).pop();
    }

    final String type = question['type'];
    final options = question['options'] ?? [];
    debugPrint("📌 resultnya di buildpreview: $result");
    final answer = result?['answer'] ?? {};

    // final int? correctAnswerId = answer['correct_answer_id'];
    final int? correctAnswerIndex = answer['correct_answer_index'];
    final List<dynamic>? correctAnswersIndex = answer['correct_answers_index'];
    // final List<int>? correctAnswers = answer['correct_answers'];
    // final int? userAnswerId = answer['user_answer_id'];
    // final int? userAnswerIndex = answer['user_answer_index'];
    // final List<int>? userAnswers = answer['user_answers'];
    final String? textAnswer = answer['user_answer'];
    final String? explanation = answer['feedback'];
    final bool isCorrect = result['is_correct'];
    final int? rewardExp = result['reward_exp'];
    final int? rewardPoint = result['reward_point'];
    final int? expGained = answer['exp_gained'];
    final int? pointGained = answer['point_gained'];
    final String? correctAnswer = answer['correct_answer'];

    if (type == 'essay' || type == 'shortAnswer') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                textAnswer ?? " ",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (isCorrect) ...[
            const Text(
              "Jawaban Anda benar",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("+$rewardExp",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/exp_point.png',
                    width: 20, height: 20),
                const SizedBox(width: 10),
                Text("+$rewardPoint",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/coin.png', width: 20, height: 20),
              ],
            ),
          ] else
            const Text(
              "Jawaban Anda salah",
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              "Jawaban Yang Benar : ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Text('$correctAnswer')),
          if (explanation != null) _buildExplanation(explanation),
        ],
      );
    }

    if (type == 'true_false') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(options.length, (index) {
              return _buildTrueFalsePreview(
                  question, index, options[index], correctAnswerIndex);
            }),
          ),
          if (isCorrect) ...[
            const SizedBox(height: 10),
            const Text(
              "Jawaban Anda benar !",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("+$rewardExp",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/exp_point.png',
                    width: 20, height: 20),
                const SizedBox(width: 10),
                Text("+$rewardPoint",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/coin.png', width: 20, height: 20),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            const Text(
              "Jawaban Anda salah :(",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
          if (explanation != null) _buildExplanation(explanation),
        ],
      );
    } else if (type == 'multiple_answer') {
      return Column(
        children: [
          ...List.generate(options.length, (index) {
            return _buildCheckboxPreview(question, index,
                options[index]["text"], correctAnswersIndex ?? []);
          }),
          if (isCorrect) ...[
            const SizedBox(height: 10),
            const Text(
              "Jawaban Anda benar !",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("+$expGained",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/exp_point.png',
                    width: 20, height: 20),
                const SizedBox(width: 10),
                Text("+$pointGained",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/coin.png', width: 20, height: 20),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            const Text(
              "Jawaban Anda salah :(",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
          if (explanation != null) _buildExplanation(explanation),
        ],
      );
    } else {
      return Column(
        children: [
          ...List.generate(options.length, (index) {
            return _buildOptionPreview(
                question, index, options[index]["text"], correctAnswerIndex);
          }),
          if (isCorrect) ...[
            const Text(
              "Jawaban Anda benar",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("+$rewardExp",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/exp_point.png',
                    width: 20, height: 20),
                const SizedBox(width: 10),
                Text("+$rewardPoint",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
                const SizedBox(width: 5),
                Image.asset('assets/icons/coin.png', width: 20, height: 20),
              ],
            ),
          ] else
            const Text(
              "Jawaban Anda salah",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          if (explanation != null) _buildExplanation(explanation),
        ],
      );
    }
  }

  Widget _buildOptionPreview(
      dynamic question, int index, String text, int? correctAnswerIndex) {
    bool isSelected = selectedAnswer == index;
    bool isCorrect = correctAnswerIndex == index;
    Color bgColor;
    Color circleColor;
    Color borderColor;

    // Debugging logs
    // debugPrint("========== DEBUG: _buildOptionPreview ==========");
    // debugPrint("Index: $index");
    // debugPrint("Selected Answer: $selectedAnswer");
    // debugPrint("Correct Answer ID: $correctAnswerIndex");
    // debugPrint("isSelected: $isSelected, isCorrect: $isCorrect");

    if (isSelected) {
      bgColor = isCorrect ? const Color(0xFF44C4A1) : const Color(0xFFEB4747);
      circleColor =
          isCorrect ? const Color(0xFF00A58C) : const Color(0xFFDD051D);
      borderColor = Colors.transparent;
    } else if (isCorrect) {
      bgColor = const Color(0xFFD0FFD0);
      circleColor = const Color(0xFFD0FFD0);
      borderColor = const Color(0xFF00A58C);
    } else {
      bgColor = Colors.white;
      circleColor = Colors.grey;
      borderColor = Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
        ),
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
            backgroundColor: circleColor,
            child: Text(
              String.fromCharCode(65 + index),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            fit: FlexFit.loose,
            child: Html(
              data: text,
              style: {"p": Style(fontSize: FontSize(16))},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxPreview(dynamic question, int index, String text,
      List<dynamic> correctAnswersIndex) {
    bool isSelected = selectedAnswers.contains(index);
    bool isCorrect = correctAnswersIndex.contains(index);

    Color bgColor;
    Color circleColor;
    Color borderColor;

    if (isSelected) {
      bgColor = isCorrect ? const Color(0xFF44C4A1) : const Color(0xFFEB4747);
      circleColor =
          isCorrect ? const Color(0xFF00A58C) : const Color(0xFFDD051D);
      borderColor = Colors.transparent;
    } else if (isCorrect) {
      bgColor = const Color(0xFFD0FFD0);
      circleColor = const Color(0xFFD0FFD0);
      borderColor = const Color(0xFF00A58C);
    } else {
      bgColor = Colors.white;
      circleColor = Colors.grey;
      borderColor = Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: null, // Preview, jadi tidak bisa diubah
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: circleColor,
            child: Text(
              String.fromCharCode(65 + index), // A, B, C, D...
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Html(
              data: text,
              style: {"p": Style(fontSize: FontSize(16))},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrueFalsePreview(
      dynamic question, int index, String text, int? correctAnswerIndex) {
    bool isSelected = selectedAnswer == index;
    bool isCorrect = correctAnswerIndex == index;
    Color bgColor;
    Color textColor;

    if (isSelected) {
      bgColor = isCorrect ? Colors.green : Colors.red;
      textColor = Colors.white;
    } else {
      bgColor = isCorrect ? Colors.lightGreen : Colors.white;
      textColor = Colors.black;
    }

    return Container(
      width: 142,
      height: 142,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: bgColor, width: 2),
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
          style: TextStyle(fontSize: 18, color: textColor),
        ),
      ),
    );
  }

  Widget _buildExplanation(String explanation) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            // 🔥 Tambahkan shadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          // border: Border.all(color: Colors.grey),
        ),
        child: Html(
          data: """
          <h3 style="margin-bottom: 8px; text-align: center;">Penjelasan:</h3>
          <p>$explanation</p>
        """,
          style: {
            "h3": Style(
              fontSize: FontSize(18),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            "p": Style(
              fontSize: FontSize(16),
              textAlign: TextAlign.justify,
              color: Colors.white
            ),
          },
        ),
      ),
    );
  }

  Widget _buildOptions(dynamic question) {
    final String type = question['type'];
    final options = question['options'] ?? [];

    if (type == 'essay' || type == 'shortAnswer') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: _textController,
          maxLines: (type == 'essay') ? 5 : 1,
          decoration: InputDecoration(
            hintText: "Masukkan jawaban Anda...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            selectedAnswer = value;
            _saveUserAnswer(value, 0, question);
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
          maxLines: 1,
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
                if (selectedAnswer != null || selectedAnswers.isNotEmpty) {
                  _timer?.cancel();
                  _showLoadingDialog();

                  result =
                      await QuestService().submitQuest(questId, jawabanUser);

                  // Logger().i(result);

                  setState(() {
                    isPreview = true;
                  });

                  Navigator.pop(context);
                  Navigator.pop(context);

                  if (result?["quest"] != null) {
                    bool isCorrect = result?["quest"]["is_correct"] ?? false;
                    String correctPath = 'audio/success-1-6297.mp3';
                    String wrongPath = 'audio/070-challenge-lose.mp3';
                    int expGain = result?["quest"]['answer']['exp_gained'];
                    int pointGain = result?["quest"]['answer']['point_gained'];
                    List<dynamic> badges = result?['badge'] ?? [];
                    _showResultDialog(
                      context,
                      isCorrect,
                      correctPath,
                      wrongPath,
                      expGain,
                      pointGain,
                      badges,
                    );
                  }
                }
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
        "index_jawaban": 0,
        "answer_text": answer,
      };
      // jawabanUser[indexSoal] = detailJawaban;
      jawabanUser = detailJawaban;
    } else if (question["type"] == "multiple_answer") {
      List<Map<String, dynamic>> answers = [];
      if (selectedAnswers.isNotEmpty) {
        selectedAnswers.forEach((ans) {
          answers.add({
            "answer_id": question["options"][ans]["id"],
            // "answer_text": question["options"][ans]["text"],
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

    // logger.i(jawabanUser);
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Submitting...", style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  void _showResultDialog(
      BuildContext context,
      bool isCorrect,
      String correctPath,
      String wrongPath,
      int expGain,
      int poinGain,
      List<dynamic> badges) {
    if (isCorrect) {
      _playSoundEffect(correctPath);
    } else {
      _playSoundEffect(wrongPath);
    }
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        isCorrect
                            ? 'assets/animation/Animation - 1742010178937.json'
                            : 'assets/animation/Animation - 1742010214972.json',
                        width: 275,
                        height: 275,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isCorrect
                            ? "Yey, jawaban kamu benar!"
                            : "Oops, jawaban kamu salah!",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isCorrect) ...[
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRewardBox(
                                "Exp Gain",
                                expGain,
                                const Color(0xFF9E6FD7),
                                'assets/icons/exp_point.png'),
                            const SizedBox(width: 16),
                            _buildRewardBox(
                                "Poin Gain",
                                poinGain,
                                const Color(0xFFECB751),
                                'assets/icons/coin.png'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _stopSoundEffect();
                        Navigator.pop(context);

                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (badges != null || badges.isNotEmpty) {
                            _showBadges(badges, 0);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Lanjutkan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRewardBox(
      String title, int value, Color colorBox, String iconPath) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: colorBox,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorBox, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border.all(color: colorBox, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  width: 24, // Atur ukuran ikon
                  height: 24,
                ),
                const SizedBox(width: 8), // Jarak antara ikon dan teks
                Text(
                  "$value",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
