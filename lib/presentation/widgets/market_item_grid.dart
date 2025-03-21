import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:progamify/api/avatar_service.dart';
import 'package:progamify/api/gift_service.dart';

class MarketItemGrid extends StatelessWidget {
  final int selectedTabIndex;
  final int selectedIndex;
  final ValueChanged<Map<String, dynamic>> onItemSelected;

  const MarketItemGrid({
    super.key,
    required this.selectedTabIndex,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  // static final List<Map<String, dynamic>> avatars = List.generate(
  //   12,
  //   (index) => {
  //     "name": "Avatar ${index + 1}",
  //     "image": "assets/avatars/avatar_${index + 1}.svg",
  //     "price": 1,
  //   },
  // );

  static final List<Map<String, dynamic>> avatars = [
    {
      "name": "Avatar 1",
      "image": "assets/avatars/avatar_1.svg",
      "price": 0,
      "owned": true,
      "selected": true
    },
    {
      "name": "Avatar 2",
      "image": "assets/avatars/avatar_2.svg",
      "price": 100,
      "owned": true,
      "selected": false
    },
    {
      "name": "Avatar 3",
      "image": "assets/avatars/avatar_3.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 4",
      "image": "assets/avatars/avatar_4.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 5",
      "image": "assets/avatars/avatar_5.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 6",
      "image": "assets/avatars/avatar_6.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 7",
      "image": "assets/avatars/avatar_7.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 8",
      "image": "assets/avatars/avatar_8.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 9",
      "image": "assets/avatars/avatar_9.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 10",
      "image": "assets/avatars/avatar_10.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 11",
      "image": "assets/avatars/avatar_11.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
    {
      "name": "Avatar 12",
      "image": "assets/avatars/avatar_12.svg",
      "price": 100,
      "owned": false,
      "selected": false
    },
  ];

  // static final List<Map<String, dynamic>> gifts = List.generate(
  //   12,
  //   (index) => {
  //     "name": "Gift ${index + 1}",
  //     "image": "assets/gifts/gift_${index + 1}.png",
  //     "price": (index + 1) * 15,
  //   },
  // );

  static final List<Map<String, dynamic>> gifts = [
    {"name": "Gift 1", "image": "assets/gifts/gift_1.png", "price": 10000},
    {"name": "Gift 2", "image": "assets/gifts/gift_2.png", "price": 20000},
    {"name": "Gift 3", "image": "assets/gifts/gift_3.png", "price": 50000},
    {"name": "Gift 4", "image": "assets/gifts/gift_4.png", "price": 100000},
    {"name": "Gift 5", "image": "assets/gifts/gift_5.png", "price": 100000},
    {"name": "Gift 6", "image": "assets/gifts/gift_6.png", "price": 100000},
    {"name": "Gift 7", "image": "assets/gifts/gift_7.png", "price": 100000},
    {"name": "Gift 8", "image": "assets/gifts/gift_8.png", "price": 15000},
    {"name": "Gift 9", "image": "assets/gifts/gift_9.png", "price": 10000},
    {"name": "Gift 10", "image": "assets/gifts/gift_10.png", "price": 10000},
    {"name": "Gift 11", "image": "assets/gifts/gift_11.png", "price": 30000},
    {"name": "Gift 12", "image": "assets/gifts/gift_12.png", "price": 50000},
  ];

  @override
  Widget build(BuildContext context) {
    if (selectedTabIndex == 0) {
      return FutureBuilder<List<Map<String, dynamic>>>(
          future: AvatarService().getAvatars(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final avatars = snapshot.data!;

              final List<Map<String, dynamic>> items = avatars;

              Logger().i(avatars);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return GestureDetector(
                      onTap: () => onItemSelected(
                          {"index": index, "item": items[index]}),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : Colors.grey[300]!,
                                  width: selectedIndex == index ? 2 : 1,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: selectedTabIndex == 0
                                        ? SvgPicture.network(
                                            item["image"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholderBuilder: (context) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        // SvgPicture.asset(
                                        //     item["image"],
                                        //     fit: BoxFit.cover,
                                        //     width: double.infinity,
                                        //     height: double.infinity,
                                        //     placeholderBuilder: (context) =>
                                        //         const Center(
                                        //       child: CircularProgressIndicator(),
                                        //     ),
                                        //   )
                                        : Image.asset(
                                            item["image"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                  ),

                                  // Tampilkan harga hanya jika:
                                  // 1. Item adalah avatar DAN belum dimiliki (`owned == false`)
                                  // 2. Item adalah gift (karena tidak punya `owned`)
                                  if ((item.containsKey("owned") &&
                                          !item["owned"]) ||
                                      !item.containsKey("owned"))
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1.5),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatPrice(item["price"]),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            SvgPicture.asset(
                                                "assets/icons/coin.svg",
                                                width: 14,
                                                height: 14),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          });
    } else {
      return FutureBuilder<List<Map<String, dynamic>>>(
          future: GiftService().getGifts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final gifts = snapshot.data!;

              final List<Map<String, dynamic>> items = gifts;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return GestureDetector(
                      onTap: () => onItemSelected(
                          {"index": index, "item": items[index]}),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : Colors.grey[300]!,
                                  width: selectedIndex == index ? 2 : 1,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: selectedTabIndex == 0
                                        ? SvgPicture.network(
                                            item["image"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholderBuilder: (context) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : Image.network(
                                            item["image"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                  ),
                                  if ((item.containsKey("owned") &&
                                          !item["owned"]) ||
                                      !item.containsKey("owned"))
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1.5),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatPrice(item["price"]),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            SvgPicture.asset(
                                                "assets/icons/coin.svg",
                                                width: 14,
                                                height: 14),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          });
    }
  }
}

String formatPrice(int price) {
  if (price >= 1000) {
    return "${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}k";
  }
  return price.toString();
}
