import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/cars.dart';

class RentalCheckoutScreen extends StatefulWidget {
  final Cars car;

  const RentalCheckoutScreen({super.key, required this.car});

  @override
  State<RentalCheckoutScreen> createState() => _RentalCheckoutScreenState();
}

class _RentalCheckoutScreenState extends State<RentalCheckoutScreen> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController addressController = TextEditingController();
  final formatCurrency = NumberFormat("#,###", "vi_VN");
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  double get totalCost {
    if (startDate == null || endDate == null) return 0;
    int days = endDate!.difference(startDate!).inDays + 1;
    double pricePerHour = widget.car.priceHour.toDouble();
    double base = pricePerHour * 24 * days;
    double vat = base * 0.1;
    double deposit = 10000000;
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
            const SizedBox(height: 10),
            Text(
              'Giá thuê: ${formatCurrency.format(car.priceHour)}đ/giờ',
              style: const TextStyle(fontSize: 16, color: Colors.orange),
            ),
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
                      'Phí thuê xe (${_daysText()})',
                      totalCost == 0
                          ? '—'
                          : '${formatCurrency.format((totalCost - 10000000) / 1.1)}đ',
                    ),
                    _buildCostRow(
                      'Thuế VAT (10%)',
                      totalCost == 0
                          ? '—'
                          : '${formatCurrency.format((totalCost - 10000000) * 0.1 / 1.1)}đ',
                    ),
                    _buildCostRow('Tiền cọc', '10.000.000đ'),
                    const Divider(),
                    _buildCostRow(
                      'Tổng cộng',
                      totalCost == 0
                          ? '—'
                          : '${formatCurrency.format(totalCost)}đ',
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
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('🚗 Thuê xe ${car.name} thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );
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

  Widget _buildCostRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? Colors.orange : Colors.black87,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
