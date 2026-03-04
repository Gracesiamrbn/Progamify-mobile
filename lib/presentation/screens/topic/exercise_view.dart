import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logger/logger.dart';
import 'package:progamify/api/exercise_service.dart';

class ExerciseViewScreen extends StatefulWidget {
  final int exerciseId;
  final Map<String, dynamic> userAnswers;

  /// optional map of the locally submitted answers (keys are question ids).
  final Map<int, dynamic>? originalAnswers;

  const ExerciseViewScreen({
    super.key,
    required this.exerciseId,
    required this.userAnswers,
    this.originalAnswers,
  });

  @override
  State<ExerciseViewScreen> createState() => ExerciseViewScreenState();
}

class ExerciseViewScreenState extends State<ExerciseViewScreen> {
  int currentQuestionIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late Future<Map<String, dynamic>> _questionsFuture;
  Map<int, dynamic> jawabanUser = {};

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _questionsFuture = ExerciseService().getExercise(widget.exerciseId);

    // server might return the answers either as a map (keyed by question id)
    // or as a list of objects.  We want to build a lookup map so that
    // reviewing the exercise can easily find the user's submission for a
    // given question.  The backend also sometimes stores numeric ids as
    // strings, so normalise those as well.
    // if the caller provided the original answers bundle use it first
    if (widget.originalAnswers != null) {
      jawabanUser = widget.originalAnswers!;
    } else {
      final rawAnswers = widget.userAnswers["answers"];
      if (rawAnswers is Map) {
        // convert to Map<String,dynamic> for the helper method
        jawabanUser = ExerciseService().convertJawabanUserStringToInt(
            Map<String, dynamic>.from(rawAnswers));
      } else if (rawAnswers is List) {
        jawabanUser = {};
        for (var ans in rawAnswers) {
          if (ans is Map && ans["question_id"] != null) {
            final qid = ans["question_id"];
            final key = qid is String ? int.tryParse(qid) ?? qid : qid;
            jawabanUser[key] = ans;
          }
        }
      } else {
        jawabanUser = {};
      }
    }

    logger.i('jawaban user= $jawabanUser');
  }

  void _nextQuestion(List<Map<String, dynamic>> questions) {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() => currentQuestionIndex++);
      _scrollToCurrentQuestion();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() => currentQuestionIndex--);
      _scrollToCurrentQuestion();
    }
  }

  void _goToQuestion(int index) {
    setState(() => currentQuestionIndex = index);
    _scrollToCurrentQuestion();
  }

  void _scrollToCurrentQuestion() {
    _scrollController.animateTo(
      currentQuestionIndex * 50.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Cari jawaban user berdasarkan question_id.
  // The map may be keyed by the id already, and the value stored may use a
  // numeric or string representation, so check both.
  Map<String, dynamic>? _getUserAnswer(int questionId) {
    // fast path: map key match
    if (jawabanUser.containsKey(questionId)) {
      final entry = jawabanUser[questionId];
      if (entry is Map<String, dynamic>) return entry;
    }

    for (var entry in jawabanUser.values) {
      if (entry is Map) {
        final qid = entry["question_id"];
        if (qid != null && qid.toString() == questionId.toString()) {
          // when the answer came from the local map we may want to rename the
          // "answers" list to "user_matches" so downstream review logic
          // works more predictably.  Doing it here avoids duplicating checks
          // elsewhere.
          if (entry.containsKey('answers') &&
              !entry.containsKey('user_matches')) {
            entry['user_matches'] = entry['answers'];
          }
          return entry as Map<String, dynamic>;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Tidak ada soal tersedia'));
        }

        final questionsData = snapshot.data!["questions"] as List;
        final List<Map<String, dynamic>> questions = [];

        for (int i = 0; i < questionsData.length; i++) {
          var q = questionsData[i] as Map<String, dynamic>;
          var type = q["type"] as String?;

          Map<String, dynamic> parsed = {
            'id': q["ID"],
            'question': q["content"],
            'explanation': q["feedback"] ?? "Tidak ada penjelasan.",
            'exp': q["exp"] ?? 0,
            'pts': q["point"] ?? 0,
            'type': type,
            'q_index': i,
          };

          if (type == "multiple_choice" || type == "multiple_answer") {
            final opts = <Map<String, dynamic>>[];
            for (var ans in (q["answers"] as List? ?? [])) {
              opts.add({
                "id": ans["ID"],
                "text": ans["content"],
                "is_correct": ans["is_correct"]
              });
            }
            parsed['options'] = opts;
          } else if (type == "true_false") {
            parsed['options'] = ["True", "False"];
          } else if (type == "essay" ||
              type == 'shortAnswer' ||
              type == 'short' ||
              type == 'short_answer') {
            // some exercise definitions may include a single correct answer
            // in the answers array even for essay/short answer types.
            if (q["answers"] != null) {
              final opts = <Map<String, dynamic>>[];
              for (var ans in (q["answers"] as List? ?? [])) {
                opts.add({
                  "id": ans["ID"],
                  "text": ans["content"],
                  "is_correct": ans["is_correct"],
                });
              }
              parsed['options'] = opts;
            }
          } else if (type == "matching") {
            List<String> keywords = [];
            Set<String> uniqueExp = {};

            dynamic data = q["content"];
            if (data is String) {
              try {
                data = jsonDecode(data);
              } catch (_) {}
            }
            if (data is List) {
              for (var item in data) {
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
            if (keywords.isEmpty && q["answers"] != null) {
              for (var ans in (q["answers"] as List? ?? [])) {
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

        final question = questions[currentQuestionIndex];
        final userAnswer = _getUserAnswer(question['id']);
        final expGained = userAnswer?["exp_gained"] ?? 0;
        final pointGained = userAnswer?["point_gained"] ?? 0;

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
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('+$expGained exp',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('+$pointGained pts',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Row(children: [
                      Text('Exit',
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                      SizedBox(width: 4),
                      Icon(Icons.exit_to_app, color: Colors.white),
                    ]),
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
                  // Navigator soal
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: questions.length,
                      itemBuilder: (context, i) {
                        bool active = i == currentQuestionIndex;
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
                            child: Text('${i + 1}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: active ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Soal (tampilan berbeda untuk matching)
                  if (question['type'] != 'matching') ...[
                    Html(
                        data: question["question"] ?? "Soal tidak tersedia",
                        style: {
                          "p": Style(
                              fontSize: FontSize(18),
                              textAlign: TextAlign.justify)
                        }),
                    const SizedBox(height: 20),
                  ] else ...[
                    // when it's a matching question we don't want to dump the
                    // JSON blob; just show an instruction instead
                    const Text(
                      'Pasangan keyword dan penjelasan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Jawaban User
                  _buildUserAnswer(question, userAnswer),

                  const SizedBox(height: 30),

                  // Penjelasan + Kunci Jawaban
                  _buildExplanationWithAnswer(question, userAnswer),

                  const SizedBox(height: 30),

                  // Navigasi
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
                                : Colors.grey),
                      ),
                      ElevatedButton.icon(
                        onPressed: currentQuestionIndex < questions.length - 1
                            ? () => _nextQuestion(questions)
                            : null,
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                        label: const Text('Next',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                currentQuestionIndex < questions.length - 1
                                    ? const Color(0xFF6FBAFF)
                                    : Colors.grey),
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

  // Jawaban yang dipilih user
  Widget _buildUserAnswer(
      Map<String, dynamic> question, Map<String, dynamic>? userAnswer) {
    final type = question['type'] as String?;

    if (type == 'matching') {
      return _buildMatchingReview(question, userAnswer);
    }

    if (type == 'essay' ||
        type == 'shortAnswer' ||
        type == 'short' ||
        type == 'short_answer') {
      // support a few different field names that may be returned by the
      // backend – some endpoints use "answer_text", others "user_answer",
      // "user_answer_text" etc.  Fall back to "Tidak dijawab" if nothing is
      // available.
      final text = (userAnswer?["answer_text"] ??
              userAnswer?["user_answer_text"] ??
              userAnswer?["user_answer"] ??
              "Tidak dijawab")
          .toString();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Jawaban Anda:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300)),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      );
    }

    final options = question['options'] as List<dynamic>? ?? [];
    if (options.isEmpty) return const SizedBox.shrink();

    if (type == 'true_false') {
      final idx = userAnswer?["user_answer_index"] as int? ?? -1;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            options.length,
            (i) => _buildTrueFalseCard(question, i, options[i],
                selectedIndex: idx)),
      );
    }

    if (type == 'multiple_answer') {
      final selectedRaw = userAnswer?["user_answer_index"];
      final selected =
          (selectedRaw is List) ? selectedRaw.cast<int>() : <int>[];

      return Column(
        children: List.generate(
          options.length,
          (i) => _buildCheckboxOption(
            question,
            i,
            options[i]["text"],
            isSelected: selected.contains(i),
          ),
        ),
      );
    }

    // multiple_choice
    final idx = userAnswer?["user_answer_index"] as int? ?? -1;
    return Column(
      children: List.generate(
          options.length,
          (i) => _buildOptionCard(question, i, options[i]["text"],
              selectedIndex: idx)),
    );
  }

  // Penjelasan + Kunci Jawaban di Bawah
  Widget _buildExplanationWithAnswer(
      Map<String, dynamic> question, Map<String, dynamic>? userAnswer) {
    final type = question['type'] as String?;
    // special case for matching type: show correct keyword ↔ explanation pairs
    if (type == 'matching') {
      final keywords = question['keywords'] as List<String>? ?? [];
      final explanations = question['explanations'] as List<String>? ?? [];
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.blue[700], borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kunci Jawaban:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            ...List.generate(explanations.length, (i) {
              final kw = i < keywords.length ? keywords[i] : '—';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Html(data: '${i + 1}. ${explanations[i]}', style: {
                        "p": Style(fontSize: FontSize(16), color: Colors.white)
                      }),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.yellow[600],
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        kw,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    // default explanation for non-matching
    // include user answer text for essay/short types
    String? userText;
    if (type == 'essay' ||
        type == 'shortAnswer' ||
        type == 'short' ||
        type == 'short_answer') {
      userText = (userAnswer?["answer_text"] ??
              userAnswer?["user_answer_text"] ??
              userAnswer?["user_answer"] ??
              "")
          .toString();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.blue[700], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (userText != null && userText.isNotEmpty) ...[
            const Text("Jawaban Anda:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              userText,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
          ],
          const Text("Kunci Jawaban:",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow)),
          const SizedBox(height: 8),
          _buildCorrectAnswerDisplay(question, userAnswer),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswerDisplay(
      Map<String, dynamic> question, Map<String, dynamic>? userAnswer) {
    final type = question['type'] as String?;

    // Penanganan khusus untuk short_answer & essay
    if (type == 'short_answer' ||
        type == 'short' ||
        type == 'shortAnswer' ||
        type == 'essay') {
      // try to pick up a correct answer from the question options list first
      String? correctText;
      final opts = question['options'] as List<dynamic>?;
      if (opts != null) {
        for (var o in opts) {
          if (o is Map && (o['is_correct'] == true || o['is_correct'] == 1)) {
            correctText = o['text']?.toString();
            break;
          }
        }
      }
      correctText ??= userAnswer?["correct_answer_text"] as String?;
      correctText ??= "Dinilai manual oleh pengajar";
      return Text(
        correctText,
        style:
            const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
      );
    }

    final options = question['options'] as List<dynamic>? ?? [];
    if (options.isEmpty) {
      return const Text("Tidak ada opsi untuk ditampilkan.",
          style: TextStyle(color: Colors.white70));
    }

    List<int> correctIndices = [];

    if (type == "multiple_choice") {
      for (int i = 0; i < options.length; i++) {
        final opt = options[i] as Map<String, dynamic>?;
        if (opt != null &&
            (opt["id"] == userAnswer?["correct_answer_id"] ||
                opt["is_correct"] == true)) {
          correctIndices.add(i);
        }
      }
    } else if (type == "multiple_answer") {
      final correctRaw = userAnswer?["correct_answer_index"];
      if (correctRaw is List) {
        correctIndices = correctRaw.cast<int>();
      } // else tetap [] (sudah dideklarasikan di atas)

      if (correctIndices.isEmpty) {
        return const Text("Tidak ada kunci jawaban tersedia.",
            style: TextStyle(color: Colors.white70));
      }
    } else if (type == "true_false") {
      final correctIdx = userAnswer?["correct_answer_index"] as int? ?? 0;
      correctIndices = [correctIdx];
    }

    if (correctIndices.isEmpty) {
      return const Text("Tidak ada kunci jawaban.",
          style: TextStyle(color: Colors.white70));
    }

    return Wrap(
      spacing: 8,
      children: correctIndices.map((i) {
        final letter = String.fromCharCode(65 + i);
        String text;
        if (options[i] is Map) {
          text =
              (options[i] as Map)["text"]?.toString() ?? options[i].toString();
        } else {
          // fallback for true/false or other simple string options
          text = options[i].toString();
        }
        return Chip(
          backgroundColor: Colors.green,
          label: Text("$letter. $text",
              style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  // Review Matching (hanya tampilkan jawaban user + benar/salah)
  Widget _buildMatchingReview(
      Map<String, dynamic> question, Map<String, dynamic>? userAnswer) {
    final keywords = question['keywords'] as List<String>? ?? [];
    final explanations = question['explanations'] as List<String>? ?? [];
    // some responses (or our local copy) use the key "answers" while
    // others use "user_matches".  Normalise both to a consistent list so the
    // remainder of the code can treat them the same.
    List<Map<String, dynamic>> userMatches = [];
    final rawMatches = userAnswer?["user_matches"] ?? userAnswer?["answers"];
    if (rawMatches is List) {
      userMatches = rawMatches
          .whereType<Map>()
          .map((m) => Map<String, dynamic>.from(m))
          .toList();
    }

    return Column(
      children: List.generate(explanations.length, (i) {
        final correctKeyword =
            keywords.length > i ? keywords[i] : "Tidak tersedia";
        // take the answer at the same index rather than searching text
        final userMatch =
            i < userMatches.length ? userMatches[i] : <String, dynamic>{};
        final userKeyword =
            (userMatch["keyword"] as String?)?.trim() ?? "Tidak dijawab";
        final isCorrect = userKeyword == correctKeyword;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isCorrect
                ? Colors.green.withOpacity(0.15)
                : Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isCorrect ? Colors.green : Colors.red, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Html(
                      data: "${i + 1}. ${explanations[i]}",
                      style: {"p": Style(fontSize: FontSize(14))})),
              const SizedBox(width: 10),
              Icon(isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red),
              const SizedBox(width: 8),
              Text(userKeyword,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green : Colors.red)),
            ],
          ),
        );
      }),
    );
  }

  // Widget pendukung lainnya tetap sama seperti sebelumnya
  Widget _buildOptionCard(dynamic question, int index, String text,
      {int? selectedIndex}) {
    final isSelected = selectedIndex == index;
    final isCorrect =
        _getUserAnswer(question['id'])?["correct_answer_index"] == index;
    final bgColor =
        isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
          ]),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: isSelected
                  ? (isCorrect ? Colors.green : Colors.red)
                  : Colors.grey.shade400,
              child: Text(String.fromCharCode(65 + index),
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(
              child: Html(
                  data: text, style: {"p": Style(fontSize: FontSize(16))})),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(dynamic question, int index, String text,
      {bool isSelected = false}) {
    final correctIndices =
        (_getUserAnswer(question['id'])?["correct_answer_index"] as List?)
                ?.cast<int>() ??
            [];
    final isCorrect = correctIndices.contains(index);
    final bgColor =
        isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
          ]),
      child: Row(
        children: [
          Checkbox(value: isSelected, onChanged: null),
          const SizedBox(width: 10),
          Expanded(
              child: Html(
                  data: text, style: {"p": Style(fontSize: FontSize(16))})),
        ],
      ),
    );
  }

  Widget _buildTrueFalseCard(dynamic question, int index, String text,
      {int? selectedIndex}) {
    final isSelected = selectedIndex == index;
    final isCorrect =
        _getUserAnswer(question['id'])?["correct_answer_index"] == index;
    final bgColor =
        isSelected ? (isCorrect ? Colors.green : Colors.red) : Colors.white;

    return Container(
      width: 142,
      height: 142,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isSelected
                  ? (isCorrect ? Colors.green : Colors.red)
                  : Colors.white,
              width: 2)),
      child: Center(
          child: Text(text,
              style: TextStyle(
                  fontSize: 18,
                  color: isSelected ? Colors.white : Colors.black))),
    );
  }
}
