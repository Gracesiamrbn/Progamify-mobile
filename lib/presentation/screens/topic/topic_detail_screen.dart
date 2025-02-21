import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progamify/presentation/screens/topic/topic_course_screen.dart';
import 'package:progamify/presentation/screens/topic/excercise_screen.dart';

class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({super.key, required String topicTitle});

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
                      'Introduction',
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
                      bottom: MediaQuery.of(context).size.width * 0.07,
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
                                Text('5 Lessons',
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
                                Text('5 Exercises',
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
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: _buildTopicCards(context),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTopicCards(BuildContext context) {
    final topics = [
      {
        'title': 'Introduction',
        'exp': 10,
        'icon': 'assets/icons/introduction_icon.png'
      },
      {
        'title': 'Exercise I',
        'exp': 50,
        'pts': 10,
        'questions': 10,
        'icon': 'assets/icons/tasklist1_icon.png'
      },
      {
        'title': 'History of Programming',
        'exp': 10,
        'icon': 'assets/icons/course2_icon.png'
      },
      {
        'title': 'Exercise II',
        'exp': 50,
        'pts': 10,
        'questions': 10,
        'icon': 'assets/icons/tasklist1_icon.png'
      },
    ];

    return topics.map((topic) {
      bool isExercise = topic.containsKey('questions');
      return GestureDetector(
        onTap: () {
          if (isExercise) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExerciseScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TopicCourseScreen(
                        courseTitle: topic['title'] as String? ?? '',
                        topicTitle: '',
                      )),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12, left: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
    }).toList();
  }
}
