class Cars {
  final String id;
  final String name;
  final String image;
  final int price_hour;
  final int price_day;
  final int price_month;
  final String description;
  final int seat;
  final String type;
  final String fuel;

  Cars(
    this.id,
    this.name,
    this.image,
    this.price_hour,
    this.price_day,
    this.price_month,
    this.description,
    this.seat,
    this.type,
    this.fuel,
  );
  factory Cars.fromMap(Map<String, dynamic> json) {
    return Cars(json['id'], json['name'], json['image'], json['price_hour'], json['price_day'], 
      json['price_month'], json['description'], json['seat'], json['type'], json['fuel']);
  }
  factory Cars.fromJson(Map<String, dynamic> json) {
    return Cars(json['id'], json['name'], json['image'], json['price_hour'], json['price_day'],
      json['price_month'], json['description'], json['seat'], json['type'], json['fuel']);
  }
}