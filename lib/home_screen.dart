import 'package:flutter/material.dart';
import 'dart:async';
import 'car_detail_screen.dart';
import 'model/cars.dart';
import 'search_result_screen.dart';
import 'services/api_service.dart';
import 'package:intl/intl.dart';

Future<List<Cars>> fetchCars(req) async {
  try {
    final response = await ApiService.getCars(req);
    return response;
  } catch (e) {
    return [];
  }
}

Future<List<Cars>> fetchLatestCars() async {
  try {
    final response = await ApiService.getLatestCars();
    return response;
  } catch (e) {
    return [];
  }
}

// Future<List<Cars>> fetchFavoriteCars() async {
//   try {
//     final response = await ApiService.getFavoriteCars();
//     return response;
//   } catch (e) {
//     return [];
//   }
// }

Future<List<Cars>> fetchDiscountedCars() async {
  try {
    final response = await ApiService.getDiscountedCars();
    return response;
  } catch (e) {
    return [];
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Cars>> futureCars;
  late Future<List<Cars>> favoriteCarsFuture;
  late Future<List<Cars>> discountedCarsFuture;
  List<Cars> latestCars = [];
  late final PageController _controller;
  int activeIndex = 0;
  Timer? _timer;

  String selectedLocation = '';
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars({"location": selectedLocation});
    //favoriteCarsFuture = fetchFavoriteCars(); // lấy userId từ local
    discountedCarsFuture = fetchDiscountedCars();
    _controller = PageController(viewportFraction: 0.9);
    _loadLatestCars();
  }

  Future<void> _loadLatestCars() async {
    try {
      final cars = await fetchLatestCars();
      setState(() => latestCars = cars);

      if (_timer == null && cars.isNotEmpty) {
        _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
          if (_controller.hasClients && latestCars.isNotEmpty) {
            int nextPage = (activeIndex + 1) % latestCars.length;
            _controller.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
            setState(() => activeIndex = nextPage);
          }
        });
      }
    } catch (e) {
      print('❌ Lỗi load latestCars: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(height: 10),

          // 🎞 Banner xe mới nhất
          SizedBox(
            height: 220,
            child: latestCars.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : PageView.builder(
                    controller: _controller,
                    itemCount: latestCars.length,
                    onPageChanged: (index) =>
                        setState(() => activeIndex = index),
                    itemBuilder: (context, index) {
                      final car = latestCars[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CarDetailScreen(carId: car.id),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(car.imageUrl),
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
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                car.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),

          // 🔸 Indicator
          if (latestCars.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                latestCars.length,
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

          // 🔎 Khu vực tìm kiếm
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
                _buildSearchSection(context),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildCarSection('XE NỔI BẬT', futureCars, context),
          const SizedBox(height: 20),
          _buildCarSection(
            'XE GIẢM GIÁ',
            discountedCarsFuture,
            context,
            showDiscount: true,
          ),
          //const SizedBox(height: 20),
          //_buildCarSection('XE ƯU THÍCH', favoriteCarsFuture, context),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Column(
      children: [
        // 🌍 Chọn địa điểm
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
                DropdownMenuItem(value: '', child: Text('Tất cả')),
                DropdownMenuItem(
                  value: 'TP. Hồ Chí Minh',
                  child: Text('TP. Hồ Chí Minh'),
                ),
                DropdownMenuItem(value: 'Hà Nội', child: Text('Hà Nội')),
                DropdownMenuItem(value: 'Đà Nẵng', child: Text('Đà Nẵng')),
              ],
              onChanged: (value) => setState(() => selectedLocation = value!),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // // 📅 Chọn ngày
        // Row(
        //   children: [
        //     Expanded(child: _buildDatePicker(context, true)),
        //     const SizedBox(width: 12),
        //     Expanded(child: _buildDatePicker(context, false)),
        //   ],
        // ),
        // const SizedBox(height: 12),

        // 🔎 Nút tìm kiếm
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchResultScreen(
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
            ),
          ),
        ),
      ],
    );
  }

  //   Widget _buildDatePicker(BuildContext context, bool isStart) {
  //     final date = isStart ? startDate : endDate;
  //     final label = isStart ? 'Ngày bắt đầu' : 'Ngày kết thúc';
  //     final icon = isStart ? Icons.calendar_today : Icons.calendar_month;

  //     return GestureDetector(
  //       onTap: () async {
  //         final picked = await showDatePicker(
  //           context: context,
  //           initialDate: date ?? DateTime.now(),
  //           firstDate: DateTime.now(),
  //           lastDate: DateTime(2100),
  //         );
  //         if (picked != null) {
  //           setState(() {
  //             if (isStart)
  //               startDate = picked;
  //             else
  //               endDate = picked;
  //           });
  //         }
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           border: Border.all(color: Colors.orange),
  //         ),
  //         child: Row(
  //           children: [
  //             Icon(icon, color: Colors.orange, size: 18),
  //             const SizedBox(width: 8),
  //             Text(
  //               date == null ? label : '${date.day}/${date.month}/${date.year}',
  //               style: const TextStyle(color: Colors.black87),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
}

Widget _buildCarSection(
  String title,
  Future<List<Cars>> futureCars,
  BuildContext context, {
  bool showDiscount = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
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
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];
                  return buildCarCard(car, context, showDiscount: showDiscount);
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget buildCarCard(
  Cars car,
  BuildContext context, {
  bool showDiscount = false
}) {
  final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'VNĐ',
  );

  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CarDetailScreen(carId: car.id)),
          );
        },
        child: Container(
          width: 160,
          margin: const EdgeInsets.only(right: 16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        car.imageUrl,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // ❤️ ICON YÊU THÍCH
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          final success = await ApiService.toggleFavorite(car);
                          if (success) {
                            setState(() {
                              car.isFavorite = !car.isFavorite;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            (car.isFavorite)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: (car.isFavorite)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    // 🔖 GIẢM GIÁ
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
                          child: Text(
                            "GIẢM ${car.discount}%",
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
                        "Giá: ${currencyFormatter.format(car.pricePerDay)}/ngày",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
