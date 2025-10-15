import 'package:flutter/material.dart';
import 'rental_checkout_screen.dart'; // import màn hình thanh toán

class CarDetailScreen extends StatelessWidget {
  final String carName;
  final String price;
  final String imagePath;

  const CarDetailScreen({
    super.key,
    required this.carName,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carName),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath,
                fit: BoxFit.cover, width: double.infinity, height: 250),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(carName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Giá thuê: $price/giờ",
                      style: const TextStyle(
                          color: Colors.orange, fontSize: 18)),
                  const SizedBox(height: 16),
                  const Text(
                    "Mô tả xe:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Xe được trang bị đầy đủ tiện nghi, nội thất rộng rãi, "
                    "hệ thống giải trí hiện đại và động cơ tiết kiệm nhiên liệu. "
                    "Phù hợp cho gia đình, công tác hoặc du lịch cuối tuần.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalCheckoutScreen(
                              carName: carName,
                              price: price,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.car_rental),
                      label: const Text('Thuê xe ngay',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
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
