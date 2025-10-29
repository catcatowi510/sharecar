import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'rental_checkout_screen.dart';
import 'model/cars.dart';

class CarDetailScreen extends StatefulWidget {
  final String carId;

  const CarDetailScreen({super.key, required this.carId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  Cars? car;
  bool isLoading = true;
  bool hasError = false;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCarDetail();
  }

  Future<void> fetchCarDetail() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://68f38e35fd14a9fcc4291b81.mockapi.io/share_cars/api/v1/cars/${widget.carId}',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          car = Cars.fromMap(jsonData);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load car detail');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  bool _isNetworkImage(String path) {
    return path.startsWith('http') || path.startsWith('https');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car?.name ?? 'Chi tiết xe'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : hasError
              ? const Center(
                  child: Text(
                    'Không thể tải thông tin xe.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🎞 Banner ảnh chi tiết xe
                      if (car!.imageUrl.isNotEmpty)
                        _buildImageCarousel(car!.imageDetails)
                      else
                        _buildSingleImage(car!.imageUrl),

                      // 🧾 Thông tin chi tiết xe
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car!.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Giá thuê: ${car!.pricePerDay}đ/ngày",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.event_seat, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text("${car!.seat} chỗ",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.category, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text("Loại xe: ${car!.type}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.local_gas_station,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Text("Nhiên liệu: ${car!.fuel}",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Mô tả xe:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              car!.description.isNotEmpty
                                  ? car!.description
                                  : "Xe chưa có mô tả chi tiết.",
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RentalCheckoutScreen(car: car!),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.car_rental,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Thuê xe ngay',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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

  /// 🖼 Nếu xe có nhiều ảnh: hiển thị carousel
  Widget _buildImageCarousel(List<String> images) {
    final controller = PageController(viewportFraction: 0.9);
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: controller,
            itemCount: images.length,
            onPageChanged: (index) => setState(() => activeIndex = index),
            itemBuilder: (context, index) {
              final img = images[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: _isNetworkImage(img)
                        ? NetworkImage(img)
                        : AssetImage(img) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (i) {
            final isActive = i == activeIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 12 : 8,
              height: isActive ? 12 : 8,
              decoration: BoxDecoration(
                color: isActive ? Colors.orange : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }

  /// 🖼 Nếu chỉ có 1 ảnh
  Widget _buildSingleImage(String img) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _isNetworkImage(img)
            ? Image.network(img, fit: BoxFit.cover, width: double.infinity, height: 250)
            : Image.asset(img, fit: BoxFit.cover, width: double.infinity, height: 250),
      ),
    );
  }
}
