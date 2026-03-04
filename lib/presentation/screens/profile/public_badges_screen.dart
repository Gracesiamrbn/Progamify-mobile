import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progamify/api/badge_service.dart';

class PublicBadgeScreen extends StatefulWidget {
  final int userId;

  const PublicBadgeScreen({super.key, required this.userId});

  @override
  _PublicBadgeScreenState createState() => _PublicBadgeScreenState();
}

class _PublicBadgeScreenState extends State<PublicBadgeScreen> {
  final bool _isLoading = true;
  late Future<List<Map<String, dynamic>>> _badgesFuture;

  @override
  void initState() {
    super.initState();
    _badgesFuture = BadgesService().getBadgesByUserId(widget.userId);
  }

  void _showBadgePopup(BuildContext context, Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.asset(
                  badge["picture"],
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                badge["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                badge["description"], // Menampilkan deskripsi
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color:
                      (badge["count"] == 0) ? Colors.grey.shade400 : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Jumlah: ${badge["count"]}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (badge["count"] == 0) ? Colors.grey : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> defaultBadges = [
      {
        "id": 1,
        "title": "Quest Beginner",
        "description": "Complete 10 quest for the first time",
        "picture": "assets/badges/quest_beginner_grey.svg"
      },
      {
        "id": 2,
        "title": "Warrior",
        "description": "Fall seven times, rise eight times",
        "picture": "assets/badges/warrior_grey.svg"
      },
      {
        "id": 3,
        "title": "Triple Win",
        "description": "Complete 3 consecutive quests perfectly",
        "picture": "assets/badges/triple_win_grey.svg"
      },
      {
        "id": 4,
        "title": "Ultimate Five",
        "description": "Complete 5 consecutive streaks perfectly",
        "picture": "assets/badges/ultimate_five_grey.svg"
      },
      {
        "id": 5,
        "title": "Legendary Ten",
        "description": "Complete 10 consecutive quests perfectly",
        "picture": "assets/badges/legendary_ten_grey.svg"
      },
      {
        "id": 6,
        "title": "Unstoppable Challenger",
        "description": "No Skips No Excuses - 7 days of quest mastery",
        "picture": "assets/badges/unstoppable_challenger_grey.svg"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285F4),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "User Badges",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter'),
        ),
      ),
      backgroundColor: Colors.orange[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _badgesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData ||
                snapshot.data!.isEmpty ||
                snapshot.data == null) {
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            // Data API yang didapat
            final apiBadges = snapshot.data ?? [];

            // Gabungkan data API dengan default badges
            final combinedBadges = defaultBadges.map((defaultBadge) {
              // Cek apakah badge ini ada di API
              final foundBadge = apiBadges.firstWhere(
                (badge) => badge["id"] == defaultBadge["id"],
                orElse: () =>
                    defaultBadge, // Jika tidak ada, pakai default badge
              );

              // Jika ditemukan di API, pakai gambar aslinya & tambahkan count
              return {
                "id": foundBadge["id"],
                "title": foundBadge["title"],
                "description": foundBadge["description"],
                "picture": foundBadge.containsKey("count")
                    ? foundBadge["picture"]
                    : defaultBadge["picture"],
                "count":
                    foundBadge["count"] ?? 0, // Default count 0 jika tidak ada
              };
            }).toList();

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: combinedBadges.length,
              itemBuilder: (context, index) {
                final badge = combinedBadges[index];

                return GestureDetector(
                  onTap: () => _showBadgePopup(context, badge),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SvgPicture.asset(
                                badge["picture"],
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Tampilkan count hanya jika lebih dari 0
                          if (badge["count"] > 0)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text(
                                  'x${badge["count"]}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 120,
                        child: Text(
                          badge["title"],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
