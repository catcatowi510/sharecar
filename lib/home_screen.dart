import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'car_detail_screen.dart'; // 👈 Thêm file màn hình chi tiết
import 'model/cars.dart';

Future<List<Cars>> fetchCars() async {
  final response = await http.get(
    Uri.parse(
      'https://68f38e35fd14a9fcc4291b81.mockapi.io/share_cars/api/v1/cars',
    ),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> jsonList = json.decode(response.body);
    return jsonList
        .map((json) => Cars.fromMap(json as Map<String, dynamic>))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Cars>> futureCars;

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
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
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  // FutureBuilder
                  FutureBuilder<List<Cars>>(
                    future: futureCars,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Không có dữ liệu xe'));
                      }

                      final cars = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cars.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.9,
                            ),
                        itemBuilder: (context, index) {
                          final car = cars[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarDetailScreen(
                                    carName: car.name,
                                    price: car.price_hour.toString(),
                                    imagePath: car.image,
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
                                      child: Image.network(
                                        car.image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "Giá: ${car.price_hour}/giờ",
                                          style: const TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
