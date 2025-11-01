import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/cars.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'services/api_service.dart';

Future<void> _payWithVnpay(
  BuildContext context,
  Map<String, dynamic> body,
  Cars car,
) async {
  try {
    final data = await ApiService.createpaymentVNPay(body);

    if (data["success"] == true) {
      //final paymentUrl = data["paymentUrl"];
      // Hiển thị thông báo SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đặt xe thành công!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      // Delay nhẹ để người dùng thấy thông báo
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể tạo thanh toán VNPay")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Lỗi thanh toán: $e")));
  }
}

class RentalCheckoutScreen extends StatefulWidget {
  final Cars car;

  const RentalCheckoutScreen({super.key, required this.car});

  @override
  State<RentalCheckoutScreen> createState() => _RentalCheckoutScreenState();
}

//car, startDate, endDate, pickupLocation
class _RentalCheckoutScreenState extends State<RentalCheckoutScreen> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController addressController = TextEditingController();
  final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'VNĐ',
  );
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  double get totalCost {
    if (startDate == null || endDate == null) return 0;
    int days = endDate!.difference(startDate!).inDays + 1;
    double pricePerDay = widget.car.pricePerDay.toDouble();
    int discount = widget.car.discount ?? 0;
    return (discount == 0
            ? pricePerDay
            : (pricePerDay - (pricePerDay * discount / 100))) *
        days;
  }

  double get totalCostOrigin {
    if (startDate == null || endDate == null) return 0;
    int days = endDate!.difference(startDate!).inDays + 1;
    double pricePerDay = widget.car.pricePerDay.toDouble();
    return pricePerDay * days;
  }

  double get totalCostFinal {
    if (startDate == null || endDate == null) return 0;
    int days = endDate!.difference(startDate!).inDays + 1;
    double pricePerDay = widget.car.pricePerDay.toDouble();
    int discount = widget.car.discount ?? 0;
    double base =
        (discount == 0
            ? pricePerDay
            : (pricePerDay - (pricePerDay * discount / 100))) *
        days;
    double vat = base * 0.08;
    double deposit = 0;
    return base + vat + deposit;
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = startDate;
          endDateController.text = DateFormat('dd/MM/yyyy').format(startDate!);
        }
      });
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận thuê xe'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 🏎 Thông tin xe
            Text(
              car.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (car.discount! > 0) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔸 Dòng 1: Giá gốc + giảm %
                  Row(
                    children: [
                      Text(
                        "Giá gốc: ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${currencyFormatter.format(car.pricePerDay)}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "-${car.discount}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 🔸 Dòng 2: Giá sau giảm
                  Text(
                    "Giá thuê: ${currencyFormatter.format(car.pricePerDay * (1 - car.discount! / 100))}/ngày",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ] else ...[
              // 🔸 Không có giảm giá
              Text(
                "Giá thuê: ${currencyFormatter.format(car.pricePerDay)}/ngày",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // 🗓️ Chọn thời gian thuê
            const Text(
              'Chọn thời gian thuê',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => pickStartDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          labelText: 'Ngày nhận xe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => pickEndDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: endDateController,
                        decoration: InputDecoration(
                          labelText: 'Ngày trả xe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 📍 Địa chỉ nhận xe
            const Text(
              'Địa chỉ nhận xe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Nhập địa chỉ nhận xe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 💰 Tổng chi phí
            const Text(
              'Tổng chi phí',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCostRow(
                      'Giá gốc (${_daysText()})',
                      totalCost == 0
                          ? '—'
                          : currencyFormatter.format(totalCostOrigin),
                    ),
                    _buildCostRow(
                      'Giảm giá (${car.discount}%)',
                      totalCostOrigin != 0 && car.discount! != 0
                          ? '-${currencyFormatter.format(totalCostOrigin * car.discount! / 100)}'
                          : '—',
                      isDiscount: true, // tuỳ chọn thêm
                    ),

                    _buildCostRow(
                      'Phí thuê xe (${_daysText()})',
                      totalCost == 0
                          ? '—'
                          : currencyFormatter.format(totalCost),
                    ),
                    _buildCostRow(
                      'Thuế VAT (8%)',
                      totalCost == 0
                          ? '—'
                          : currencyFormatter.format(totalCost * 0.08),
                    ),

                    // // 🔹 Thêm giảm giá (nếu có)
                    // if (car.discount! > 0)
                    //   _buildCostRow(
                    //     'Giảm giá (${car.discount}%)',
                    //     totalCost == 0
                    //         ? '—'
                    //         : '-${currencyFormatter.format(totalCost * (car.discount! / 100))}',
                    //     isDiscount: true, // tuỳ chọn thêm
                    //   ),
                    const Divider(),
                    // 🔹 Tổng cộng sau giảm giá
                    _buildCostRow(
                      'Tổng cộng',
                      totalCost == 0
                          ? '—'
                          : currencyFormatter.format(totalCostFinal),
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🔘 Nút thuê xe
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: totalCost == 0
                  ? null
                  : () async {
                      if (startDate == null ||
                          endDate == null ||
                          addressController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Vui lòng nhập đầy đủ thông tin thuê xe",
                            ),
                          ),
                        );
                        return;
                      }

                      final body = {
                        "car": car.id,
                        "pickupLocation": addressController.text,
                        "startDate": startDate!.toIso8601String(),
                        "endDate": endDate!.toIso8601String(),
                        "amount": totalCostFinal.toInt(),
                      };

                      await _payWithVnpay(context, body, car);
                    },
              child: const Text(
                'Thuê Xe',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _daysText() {
    if (startDate == null || endDate == null) return "—";
    final days = endDate!.difference(startDate!).inDays + 1;
    return "$days ngày";
  }

  Widget _buildCostRow(
    String label,
    String value, {
    bool isHighlight = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlight ? 16 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight
                  ? Colors.orange
                  : (isDiscount ? Colors.red : Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 16 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight
                  ? Colors.orange
                  : (isDiscount ? Colors.red : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class VnpayPaymentScreen extends StatefulWidget {
  final String paymentUrl;
  const VnpayPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<VnpayPaymentScreen> createState() => _VnpayPaymentScreenState();
}

class _VnpayPaymentScreenState extends State<VnpayPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán VNPay")),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.paymentUrl)),
      ),
    );
  }
}
