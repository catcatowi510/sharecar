class RentalHistory {
  final String id;
  final String userName;
  final String rentalDate;
  final String startDate;
  final String endDate;
  final int duration;
  final String pickupLocation;
  final String status;
  final int price;
  final String? imageUrl;
  final String? carName;
  final int statusPayment;
  RentalHistory({
    required this.id,
    required this.userName,
    required this.rentalDate,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.pickupLocation,
    required this.status,
    required this.price,
    this.imageUrl,
    this.carName,
    required this.statusPayment,
  });

  factory RentalHistory.fromJson(Map<String, dynamic> json) {
    return RentalHistory(
      id: json['_id'] ?? '',
      userName: json['user'] != null ? json['user']['name'] ?? 'Không rõ' : 'Không rõ',
      rentalDate: json['createdAt'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      duration: json['duration'] ?? 0,
      pickupLocation: json['pickupLocation'] ?? 'Không có thông tin',
      status: json['status'] ?? 'Không rõ',
      price: json['price'] ?? 0,
      imageUrl: json['car'] != null ? json['car']['imageUrl'] ?? 'Không rõ' : 'Không rõ',
      carName: json['car'] != null ? json['car']['name'] ?? 'Không rõ' : 'Không rõ',
      statusPayment: json['statusPayment'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userName': userName,
      'rentalDate': rentalDate,
      'startDate': startDate,
      'endDate': endDate,
      'duration': duration,
      'pickupLocation': pickupLocation,
      'status': status,
      'price': price,
      'imageUrl': imageUrl,
      'carName': carName,
      'statusPayment': statusPayment,
    };
  }
}
