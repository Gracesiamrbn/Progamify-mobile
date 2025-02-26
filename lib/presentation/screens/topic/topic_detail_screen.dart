import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progamify/presentation/screens/topic/topic_course_screen.dart';
import 'package:progamify/presentation/screens/topic/excercise_screen.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({super.key, required String topicTitle});
  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  final Set<int> clickedSteps =
      {}; // Menyimpan indeks langkah yang sudah diklik

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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    int nextIndex = index + 1;
                    bool nextOneDone = true;
                    if (nextIndex < topics.length) {
                      nextOneDone = topics[nextIndex]['isCompleted'] ?? false;
                    }
                    return _buildStepCard(context, topics[index], index);
                  },
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

  Widget _buildStepCard(
      BuildContext context, Map<String, dynamic> topic, int index) {
    bool isClicked = clickedSteps.contains(index); // Cek apakah sudah diklik

    return GestureDetector(
      onTap: () {
        setState(() {
          clickedSteps.add(index); // Simpan langkah yang diklik
        });
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                children: [
                  if (index != 0)
                    Expanded(
                      child: VerticalDivider(
                        color: isClicked ? Colors.blue : Colors.grey,
                        thickness: 5,
                      ),
                    ),
                  Icon(
                    Icons.circle,
                    color: isClicked ? Colors.blue : Colors.grey,
                    size: 20,
                  ),
                  if (index != topics.length - 1)
                    Expanded(
                      child: VerticalDivider(
                        color: isClicked ? Colors.blue : Colors.grey,
                        thickness: 5,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _buildTopicCard(context, topic, isClicked, index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, Map<String, dynamic> topic,
      bool isClicked, int index) {
    bool isExercise = topic.containsKey('questions');
    return GestureDetector(
      onTap: () {
        setState(() {
          clickedSteps.add(index); // Update state saat card diklik
        });

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
            margin: const EdgeInsets.only(bottom: 12, left: 1),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isClicked
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

final List<Map<String, dynamic>> topics = [
  {
    'title': 'Introduction',
    'exp': 10,
    'icon': 'assets/icons/introduction_icon.png',
    'isCompleted': true
  },
  {
    'title': 'Exercise I',
    'exp': 50,
    'pts': 10,
    'questions': 10,
    'icon': 'assets/icons/tasklist1_icon.png',
    'isCompleted': true
  },
  {
    'title': 'History of Programming',
    'exp': 10,
    'icon': 'assets/icons/course2_icon.png',
    'isCompleted': false
  },
  {
    'title': 'Exercise II',
    'exp': 50,
    'pts': 10,
    'questions': 10,
    'icon': 'assets/icons/tasklist1_icon.png',
    'isCompleted': false
  },
];
