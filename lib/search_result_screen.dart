import 'package:flutter/material.dart';
import 'model/cars.dart';
import 'car_detail_screen.dart';
import 'services/api_service.dart';
import 'package:intl/intl.dart';

Future<List<Cars>> fetchCars() async {
  try {
    final response = await ApiService.getCars();
    return response;
  } catch (e) {
    return [];
  }
}

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

  @override
  void initState() {
    super.initState();
    futureCars = fetchCars();
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
          // 🔸 Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🗺 Hàng chọn địa điểm
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
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
                          DropdownMenuItem(
                            value: 'TP.HCM',
                            child: Text('TP. Hồ Chí Minh'),
                          ),
                          DropdownMenuItem(
                            value: 'Hà Nội',
                            child: Text('Hà Nội'),
                          ),
                          DropdownMenuItem(
                            value: 'Đà Nẵng',
                            child: Text('Đà Nẵng'),
                          ),
                        ],
                        onChanged: (value) {
                          // Lưu địa điểm được chọn
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 📅 Hàng chọn ngày bắt đầu & kết thúc
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Ngày bắt đầu',
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                        ),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            // Lưu ngày bắt đầu
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Ngày kết thúc',
                          prefixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                        ),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            // Lưu ngày kết thúc
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔶 Nút tìm xe phù hợp
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultScreen(
                            location:
                                'TP.HCM', // có thể thay bằng địa điểm người dùng chọn
                          ),
                        ),
                      );
                    },
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

          // 📋 Danh sách kết quả
          Expanded(
            child: FutureBuilder<List<Cars>>(
              future: futureCars,
              builder: (context, snapshot) {
                // Handling different connection states
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Check if data is null or empty
                  return const Center(child: Text('Không tìm thấy xe phù hợp'));
                }

                // Successfully fetched data
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
