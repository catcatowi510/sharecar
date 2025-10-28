class RentalHistory {
  final String id;
  final String carName;
  final String imageUrl;
  final String rentalDate;
  final String price;
  final String status;

  // ✅ Thêm trường mở rộng (tùy chọn)
  final String? duration; // Thời gian thuê (ví dụ: "2 ngày 4 giờ")
  final String? pickupLocation; // Địa điểm nhận xe
  final String? returnLocation; // Địa điểm trả xe
  final String? description; // Ghi chú thêm nếu cần

  RentalHistory({
    required this.id,
    required this.carName,
    required this.imageUrl,
    required this.rentalDate,
    required this.price,
    required this.status,
    this.duration,
    this.pickupLocation,
    this.returnLocation,
    this.description,
  });

  factory RentalHistory.fromJson(Map<String, dynamic> json) {
    return RentalHistory(
      id: json['id'] ?? '',
      carName: json['carName'] ?? 'Không rõ',
      imageUrl: json['imageUrl'] ?? '',
      rentalDate: json['rentalDate'] ?? '',
      price: json['price'] ?? '0',
      status: json['status'] ?? 'Chưa rõ',

      // ✅ Trường mở rộng
      duration: json['duration'] ?? 'Không xác định',
      pickupLocation: json['pickupLocation'] ?? 'Không có thông tin',
      returnLocation: json['returnLocation'] ?? 'Không có thông tin',
      description: json['description'] ?? '',
    );
  }
}
