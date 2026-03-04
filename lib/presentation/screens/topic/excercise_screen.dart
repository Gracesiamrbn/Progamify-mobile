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

  const ExerciseScreen({
    super.key,
    required this.exerciseId,
    required this.topicId,
    required this.topicTitle,
    required this.totalLesson,
    required this.totalExercise,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool isLoading = false;
  int currentQuestionIndex = 0;
  dynamic selectedAnswer;
  List<int> selectedAnswers = [];
  Map<int, dynamic> jawabanUser = {};

  final ScrollController _scrollController = ScrollController();
  late Future<Map<String, dynamic>> _questionsFuture;

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _questionsFuture = ExerciseService().getExercise(widget.exerciseId);
  }

  void _loadPreviousAnswer() {
    final prev = jawabanUser[currentQuestionIndex];
    if (prev != null) {
      selectedAnswer = prev["index_jawaban"];
      if (prev["type"] == "multiple_answer") {
        selectedAnswers = List<int>.from(prev["index_jawaban"] ?? []);
      } else {
        selectedAnswers.clear();
      }
    } else {
      selectedAnswer = null;
      selectedAnswers.clear();
    }
  }

  void _nextQuestion(List<Map<String, dynamic>> questions) {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _loadPreviousAnswer();
      });
      _scrollToCurrentQuestion();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        _loadPreviousAnswer();
      });
      _scrollToCurrentQuestion();
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
      _loadPreviousAnswer();
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

  Future<void> _submitExercise() async {
    setState(() => isLoading = true);

    // debug log of answers being sent
    logger.i(
        'Submitting answers for exercise ${widget.exerciseId}: $jawabanUser');

    try {
      final result = await ExerciseService()
          .submitExercise(widget.exerciseId, jawabanUser);
      logger.i("Submit result: $result");

      if (result["achievement"] != null &&
          (result["achievement"] as List).isNotEmpty) {
        await _showPopUpAchievement(result["achievement"]);
      }

      if (mounted) {
        Navigator.pop(context); // close dialog if still open
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseResultScreen(
              userAnswers: [result],
              submittedAnswers: jawabanUser,
              topicId: widget.topicId,
              topicTitle: widget.topicTitle,
              totalExercise: widget.totalExercise,
              totalLesson: widget.totalLesson,
            ),
          ),
        );
      }
    } catch (e) {
      logger.e("Submit error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal submit: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          return const Center(child: Text('Tidak ada soal tersedia'));
        }

        final data = snapshot.data!;
        final questionsData = data["questions"] as List<dynamic>? ?? [];

        final List<Map<String, dynamic>> questions = [];

        for (final raw in questionsData) {
          final q = raw as Map<String, dynamic>;
          final type = q["type"] as String?;

          Map<String, dynamic> parsed = {
            'id': q["ID"],
            'question': q["content"],
            'explanation': q["feedback"],
            'exp': q["exp"] ?? 0,
            'pts': q["point"] ?? 0,
            'type': type,
          };

          if (type == "multiple_choice" || type == "multiple_answer") {
            final opts = <Map<String, dynamic>>[];
            for (final ans in (q["answers"] as List? ?? [])) {
              opts.add({
                "id": ans["ID"],
                "text": ans["content"],
              });
            }
            parsed['options'] = opts;
          } else if (type == "true_false") {
            parsed['options'] = ["True", "False"];
          } else if (type == "matching") {
            List<String> keywords = [];
            final Set<String> uniqueExp = {};

            dynamic contentData = q["content"];
            if (contentData is String) {
              try {
                contentData = jsonDecode(contentData);
              } catch (_) {}
            }

            if (contentData is List) {
              for (final item in contentData) {
                if (item is Map) {
                  if (item["keyword"] != null) {
                    keywords.add(item["keyword"].toString());
                  }
                  if (item["explanation"] != null) {
                    uniqueExp.add(item["explanation"].toString());
                  }
                }
              }
            }

            if (keywords.isEmpty) {
              for (final ans in (q["answers"] as List? ?? [])) {
                if (ans["keyword"] != null) {
                  keywords.add(ans["keyword"].toString());
                }
                if (ans["explanation"] != null) {
                  uniqueExp.add(ans["explanation"].toString());
                }
              }
            }

            parsed['keywords'] = keywords;
            parsed['explanations'] = uniqueExp.toList();
          }

          questions.add(parsed);
        }

        final currentQuestion = questions[currentQuestionIndex];
        final exp = currentQuestion['exp'] as int;
        final pts = currentQuestion['pts'] as int;

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
                      fontSize: 13,
                    ),
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
                      fontSize: 13,
                    ),
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
                        Text('Exit',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
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
                      itemBuilder: (context, i) {
                        final active = i == currentQuestionIndex;
                        return GestureDetector(
                          onTap: () => _goToQuestion(i),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: active
                                  ? const Color(0xFF6FBAFF)
                                  : Colors.grey[300],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                color: active ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (currentQuestion['type'] != 'matching')
                    Html(
                      data: currentQuestion['question'] ?? '',
                      style: {
                        "p": Style(
                            fontSize: FontSize(18),
                            textAlign: TextAlign.justify),
                      },
                    ),
                  if (currentQuestion['type'] != 'matching')
                    const SizedBox(height: 20),
                  _buildQuestionContent(currentQuestion, questions),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            currentQuestionIndex > 0 ? _previousQuestion : null,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: const Text('Previous',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentQuestionIndex > 0
                              ? const Color(0xFF6FBAFF)
                              : Colors.grey,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: currentQuestionIndex < questions.length - 1
                            ? () => _nextQuestion(questions)
                            : _showSubmitDialog,
                        icon: Icon(
                          currentQuestionIndex < questions.length - 1
                              ? Icons.arrow_forward
                              : Icons.check,
                          color: Colors.white,
                        ),
                        label: Text(
                          currentQuestionIndex < questions.length - 1
                              ? 'Next'
                              : 'Submit',
                          style: const TextStyle(color: Colors.white),
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

  Widget _buildQuestionContent(
      Map<String, dynamic> question, List<Map<String, dynamic>> questions) {
    final type = question['type'] as String?;
    logger.i("Rendering soal tipe: $type | ID: ${question['id']}");

    // 1. Matching
    if (type == 'matching') {
      return _buildMatching(question);
    }

    // 2. Essay & Short Answer (tidak pakai options)
    if (type == 'essay' || type == 'short_answer') {
      // Ambil jawaban sebelumnya jika ada
      final initialValue =
          (jawabanUser[currentQuestionIndex]?['answer_text'] as String?) ?? '';

      final controller = TextEditingController(text: initialValue);

      // Auto-save saat mengetik
      controller.addListener(() {
        _saveUserAnswer(
            currentQuestionIndex, controller.text.trim(), 0, question);
      });

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type == 'essay' ? 'Jawaban Essay' : 'Jawaban Singkat',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: type == 'essay' ? 6 : 2,
              minLines: type == 'essay' ? 4 : 1,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: type == 'essay'
                    ? 'Tulis jawaban essay'
                    : 'Tulis jawaban singkat',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF6FBAFF), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              type == 'essay'
                  ? 'Petunjuk: Jawaban harus terstruktur, mendetail, dan menggunakan contoh jika perlu'
                  : 'Petunjuk: Jawaban harus singkat, tepat, dan langsung ke inti',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // 3. Untuk tipe lain: ambil options
    final options = question['options'] as List<dynamic>? ?? [];

    // 4. Jika options kosong → baru tampilkan pesan error
    if (options.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "Tidak ada opsi tersedia untuk tipe soal ini",
          style: TextStyle(
              color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    // 5. True/False, Multiple Answer, Multiple Choice (tetap seperti sebelumnya)
    if (type == 'true_false') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          options.length,
          (i) => _buildTrueFalseCard(question, i, options[i] as String),
        ),
      );
    }

    if (type == 'multiple_answer') {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, i) => _buildCheckboxOption(
            question,
            i,
            (options[i] as Map)["text"] as String,
          ),
        ),
      );
    }

    // Default: multiple choice
    return Column(
      children: List.generate(
        options.length,
        (i) => _buildOptionCard(
            question, i, (options[i] as Map)["text"] as String),
      ),
    );
  }

  Widget _buildMatching(Map<String, dynamic> question) {
    final keywords = List<String>.from(question['keywords'] ?? []);
    final explanations = List<String>.from(question['explanations'] ?? []);

    if (jawabanUser[currentQuestionIndex] == null) {
      jawabanUser[currentQuestionIndex] = {
        'question_id': question['id'],
        'type': 'matching',
        'answers':
            List.generate(explanations.length, (_) => <String, dynamic>{}),
      };
    }

    final answers = jawabanUser[currentQuestionIndex]['answers']
        as List<Map<String, dynamic>>;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Expanded(
                  child: Text('Explanation',
                      style: TextStyle(fontWeight: FontWeight.bold))),
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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: explanations.length,
          itemBuilder: (context, i) {
            return _buildMatchingCard(
              question: question,
              index: i,
              explanation: explanations[i],
              keywords: keywords,
              answers: answers,
            );
          },
        ),
      ],
    );
  }

  Widget _buildMatchingCard({
    required Map<String, dynamic> question,
    required int index,
    required String explanation,
    required List<String> keywords,
    required List<Map<String, dynamic>> answers,
  }) {
    String? selectedKeyword;
    if (index < answers.length) {
      final saved = answers[index]['keyword'] as String?;
      if (saved != null && saved.trim().isNotEmpty) {
        selectedKeyword = saved.trim();
      }
    }

    final uniqueKeywords = keywords.toSet().toList();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Expanded(
            child: Html(
              data: '${index + 1}. $explanation',
              style: {
                "p":
                    Style(fontSize: FontSize(13), textAlign: TextAlign.justify),
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: DropdownButtonFormField<String?>(
              initialValue: selectedKeyword,
              hint: const Text('Pilih keyword'),
              isExpanded: true,
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Pilih keyword',
                      style: TextStyle(color: Colors.grey)),
                ),
                ...uniqueKeywords.map((kw) => DropdownMenuItem<String?>(
                      value: kw.trim(),
                      child:
                          Text(kw.trim(), style: const TextStyle(fontSize: 13)),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  answers[index] = {
                    'keyword': value?.trim(),
                    'explanation': explanation,
                  };
                  _saveUserAnswer(currentQuestionIndex, '', 0, question);
                });
              },
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(dynamic question, int index, String text) {
    final isSelected = selectedAnswer == index;
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
                spreadRadius: 1),
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
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Html(
                data: text,
                style: {
                  "p": Style(
                      textAlign: TextAlign.justify, fontSize: FontSize(16))
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(dynamic question, int index, String text) {
    final isSelected = selectedAnswers.contains(index);
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
                spreadRadius: 1),
          ],
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (v) {
                setState(() {
                  if (v == true) selectedAnswers.add(index);
                  if (v == false) selectedAnswers.remove(index);
                });
              },
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Html(
                    data: text, style: {"p": Style(fontSize: FontSize(16))})),
          ],
        ),
      ),
    );
  }

  Widget _buildTrueFalseCard(dynamic question, int index, String text) {
    final isSelected = selectedAnswer == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = index;
          _saveUserAnswer(currentQuestionIndex, text, index, question);
        });
      },
      child: Container(
        width: 142,
        height: 142,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18, color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  void _saveUserAnswer(int qIndex, String answerText, int answerIndex,
      Map<String, dynamic> question) {
    final type = question['type'] as String?;

    Map<String, dynamic>? entry;

    if (type == "multiple_choice") {
      entry = {
        "question_id": question['id'],
        "answer_id": question['options'][answerIndex]['id'],
        "answer_text": question['options'][answerIndex]['text'],
        "index_jawaban": answerIndex,
        "type": type,
      };
    } else if (type == "true_false") {
      entry = {
        "question_id": question['id'],
        "answer_text": question['options'][answerIndex],
        "index_jawaban": answerIndex,
        "type": type,
      };
    } else if (type == "essay" || type == "short_answer") {
      entry = {
        "question_id": question['id'],
        "answer_text": answerText.trim(),
        "type": type,
      };
    } else if (type == "multiple_answer") {
      final List<Map<String, dynamic>> selected = [];
      final List<int> indices = [];

      for (final idx in selectedAnswers) {
        selected.add({
          "answer_id": question['options'][idx]['id'],
          "answer_text": question['options'][idx]['text'],
        });
        indices.add(idx);
      }

      entry = {
        "question_id": question['id'],
        "answers": selected,
        "index_jawaban": indices,
        "type": type,
      };
    } else if (type == "matching") {
      final rawAnswers =
          jawabanUser[qIndex]?['answers'] as List<dynamic>? ?? [];
      final List<Map<String, dynamic>> submitted = [];

      for (final p in rawAnswers) {
        final kw = (p['keyword'] as String?)?.trim() ?? '';
        final exp = (p['explanation'] as String?)?.trim() ?? '';

        submitted.add({
          "explanation": exp,
          "keyword": kw,
        });
      }

      entry = {
        "question_id": question['id'],
        "answers": submitted,
        "type": type,
      };
    }

    if (entry != null) {
      jawabanUser[qIndex] = entry;
      logger.i('Saved answer for question index $qIndex: $entry');
    }
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Center(
            child: Text('Submit',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Image.asset('assets/icons/exit_icon.png', height: 80),
            const SizedBox(height: 20),
            const Text('Are you sure to submit the answer?',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: isLoading
                ? null
                : () async {
                    Navigator.of(ctx).pop();
                    await _submitExercise();
                  },
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2),
                  )
                : const Text('Yes, Submit',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Center(
            child: Text('Want to Quit ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Image.asset('assets/icons/exit_icon.png', height: 80),
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Yes, Quit',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _showPopUpAchievement(List<dynamic> achievements) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Achievement Unlocked!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: achievements.map((ach) {
            return ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: Text(ach["title"] ?? "Achievement"),
              subtitle: Text(ach["description"] ?? ""),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
