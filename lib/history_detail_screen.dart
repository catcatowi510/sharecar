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
  final NumberFormat formatCurrency = NumberFormat("#,##0", "vi_VN");
  final dateFormat = DateFormat('dd/MM/yyyy');

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

          final priceValue =
              int.tryParse(
                history.price.toString().replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
              0;
          final priceText = "${formatCurrency.format(priceValue)} VNĐ";
          final paymentStatus = history.statusPayment == 2
              ? "Đã thanh toán"
              : "Chưa thanh toán";
          final paymentColor = history.statusPayment == 2
              ? Colors.green
              : Colors.red;

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
                    history.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/bg_car.jpg',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🚗 Tên xe + trạng thái
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        history.carName!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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

                _buildInfoRow(
                  Icons.calendar_today,
                  "Ngày thuê",
                  dateFormat.format(DateTime.parse(history.rentalDate)),
                ),
                _buildInfoRow(
                  Icons.timer,
                  "Thời gian thuê",
                  history.duration.toString(),
                ),
                _buildInfoRow(
                  Icons.location_on,
                  "Địa điểm nhận xe",
                  history.pickupLocation,
                ),

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
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        _buildCostRow("Phí thuê xe", priceText),
                        const Divider(height: 20, color: Colors.grey),
                        _buildCostRow(
                          "Trạng thái thanh toán",
                          paymentStatus,
                          valueColor: paymentColor,
                        ),
                      ],
                    ),
                  ),
                ),
                if (history.status.toLowerCase() == "đang xử lý") ...[
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text(
                        "Hủy đơn thuê",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Xác nhận hủy đơn"),
                            content: const Text(
                              "Bạn có chắc muốn hủy đơn thuê xe này không?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Không"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("Hủy đơn"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            final success = await ApiService.cancelRental(
                              widget.rentalId,
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Đã hủy đơn thuê xe thành công",
                                  ),
                                ),
                              );
                              Navigator.pop(
                                context,
                                true
                              ); // quay lại danh sách lịch sử
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Không thể hủy đơn thuê xe"),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Lỗi khi hủy đơn: $e")),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
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

  Widget _buildCostRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
