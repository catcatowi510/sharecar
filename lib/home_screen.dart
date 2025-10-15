import 'package:flutter/material.dart';
import 'car_detail_screen.dart'; // 👈 Thêm file màn hình chi tiết

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các xe hiển thị
    final cars = [
      {'name': 'Toyota Raize', 'price': '460K', 'image': 'assets/images/bg_car.jpg'},
      {'name': 'Toyota Vios', 'price': '500K', 'image': 'assets/images/bg_car.jpg'},
      {'name': 'Toyota Camry', 'price': '650K', 'image': 'assets/images/bg_car.jpg'},
      {'name': 'Toyota Cross', 'price': '700K', 'image': 'assets/images/bg_car.jpg'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner lớn
            Stack(
              children: [
                Image.asset(
                  'assets/images/bg_car.jpg',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.black.withOpacity(0.4),
                ),
                const Positioned(
                  left: 20,
                  bottom: 20,
                  child: Text(
                    'Khám phá những mẫu xe tuyệt vời nhất với Share Car!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Danh sách xe
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'XE NỔI BẬT',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grid danh sách xe
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cars.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final car = cars[index];

                      return GestureDetector(
                        onTap: () {
                          // Khi bấm vào xe -> sang trang chi tiết
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailScreen(
                                carName: car['name']!,
                                price: car['price']!,
                                imagePath: car['image']!,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                  child: Image.asset(
                                    car['image']!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car['name']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                    Text(
                                      "Giá: ${car['price']}/giờ",
                                      style: const TextStyle(color: Colors.orange),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
