import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:progamify/api/avatar_service.dart';
import 'package:progamify/api/gift_service.dart';
import 'package:progamify/api/user_service.dart';
import 'package:progamify/presentation/screens/profile/market_screen.dart';

class MarketPurchaseButton extends StatefulWidget {
  final int selectedIndex;
  final dynamic selectedItem;

  const MarketPurchaseButton(
      {super.key, required this.selectedIndex, required this.selectedItem});

  @override
  MarketPurchaseButtonState createState() => MarketPurchaseButtonState();
}

class MarketPurchaseButtonState extends State<MarketPurchaseButton> {
  bool _isLoading = false;

  void _showDialog(String title, String content, {bool success = true}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(title,
            style: TextStyle(color: success ? Colors.green : Colors.red)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MarketScreen()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedItem["owned"] != null) {
      Logger().i(widget.selectedItem);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.selectedIndex >= 0 && !_isLoading
                ? () async {
                    if (widget.selectedItem["owned"]) {
                      setState(() {
                        _isLoading = true;
                      });
                      await UserService()
                          .changeAvatar(widget.selectedItem["id"]);
                      _showDialog("Success", "Change avatar successfully.");
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        if (widget.selectedItem["owned"]) {
                          await UserService()
                              .changeAvatar(widget.selectedItem["id"]);
                          _showDialog("Success",
                              "Avatar has been changed successfully.");
                        } else {
                          try {
                            await AvatarService()
                                .buyAvatar(widget.selectedItem["id"]);
                            _showDialog(
                                "Success", "Avatar purchased successfully.");
                          } on HttpException catch (e) {
                            if (e.message.contains("400")) {
                              _showDialog("Failed",
                                  "Unable to purchase avatar. Please check your balance or try again.",
                                  success: false);
                            } else {
                              _showDialog("Failed",
                                  "Unable to purchase avatar. Please check your balance or try again.",
                                  success: false);
                            }
                          } catch (e) {
                            _showDialog("Failed",
                                "Unable to purchase avatar. Please check your balance or try again.",
                                success: false);
                          }
                        }
                      } catch (e) {
                        _showDialog(
                            "Error", "Something went wrong. Please try again.",
                            success: false);
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.selectedIndex >= 0
                  ? (widget.selectedItem["owned"]
                      ? Colors.green
                      : Colors.orange)
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.selectedItem["owned"] ? "Use Avatar" : "Purchase",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      );
    } else {
      Logger().i(widget.selectedItem);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.selectedIndex >= 0 && !_isLoading
                ? () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await GiftService().buyGift(widget.selectedItem["id"]);
                      _showDialog("Success", "Gift purchased successfully.");
                    } on HttpException catch (e) {
                      if (e.message.contains("400")) {
                        _showDialog("Failed",
                            "Unable to purchase gift. Please check your balance or try again.",
                            success: false);
                      } else {
                        _showDialog("Failed",
                            "Unable to purchase gift. Please check your balance or try again.",
                            success: false);
                      }
                    } catch (e) {
                      _showDialog("Failed",
                          "Unable to purchase gift. Please check your balance or try again.",
                          success: false);
                    }

                    setState(() {
                      _isLoading = false;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.selectedIndex >= 0 ? Colors.orange : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Purchase",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      );
    }
    // return const SizedBox.shrink();
  }
}
