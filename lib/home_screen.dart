import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'car_detail_screen.dart'; // Thêm file màn hình chi tiết
import 'model/cars.dart';
import 'search_result_screen.dart'; // 

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
  late final PageController _controller;
  int activeIndex = 0;
  String selectedLocation = 'Hà Nội';
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;

  final List<String> bannerImages = [
    'assets/images/bg_car.jpg',
    'assets/images/bg_car.jpg',
    'assets/images/bg_car.jpg',
  ];

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars();
    _controller = PageController(viewportFraction: 0.9);

    // 🎞 Tự động chuyển banner
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        int nextPage = (activeIndex + 1) % bannerImages.length;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        setState(() => activeIndex = nextPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(height: 10),

          // 🎞 Banner Carousel (thuần Flutter)
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _controller,
              itemCount: bannerImages.length,
              onPageChanged: (index) => setState(() => activeIndex = index),
              itemBuilder: (context, index) {
                final imagePath = bannerImages[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // 🔸 Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: activeIndex == index ? 12 : 8,
                height: activeIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: activeIndex == index
                      ? Colors.orange
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TÌM XE PHÙ HỢP',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // 🌍 Chọn địa điểm (Hàng 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedLocation,
                      isExpanded: true,
                      icon: const Icon(Icons.location_on, color: Colors.orange),
                      items: const [
                        DropdownMenuItem(
                          value: 'Hà Nội',
                          child: Text('Hà Nội'),
                        ),
                        DropdownMenuItem(
                          value: 'TP. Hồ Chí Minh',
                          child: Text('TP. Hồ Chí Minh'),
                        ),
                        DropdownMenuItem(
                          value: 'Đà Nẵng',
                          child: Text('Đà Nẵng'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 📅 Hàng 2: Chọn ngày bắt đầu & kết thúc
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => startDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                startDate == null
                                    ? 'Ngày bắt đầu'
                                    : '${startDate!.day}/${startDate!.month}/${startDate!.year}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                endDate ?? (startDate ?? DateTime.now()),
                            firstDate: startDate ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => endDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                endDate == null
                                    ? 'Ngày kết thúc'
                                    : '${endDate!.day}/${endDate!.month}/${endDate!.year}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultScreen(
                            location: selectedLocation,
                            startDate: startDate,
                            endDate: endDate,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text(
                      'TÌM XE NGAY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 🚗 Danh sách xe
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

                    return SizedBox(
                      height: 230, // chiều cao của danh sách xe
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // cuộn ngang
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          return buildCarCard(car, context);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 🚗 Danh sách xe
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'XE GIẢM GIÁ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

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

                    return SizedBox(
                      height: 230, // chiều cao của danh sách xe
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // cuộn ngang
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          return buildCarCard(car, context, showDiscount: true);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 🚗 Danh sách xe
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'XE ƯU THÍCH',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

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

                    return SizedBox(
                      height: 230, // chiều cao của danh sách xe
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // cuộn ngang
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          return buildCarCard(car, context);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCarCard(
  Cars car,
  BuildContext context, {
  bool showDiscount = false,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarDetailScreen(carId: car.id),
        ),
      );
    },
    child: Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷️ Hình + Nhãn giảm giá
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    car.image,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // 🟧 Nhãn giảm giá (chỉ hiển thị khi có)
                if (showDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'GIẢM 20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // 🧱 Thông tin xe
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Giá: ${car.priceHour}/giờ",
                    style: const TextStyle(color: Colors.orange, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
