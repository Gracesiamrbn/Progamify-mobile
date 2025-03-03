import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  MarketScreenState createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  int selectedAvatarIndex = 0; 
  int selectedTabIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              const Text(
                '512',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    "assets/icons/coin.svg",
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Tampilan Avatar Besar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SvgPicture.asset(
                "assets/avatars/avatar_${selectedAvatarIndex + 1}.svg",
                fit: BoxFit.contain,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),

          // Tab Selection: Avatar & Gift
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Avatar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Gift",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid Avatar untuk dipilih dengan harga
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 kolom sesuai dengan gambar
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.9, // Disesuaikan untuk label harga
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatarIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selectedAvatarIndex == index
                                    ? Colors.blue
                                    : Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: SvgPicture.asset(
                                "assets/avatars/avatar_${index + 1}.svg",
                                fit: BoxFit.cover,
                                placeholderBuilder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "100",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: SvgPicture.asset(
                                  "assets/icons/coin.svg",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Tombol Selected
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                // Handle konfirmasi pemilihan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Selected",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}