import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';
import 'package:progamify/api/badge_service.dart';

class BadgesSection extends StatefulWidget {
  final String title;

  const BadgesSection({super.key, this.title = "Quest Badges"});

  @override
  _BadgesSectionState createState() => _BadgesSectionState();
}

class _BadgesSectionState extends State<BadgesSection> {
  final BadgesService _badgesService = BadgesService();
  List<Map<String, dynamic>> _badges = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> defaultBadges = [
    {
      "id": 1,
      "title": "Quest Beginner",
      "description": "Complete 10 quest for the first time",
      "picture": "assets/badges/quest_beginner_grey.svg",
      "count": 0
    },
    {
      "id": 2,
      "title": "Warrior",
      "description": "Fall seven times, rise eight times",
      "picture": "assets/badges/warrior_grey.svg",
      "count": 0
    },
    {
      "id": 3,
      "title": "Triple Win",
      "description": "Complete 3 consecutive quests perfectly",
      "picture": "assets/badges/triple_win_grey.svg",
      "count": 0
    },
    {
      "id": 4,
      "title": "Ultimate Five",
      "description": "Complete 5 consecutive streaks perfectly",
      "picture": "assets/badges/ultimate_five_grey.svg",
      "count": 0
    }
  ];

  @override
  void initState() {
    super.initState();
    _fetchBadges();
  }

  Future<void> _fetchBadges() async {
    try {
      final data = await _badgesService.getBadges();

      if (data.isEmpty) {
        setState(() {
          _badges = defaultBadges;
          _isLoading = false;
        });
        return;
      }

      Map<int, Map<String, dynamic>> badgeMap = {
        for (var badge in data) badge['id']: badge
      };

      setState(() {
        _badges = defaultBadges.map((badge) {
          return badgeMap.containsKey(badge["id"])
              ? badgeMap[badge["id"]]!
              : badge;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showBadgePopup(BuildContext context, Map<String, dynamic> badge) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: BadgePopup(badge: badge),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _isLoading
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _badges.map((badge) {
                    return GestureDetector(
                      onTap: () => _showBadgePopup(context, badge),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Hero(
                            tag: "badge_${badge["id"]}",
                            child: SvgPicture.asset(
                              badge["picture"],
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                          if (badge["count"] > 0)
                            Positioned(
                              right: -5,
                              top: -5,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: Text(
                                  badge["count"].toString(),
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
                    );
                  }).toList(),
                ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                text: 'see more...',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.25,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MainScreen(currentIndex: 1, tabIndex: 1),
                      ),
                    );
                  },
              ),
            ),
          ),
          const SizedBox(height: 86),
        ],
      ),
    );
  }

  BadgePopup({required Map<String, dynamic> badge}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: "badge_${badge["id"]}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.asset(
                  badge["picture"],
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
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
              badge["description"],
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (badge["count"] > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red,
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
            const SizedBox(height: 10),
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
                  "Tutup",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
