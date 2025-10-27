class Cars {
  final String id;
  final String name;
  final String image;
  final List<String> images;
  final int priceHour;
  final int priceDay;
  final int priceMonth;
  final String description;
  final int seat;
  final String type;
  final String fuel;

  Cars({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.priceHour,
    required this.priceDay,
    required this.priceMonth,
    required this.description,
    required this.seat,
    required this.type,
    required this.fuel,
  });

  factory Cars.fromMap(Map<String, dynamic> json) {
    return Cars(
      id: json['id'].toString(),
      name: json['name'] ?? 'Chưa có tên',
      image: json['image'] ?? '',
      images: (json['images'] != null)
          ? List<String>.from(json['images'])
          : [], // parse mảng ảnh chi tiết
      priceHour: int.tryParse(json['price_hour'].toString()) ?? 0,
      priceDay: int.tryParse(json['price_day'].toString()) ?? 0,
      priceMonth: int.tryParse(json['price_month'].toString()) ?? 0,
      description: json['description'] ?? '',
      seat: int.tryParse(json['seat'].toString()) ?? 0,
      type: json['type'] ?? 'Không rõ',
      fuel: json['fuel'] ?? 'Không rõ',
    );
  }

  factory Cars.fromJson(Map<String, dynamic> json) => Cars.fromMap(json);
}
