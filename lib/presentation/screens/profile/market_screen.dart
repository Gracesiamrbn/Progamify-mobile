import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/market_app_bar.dart';
import '../../widgets/market_tab_selector.dart';
import '../../widgets/market_item_grid.dart';
import '../../widgets/market_selected_item.dart';
import '../../widgets/market_purchase_button.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  MarketScreenState createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  int selectedTabIndex = 0;
  int selectedAvatarIndex = 0;
  int selectedGiftIndex = 0;

  @override
  Widget build(BuildContext context) {
    // int currentSelectedIndex =
    //     selectedTabIndex == 0 ? selectedAvatarIndex : selectedGiftIndex;
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2FF),
      appBar: marketAppBar(context),
      body: Column(
        children: [
          MarketSelectedItem(
            selectedIndex:
                selectedTabIndex == 0 ? selectedAvatarIndex : selectedGiftIndex,
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
              onItemSelected: (index) {
                setState(() {
                  if (selectedTabIndex == 0) {
                    selectedAvatarIndex = index;
                  } else {
                    selectedGiftIndex = index;
                  }
                });
              },
            ),
          ),
          MarketPurchaseButton(
            selectedIndex:
                selectedTabIndex == 0 ? selectedAvatarIndex : selectedGiftIndex,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
