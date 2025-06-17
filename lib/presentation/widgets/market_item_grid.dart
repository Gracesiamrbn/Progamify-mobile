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
                    bool isSvg = item["image"].toLowerCase().endsWith('.svg');
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
                                    child: isSvg
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
                                            // Use Image.network for non-SVG network images
                                            item["image"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Center(
                                                    child: Icon(Icons.error)),
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
              Logger().i(items);
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
                    bool isSvg = item["image"].toLowerCase().endsWith('.svg');
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
                                    child: isSvg
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
                                            // Use Image.network for non-SVG network images
                                            item["image"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Center(
                                                    child: Icon(Icons.error)),
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
