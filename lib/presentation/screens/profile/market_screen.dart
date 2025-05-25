import 'package:flutter/material.dart';
import '../../widgets/market_app_bar.dart';
import '../../widgets/market_tab_selector.dart';
import '../../widgets/market_item_grid.dart';
import '../../widgets/market_selected_item.dart';
import '../../widgets/market_purchase_button.dart';

class MarketScreen extends StatefulWidget {
  final int selectedTabIndex;

  const MarketScreen({super.key, this.selectedTabIndex = 0});

  @override
  MarketScreenState createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  int selectedTabIndex = 0;
  int selectedAvatarIndex = 0;
  int selectedAvatarId = 0;
  int selectedGiftId = 0;
  int selectedGiftIndex = 0;
  dynamic selectedAvatar = {
    "id": 1,
    "owned": true,
    "image":
        "http://10.0.2.2:8000/storage/avatars/images/2jxSC7Jq8QixoTX2iXdHviVjkRWUE8xxk9vc1ii7.svg"
  };
  dynamic selectedGift = {
    "id": 1,
    "image":
        "http://10.0.2.2:8000/storage/gift/images/O7IC5S7HS64DOwLR0yuwUdAOkf0vxBTMwqa14YAI.png"
  };

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        return Scaffold(
          backgroundColor: const Color(0xFFEAF2FF),
          appBar: marketAppBar(context),
          body: Column(
            children: [
              isLandscape
                  ? const SizedBox(height: 1)
                  : MarketSelectedItem(
                      selectedIndex: selectedTabIndex == 0
                          ? selectedAvatarIndex
                          : selectedGiftIndex,
                      selectedItem:
                          selectedTabIndex == 0 ? selectedAvatar : selectedGift,
                      selectedTabIndex: selectedTabIndex,
                    ),
              MarketTabSelector(
                selectedTabIndex: selectedTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
              ),
              Expanded(
                child: MarketItemGrid(
                  selectedTabIndex: selectedTabIndex,
                  selectedIndex: selectedTabIndex == 0
                      ? selectedAvatarIndex
                      : selectedGiftIndex,
                  onItemSelected: (data) {
                    setState(() {
                      if (selectedTabIndex == 0) {
                        selectedAvatarIndex = data["index"];
                        selectedAvatar = data["item"];
                      } else {
                        selectedGiftIndex = data["index"];
                        selectedGift = data["item"];
                      }
                    });
                  },
                ),
              ),
              MarketPurchaseButton(
                selectedIndex: selectedTabIndex == 0
                    ? selectedAvatarIndex
                    : selectedGiftIndex,
                selectedItem:
                    selectedTabIndex == 0 ? selectedAvatar : selectedGift,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
