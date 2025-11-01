import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? password; // Có thể không cần khi load từ API
  final int? birthYear;
  final String? gender;
  final List<String> favorites;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    this.birthYear,
    this.gender,
    this.favorites = const [],
    this.createdAt,
    this.updatedAt,
  });

  // 🧩 Factory constructor: tạo User từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'],
      birthYear: json['birthYear'],
      gender: json['gender'],
      favorites: json['favorites'] != null
          ? List<String>.from(json['favorites'].map((x) => x.toString()))
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // 🧩 Chuyển User sang JSON (ví dụ để gửi API)
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "birthYear": birthYear,
      "gender": gender,
      "favorites": favorites,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  // 📦 Hỗ trợ chuyển từ chuỗi JSON (khi dùng với http)
  static User fromJsonString(String str) => User.fromJson(json.decode(str));
  String toJsonString() => json.encode(toJson());
}
