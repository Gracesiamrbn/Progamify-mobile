import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:progamify/api/discussion_service.dart';
import 'package:progamify/api/lesson_service.dart';
import 'package:progamify/presentation/screens/topic/write_discussion_screen.dart';
import 'discussion_reply_screen.dart';
import 'package:flutter_html/flutter_html.dart';

class TopicCourseScreen extends StatefulWidget {
  final String topicTitle;
  final int lessonId;
  const TopicCourseScreen(
      {super.key,
      required this.lessonId,
      required this.topicTitle,
      required String courseTitle});

  @override
  TopicCourseScreenState createState() => TopicCourseScreenState();
}

class TopicCourseScreenState extends State<TopicCourseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, dynamic>> futureLesson;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    futureLesson = LessonService().getLesson(widget.lessonId);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {}); // Perbarui tampilan saat tab berubah
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          widget.topicTitle,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Lesson'),
            Tab(text: 'Discussion'),
          ],
          indicatorColor: Colors.blue.shade700,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
        ),
      ),
      body: Container(
        color: Colors.white70,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLessonContent(),
            _buildDiscussionContent(),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              backgroundColor: Colors.blue[300],
              onPressed: () {
                // Aksi ketika tombol tambah diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WriteDiscussionScreen(lessonId: widget.lessonId)),
                );
              },
              child: const Icon(Icons.add, size: 32, color: Colors.white),
            )
          : null, // Tidak menampilkan tombol di tab "Lesson"
    );
  }

  Widget _buildLessonContent() {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureLesson, // The future that fetches lesson data
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          var lessonData = snapshot.data;

          String content = lessonData?['content'] ?? 'No content available';
          double screenWidth = MediaQuery.of(context).size.width;
          screenWidth = screenWidth - (20 + 20 + 16.8);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20)
                .copyWith(top: 30, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Html(
                    data: content,
                    style: {
                      "body": Style(
                        fontSize: FontSize(14.0),
                        color: Colors.black87,
                      ),
                      "p": Style(textAlign: TextAlign.justify),
                      "img": Style(
                        width: Width(screenWidth),
                        height: Height(screenWidth),
                        // margin: Margins(left: Margin(screenWidth * 0.05))
                      ),
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildDiscussionContent() {
    return FutureBuilder<List<Map<String, String>>>(
      future: DiscussionService().getDiscussions(widget.lessonId),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, String>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<Map<String, String>> discussions = snapshot.data!;

          Logger().i(discussions);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: discussions.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscussionReplyScreen(
                                discId: int.parse(discussions[index]['id']!),
                                discussionTitle: discussions[index]['title']!,
                                author: discussions[index]['name']!,
                                date: discussions[index]['date']!,
                                discussionContent: discussions[index]
                                    ['content']!,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 10,
                                      child: SvgPicture.asset(
                                        "assets/avatars/avatar_male_1.svg",
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      discussions[index]['name']!,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      discussions[index]['date']!,
                                      style: GoogleFonts.inter(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  discussions[index]['title']!,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  discussions[index]['content']!,
                                  style: GoogleFonts.inter(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DiscussionReplyScreen(
                                            discId: int.parse(
                                                discussions[index]['id']!),
                                            discussionTitle: discussions[index]
                                                ['title']!,
                                            author: discussions[index]['name']!,
                                            date: discussions[index]['date']!,
                                            discussionContent:
                                                discussions[index]['content']!,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                    ),
                                    child: const Text('Replies (0)'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('No discussions available.'));
      },
    );
  }
}
