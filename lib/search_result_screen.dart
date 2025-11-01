import 'package:flutter/material.dart';
import 'model/cars.dart';
import 'car_detail_screen.dart';
import 'services/api_service.dart';
import 'package:intl/intl.dart';

class SearchResultScreen extends StatefulWidget {
  final String location;
  final DateTime? startDate;
  final DateTime? endDate;

  const SearchResultScreen({
    super.key,
    required this.location,
    this.startDate,
    this.endDate,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<List<Cars>> futureCars;
  String selectedLocation = "";

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.location;
    futureCars = fetchCars({"location": selectedLocation});
  }

  Future<List<Cars>> fetchCars(Map<String, dynamic> req) async {
    try {
      final response = await ApiService.getCars(req);
      return response;
    } catch (e) {
      print("❌ Lỗi khi fetchCars: $e");
      return [];
    }
  }

  void _searchCars() {
    setState(() {
      futureCars = fetchCars({"location": selectedLocation});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm - ${widget.location}'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // 🔸 Thanh lọc tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🗺 Dropdown chọn địa điểm
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  decoration: InputDecoration(
                    labelText: 'Chọn địa điểm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Tất cả')),
                    DropdownMenuItem(
                        value: 'TP. Hồ Chí Minh', child: Text('TP. Hồ Chí Minh')),
                    DropdownMenuItem(value: 'Hà Nội', child: Text('Hà Nội')),
                    DropdownMenuItem(value: 'Đà Nẵng', child: Text('Đà Nẵng')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value ?? "";
                    });
                  },
                ),

                const SizedBox(height: 16),

                // 🔶 Nút tìm kiếm
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _searchCars,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text(
                      'TÌM XE PHÙ HỢP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📋 Danh sách xe kết quả
          Expanded(
            child: FutureBuilder<List<Cars>>(
              future: futureCars,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.orange));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không tìm thấy xe phù hợp'));
                }

                final cars = snapshot.data!;
                return ListView.builder(
                  itemCount: cars.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CarDetailScreen(carId: car.id),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(12),
                              ),
                              child: Image.network(
                                car.imageUrl,
                                width: 120,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Giá: ${currencyFormatter.format(car.pricePerDay)}/ngày",
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Loại: ${car.type}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
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
          ),
        ],
      ),
    );
  }
}
