import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/rental_history.dart';
import '../services/api_service.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<RentalHistory>> futureHistory;
  final NumberFormat formatCurrency = NumberFormat("#,##0", "vi_VN");
  final dateFormat = DateFormat('dd/MM/yyyy');
  @override
  void initState() {
    super.initState();
    futureHistory = ApiService.fetchRentalHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử thuê xe'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<RentalHistory>>(
        future: futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Chưa có lịch sử thuê xe"));
          }

          final history = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: history.length,

            itemBuilder: (context, index) {
              final item = history[index];

              // Xác định màu trạng thái
              Color statusColor;
              switch (item.status) {
                case 'Hoàn thành':
                  statusColor = Colors.green;
                  break;
                case 'Đang xử lý':
                  statusColor = Colors.orange;
                  break;
                default:
                  statusColor = Colors.red;
              }

              // Xử lý giá tiền (ép kiểu an toàn)
              final priceValue =
                  int.tryParse(
                    item.price.toString().replaceAll(RegExp(r'[^0-9]'), ''),
                  ) ??
                  0;
              final priceText = "${formatCurrency.format(priceValue)} đ";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HistoryDetailScreen(rentalId: item.id),
                      ),
                    );

                    if (result == true) {
                      setState(() {
                        futureHistory =
                            ApiService.fetchRentalHistory(); // ✅ gọi lại API
                      });
                    }
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/bg_car.jpg',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    item.carName!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "${dateFormat.format(DateTime.parse(item.rentalDate))} - $priceText",
                  ),
                  trailing: Text(
                    item.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
