class Cars {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> imageDetails; // 🆕
  final int pricePerDay;
  final String description;
  final bool available;
  final int seat;
  final String? type;
  final String? fuel;
  final int quantity;
  final int? discount;
  bool isFavorite;

  Cars({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imageDetails,
    required this.pricePerDay,
    required this.description,
    required this.available,
    required this.seat,
    this.type,
    this.fuel,
    required this.quantity,
    this.discount,
    this.isFavorite = false,
  });

  factory Cars.fromMap(Map<String, dynamic> json) {
    return Cars(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      imageDetails: List<String>.from(json['imageDetails'] ?? []),
      pricePerDay: json['pricePerDay'] ?? 0,
      description: json['description'] ?? '',
      available: json['available'] ?? true,
      seat: json['seat'] ?? 0,
      type: json['type'],
      fuel: json['fuel'],
      quantity: json['quantity'] ?? 0,
      discount: json['discount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
