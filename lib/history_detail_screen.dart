import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/rental_history.dart';
import '../services/api_service.dart';

class HistoryDetailScreen extends StatefulWidget {
  final String rentalId; // truyền id của lịch sử thuê xe

  const HistoryDetailScreen({super.key, required this.rentalId});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  late Future<RentalHistory> futureDetail;

  @override
  void initState() {
    super.initState();
    // 👉 Gọi API để lấy chi tiết lịch sử thuê
    futureDetail = ApiService.fetchRentalDetail(widget.rentalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết lịch sử thuê xe"),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<RentalHistory>(
        future: futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi khi tải dữ liệu: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Không có dữ liệu chi tiết"));
          }

          final history = snapshot.data!;
          final NumberFormat formatCurrency = NumberFormat("#,##0", "vi_VN");

          final priceValue = int.tryParse(
                  history.price.toString().replaceAll(RegExp(r'[^0-9]'), '')) ??
              0;
          final priceText = "${formatCurrency.format(priceValue)} đ";

          Color statusColor;
          switch (history.status.toLowerCase()) {
            case 'hoàn thành':
              statusColor = Colors.green;
              break;
            case 'đang xử lý':
              statusColor = Colors.orange;
              break;
            default:
              statusColor = Colors.red;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼️ Ảnh xe
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    history.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/bg_car.jpg',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),

                // 🚗 Tên xe + trạng thái
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        history.carName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        history.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Thông tin thuê xe",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                _buildInfoRow(Icons.calendar_today, "Ngày thuê",
                    history.rentalDate),
                _buildInfoRow(Icons.timer, "Thời gian thuê",
                    history.duration ?? "Không rõ"),
                _buildInfoRow(Icons.location_on, "Địa điểm nhận xe",
                    history.pickupLocation ?? "Không có thông tin"),
                _buildInfoRow(Icons.location_off, "Địa điểm trả xe",
                    history.returnLocation ?? "Không có thông tin"),

                if (history.description?.isNotEmpty ?? false)
                  _buildInfoRow(Icons.notes, "Ghi chú", history.description!),

                const SizedBox(height: 20),

                const Text(
                  "Chi tiết chi phí",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        _buildCostRow("Phí thuê xe", priceText),
                        _buildCostRow("Thuế VAT (10%)",
                            "${formatCurrency.format(priceValue * 0.1)} đ"),
                        const Divider(),
                        _buildCostRow("Tổng cộng",
                            "${formatCurrency.format(priceValue * 1.1)} đ",
                            isBold: true, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String title, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
