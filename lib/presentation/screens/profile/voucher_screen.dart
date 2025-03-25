import 'package:flutter/material.dart';
import 'package:progamify/api/gift_service.dart';
import 'package:progamify/utils/util.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  VoucherScreenState createState() => VoucherScreenState();
}

class VoucherScreenState extends State<VoucherScreen> {
  void showVoucherDetails(BuildContext context, Map<String, dynamic> voucher) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            voucher['title']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blueAccent,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Menambahkan preview image voucher di tengah
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  voucher['image']!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Tukarkan voucher ini dengan hadiah nyata!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              Text(
                voucher["is_active"]
                    ? "Voucher ini masih belum digunakan"
                    : "Voucher ini telah digunakan",
                style: TextStyle(
                  color:
                      voucher["is_active"] ? Colors.green : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
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
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: GiftService().getUserGift(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'My Voucher',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                centerTitle: true,
                elevation: 5,
              ),
              body: Center(
                child: Text(
                  'Kamu tidak memiliki voucher',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
            );
          } else {
            final vouchers = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'My Voucher',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                centerTitle: true,
                elevation: 5,
              ),
              body: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ListView.builder(
                  itemCount: vouchers.length,
                  itemBuilder: (context, index) {
                    final voucher = vouchers[index];
                    // Parse date string to formatted date
                    final formattedDate =
                        Util().formatDateTime(voucher["created_at"]);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                              voucher['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                  "Tukarkan voucher ini dengan hadiah nyata!",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  voucher["is_active"]
                                      ? "Voucher ini masih belum digunakan"
                                      : "Voucher ini telah digunakan",
                                  style: TextStyle(
                                    color: voucher["is_active"]
                                        ? Colors.green
                                        : Colors.red.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: ClipOval(
                                child: Image.network(
                                  voucher['image']!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () => {},
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                formattedDate,
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
                  },
                ),
              ),
            );
          }
        });
  }
}
