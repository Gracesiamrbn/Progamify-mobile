import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:progamify/api/discussion_service.dart';
import 'package:progamify/api/lesson_service.dart';
import 'package:progamify/presentation/screens/topic/write_discussion_screen.dart';
import 'discussion_reply_screen.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';

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
  bool _isExpPopupShown = false;

  // Audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundPlayed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    futureLesson = LessonService().getLesson(widget.lessonId);
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
    } else {
      _isSoundPlayed = false;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _audioPlayer.dispose();
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

          double screenHeight = MediaQuery.of(context).size.height;
          // var content = parse(html);
          // print(content);
          print(jsonEncode(content));

          // double screenWidth = MediaQuery.of(context).size.width;

          if (lessonData?['takeLesson'] != null && !_isExpPopupShown) {
            print(lessonData?['takeLesson']);
            int exp = lessonData?['exp'] ?? 0;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showExpPopup(context, exp);
            });
            _isExpPopupShown = true;
          } else {
            print('Sudah pernah dibaca');
          }

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
                                discussionTitle: discussions[index]['title']!,
                                author: discussions[index]['name']!,
                                date: discussions[index]['date']!,
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
                                    const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 10,
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
                                      // Navigasi ke DiscussionReplyScreen saat button diklik
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DiscussionReplyScreen(
                                            discussionTitle: discussions[index]
                                                ['title']!,
                                            author: discussions[index]['name']!,
                                            date: discussions[index]['date']!,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6FBAFF),
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Replies (0)',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter'),
                                    ),
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

  void _showExpPopup(BuildContext context, int exp) {
    _playSoundEffect('audio/mixkit-winning-notification-2018.wav');
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // Tidak bisa ditutup dengan tap luar
      barrierLabel: "",
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeOutBack, // Efek pop keluar
          ),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animation/Animation - 1742261944915.json',
                      repeat: false,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/icons/exp_point.png',
                      width: 64,
                      height: 64,
                    ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    text: "Anda mendapatkan ",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: "$exp EXP",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _stopSoundEffect();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Lanjutkan Belajar",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
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
}
