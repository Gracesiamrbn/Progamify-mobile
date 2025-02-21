import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AchievementItem extends StatelessWidget {
  final Map<String, String> achievement;

  const AchievementItem({super.key, required this.achievement});

  void _showPopup(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _PopupScreen(achievement: achievement),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopup(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: achievement["icon"]!,
              child: SvgPicture.asset(
                achievement["icon"]!,
                width: 64,
                height: 64,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement["title"]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    achievement["description"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== POPUP SCREEN =====================
class _PopupScreen extends StatefulWidget {
  final Map<String, String> achievement;

  const _PopupScreen({required this.achievement});

  @override
  State<_PopupScreen> createState() => _PopupScreenState();
}

class _PopupScreenState extends State<_PopupScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), 
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _opacity,
            child: Stack(
              children: [
                // Kontainer utama popup
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: widget.achievement["icon"]!,
                        child: SvgPicture.asset(
                          widget.achievement["icon"]!,
                          width: 210,
                          height: 210,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Judul
                      Text(
                        widget.achievement["title"]!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      // Deskripsi
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.achievement["description"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                
                Positioned(
                  top: 40, // Jarak dari atas
                  right: 20, // Jarak dari kanan
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.close,
                          size: 30, color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
