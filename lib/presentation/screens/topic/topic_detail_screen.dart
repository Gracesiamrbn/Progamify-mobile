import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progamify/api/topic_service.dart';
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';
import 'package:progamify/presentation/screens/topic/exercise_result_page.dart';
import 'package:progamify/presentation/screens/topic/topic_course_screen.dart';
import 'package:progamify/presentation/screens/topic/excercise_screen.dart';
import 'package:logger/logger.dart';

class TopicDetailScreen extends StatefulWidget {
  final int topicId;
  final String topicTitle;
  final int totalLesson;
  final int totalExercise;

  const TopicDetailScreen(
      {super.key,
      required this.topicId,
      required this.topicTitle,
      required this.totalLesson,
      required this.totalExercise});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  final Set<int> clickedSteps = {};
  late Future<Map<String, dynamic>> futureTopic;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    futureTopic = TopicService().getTopic(widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.blue[200],
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      "${widget.topicTitle} ",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.18,
                      left: MediaQuery.of(context).size.width * 0.07,
                      right: MediaQuery.of(context).size.width * 0.07,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.book,
                                    color: Colors.red, size: 18),
                                const SizedBox(width: 3),
                                Text('${widget.totalLesson} Lessons',
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.assignment,
                                    color: Colors.blue, size: 18),
                                const SizedBox(width: 3),
                                Text('${widget.totalExercise} Exercises',
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                  child: FutureBuilder(
                      future: TopicService().getTopic(widget.topicId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No data available'));
                        }

                        final data = snapshot.data!;
                        final topic = data['topic'];
                        final List<dynamic> lessonTaken =
                            data['lessons_taken_in_this_topic'] ?? [];
                        final List<dynamic> exerciseTaken =
                            data['exercises_taken_in_this_topic'] ?? [];

                        final List<Map<String, dynamic>> lessons = [];
                        bool isLocked = false;

                        for (int i = 0; i < topic['lessons'].length; i++) {
                          var lesson = topic['lessons'][i];

                          bool isCompleted = lessonTaken
                              .any((les) => les['lesson_id'] == lesson['ID']);

                          Map<String, dynamic> newLesson = {
                            'id': int.parse("${lesson['ID']}"),
                            'title': lesson['name'],
                            'exp': int.parse("${lesson['exp']}"),
                            'icon': 'assets/icons/introduction_icon.png',
                            'isCompleted': isCompleted,
                            'isLocked': isLocked
                          };

                          if (!isCompleted && !isLocked) {
                            isLocked = true;
                          }

                          lessons.add(newLesson);

                          if (lesson['exercises'] != null) {
                            for (int j = 0;
                                j < lesson['exercises'].length;
                                j++) {
                              var exercise = lesson['exercises'][j];

                              bool isExerciseCompleted = exerciseTaken.any(
                                  (ex) => ex['exercise_id'] == exercise['ID']);

                              var totalQuestions = exercise['questions'] != null
                                  ? exercise['questions'].length
                                  : 0;
                              int totalPoint = 0;
                              int totalExp = 0;

                              if (totalQuestions > 0) {
                                exercise['questions'].forEach((item) {
                                  totalPoint += int.parse("${item['point']}");
                                  totalExp += int.parse("${item['exp']}");
                                });
                              }

                              Map<String, dynamic> newExercise = {
                                'id': int.parse("${exercise['ID']}"),
                                'title': exercise['title'],
                                'exp': totalExp,
                                'pts': totalPoint,
                                'questions': totalQuestions,
                                'icon': 'assets/icons/tasklist1_icon.png',
                                'isCompleted': isExerciseCompleted,
                                'isLocked': isLocked,
                              };

                              if (!newExercise["isCompleted"] && !isLocked) {
                                isLocked = true;
                              }

                              lessons.add(newExercise);
                            }
                          }
                        }

                        return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            itemCount: lessons.length,
                            itemBuilder: (context, index) {
                              // int nextIndex = index + 1;
                              // bool nextOneDone = true;
                              // if (nextIndex < lessons.length) {
                              //   nextOneDone =
                              //       lessons[nextIndex]['isCompleted'] ?? false;
                              // }
                              return _buildStepCard(context, lessons[index],
                                  index, lessons, exerciseTaken);
                            });
                      }))
            ],
          ),
          Positioned(
            top: 40,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              // onPressed: () => Navigator.pop(context),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainScreen(currentIndex: 0)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(
      BuildContext context,
      Map<String, dynamic> topic,
      int index,
      List<Map<String, dynamic>> topics,
      List<dynamic> exerciseTaken) {
    bool isClicked = topic['isCompleted'] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          clickedSteps.add(index);
        });
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: index != 0,
                      child: VerticalDivider(
                        color: isClicked ? Colors.blue : Colors.grey[350],
                        thickness: 5,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isClicked ? Colors.blue : Colors.grey[350],
                    ),
                    child: Center(
                      child: isClicked
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 18)
                          : Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Visibility(
                      visible: index != topics.length - 1,
                      child: VerticalDivider(
                        color: isClicked ? Colors.blue : Colors.grey[350],
                        thickness: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildTopicCard(
                  context, topic, isClicked, index, exerciseTaken),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, Map<String, dynamic> topic,
      bool isClicked, int index, List<dynamic> exerciseTaken) {
    bool isExercise = topic.containsKey('questions');
    bool isLocked = topic['isLocked'];
    List<Map<String, dynamic>> userAnswers = [];

    if (isExercise && topic["isCompleted"]) {
      Map<String, dynamic> result = exerciseTaken.firstWhere(
        (map) => map["exercise_id"] == topic["id"],
        orElse: () => {},
      );

      userAnswers.add(result);
    }

    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          setState(() {
            clickedSteps.add(index);
          });

          if (isExercise) {
            if (topic["isCompleted"]) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ExerciseResultScreen(userAnswers: userAnswers)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExerciseScreen(
                          exerciseId: topic['id'],
                          topicId: widget.topicId,
                          topicTitle: widget.topicTitle,
                          totalExercise: widget.totalExercise,
                          totalLesson: widget.totalLesson,
                        )),
              );
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TopicCourseScreen(
                        lessonId: topic['id'],
                        courseTitle: topic['title'] as String? ?? '',
                        topicTitle: topic['title'] as String? ?? '',
                      )),
            );
          }
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12, left: 1),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: !topic["isLocked"]
                  ? Colors.white
                  : Colors.grey[350], // Warna berubah jika diklik
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  topic['icon'] as String,
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[700],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '+${topic['exp']} xp',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isExercise) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${topic['pts']} pts',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        topic['title']?.toString() ?? 'No Title',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isExercise) ...[
                        const Divider(),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/question_icon.png',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 5),
                            Text('${topic['questions']} Questions',
                                style: GoogleFonts.inter(fontSize: 14)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// final List<Map<String, dynamic>> topics = [
//   {
//     'title': 'Introduction',
//     'exp': 10,
//     'icon': 'assets/icons/introduction_icon.png',
//     'isCompleted': true
//   },
//   {
//     'title': 'Exercise I',
//     'exp': 50,
//     'pts': 10,
//     'questions': 10,
//     'icon': 'assets/icons/tasklist1_icon.png',
//     'isCompleted': true
//   },
//   {
//     'title': 'History of Programming',
//     'exp': 10,
//     'icon': 'assets/icons/course2_icon.png',
//     'isCompleted': false
//   },
//   {
//     'title': 'Exercise II',
//     'exp': 50,
//     'pts': 10,
//     'questions': 10,
//     'icon': 'assets/icons/tasklist1_icon.png',
//     'isCompleted': false
//   },
// ];
