import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progamify/api/auth_service.dart';
import 'topic_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<Map<String, dynamic>> topics = [];

  final AuthService _authService = AuthService();
  bool previousCompleted = true;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    final String? _authToken = await _authService.getToken();

    try {
      final String baseUrl =
          dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
      final response = await http.get(
        Uri.parse('$baseUrl/topics'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> topicsList = json.decode(response.body);

        setState(() {
          topics = topicsList
              .map((topic) => {
                    'id': topic['id'],
                    'title': topic['name'] ?? 'Untitled Topic',
                    'sections':
                        topic['total_lessons'] + topic['total_exercises'],
                    'completed': topic['total_take_lessons'] +
                        topic['total_take_exercises'],
                    'total_lessons': topic['total_lessons'],
                    'total_exercises': topic['total_exercises']
                  })
              .toList();
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16)
              .copyWith(top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(child: _buildTopicList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Topics',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'CHOOSE A TOPIC TO LEARN TODAY!',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicList() {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        bool isLocked = !previousCompleted;
        int totalSections = topics[index]['sections'];
        int completedSections = topics[index]['completed'];
        previousCompleted = completedSections >= totalSections;
        return _buildTopicCard(topics[index], isLocked);
      },
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic, bool isLocked) {
    int totalSections = topic['sections'];
    int completedSections = topic['completed'];
    double progress =
        totalSections == 0 ? 0 : completedSections / totalSections;

    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicDetailScreen(
                topicId: topic['id'],
                topicTitle: topic['title'],
                totalLesson: topic['total_lessons'],
                totalExercise: topic['total_exercises'],
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked
              ? Colors.grey.shade400.withOpacity(0.7)
              // : const Color.fromARGB(255, 93, 134, 168),
              : Colors.blue.shade200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic['title'],
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$totalSections SECTION',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '$completedSections of $totalSections',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.blue.shade700,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
