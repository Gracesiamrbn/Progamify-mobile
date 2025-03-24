import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progamify/api/discussion_service.dart';
import 'package:progamify/utils/util.dart';

class DiscussionReplyScreen extends StatefulWidget {
  final String discussionTitle;
  final String author;
  final String date;
  final String discussionContent;
  final int discId;

  const DiscussionReplyScreen(
      {super.key,
      required this.discussionTitle,
      required this.author,
      required this.date,
      required this.discussionContent,
      required this.discId});

  @override
  DiscussionReplyScreenState createState() => DiscussionReplyScreenState();
}

class DiscussionReplyScreenState extends State<DiscussionReplyScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  void _submitReply() async {
    String value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() {
        _errorMessage = "Answer's Field must be filled";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await DiscussionService().submitReply(widget.discId, value);
      _controller.clear();
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to submit reply: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: DiscussionService().detailDiscussion(widget.discId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            Map<String, dynamic> discussions = snapshot.data!;
            var replies = discussions["replies"] ?? [];

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[300],
                title: const Text('Discussion'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 14,
                            child: ClipOval(
                              child: SvgPicture.network(
                                Util().getLinkLaravel(discussions["user"]
                                    ["avatar"]["picture_url"]),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            )),
                        const SizedBox(width: 8),
                        Text(
                          widget.author,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.date,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.discussionTitle,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.discussionContent,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your answer...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _submitReply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Reply'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: replies.length,
                        itemBuilder: (context, index) {
                          return _ReplyItem(
                            name: replies[index]["detail_user"]["name"],
                            date: Util()
                                .formatDateTime(replies[index]["CreatedAt"]),
                            content: replies[index]["content"],
                            picture: Util().getLinkLaravel(replies[index]
                                ["detail_user"]["avatar"]["picture_url"]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[300],
                title: const Text('Discussion'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 14,
                          child: ClipOval(
                            child: SvgPicture.asset(
                              "",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.author,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.date,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.discussionTitle,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.discussionContent,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your answer...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reply'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: const [],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

class _ReplyItem extends StatelessWidget {
  final String name;
  final String date;
  final String content;
  final String picture;

  const _ReplyItem(
      {required this.name,
      required this.date,
      required this.content,
      required this.picture});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    child: ClipOval(
                      child: SvgPicture.network(
                        picture,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    )),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  date,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
