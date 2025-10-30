import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/rental_history.dart';
import '../model/cars.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiService {
  static const String baseUrlMockup =
      "https://68f38e35fd14a9fcc4291b81.mockapi.io"; //
  static const String baseUrl = "http://10.0.2.2:5000"; //
  static Future<List<RentalHistory>> fetchRentalHistory() async {
    final url = Uri.parse("$baseUrl/share_cars/api/v1/history");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RentalHistory.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi tải dữ liệu lịch sử: ${response.statusCode}");
    }
  }

  static Future<RentalHistory> fetchRentalDetail(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/share_cars/api/v1/history/$id'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RentalHistory.fromJson(json);
    } else {
      throw Exception('Không thể tải chi tiết thuê xe');
    }
  }

  static Future<Map<String, dynamic>> login(
    String phone,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "password": password}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String phone,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<Cars>> getCars() async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse("$baseUrl/api/cars"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        final List<dynamic> carsData =
            (jsonResponse is Map && jsonResponse.containsKey('data'))
            ? jsonResponse['data']
            // ✅ Nếu server trả về mảng trực tiếp
            : (jsonResponse is List ? jsonResponse : []);
        return carsData.map((e) => Cars.fromMap(e)).toList();
      } else {
        throw Exception("Không thể tải danh sách xe");
      }
    } catch (e) {
      return [];
    }
  }

  // =============================
  // 4️⃣ Lấy chi tiết xe theo ID
  // =============================
  static Future<Cars?> getCarById(String id) async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse("$baseUrl/api/cars/$id"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
          return Cars.fromMap(jsonResponse["data"]);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // =============================
  // 5️⃣ Lấy 5 xe mới nhất
  // =============================
  static Future<List<Cars>> getLatestCars() async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse("$baseUrl/api/cars/latest"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        // ✅ Nếu backend trả về { data: [...] }
        final List<dynamic> carsData =
            (jsonResponse is Map && jsonResponse.containsKey('data'))
            ? jsonResponse['data']
            // ✅ Nếu backend trả về mảng trực tiếp
            : (jsonResponse is List ? jsonResponse : []);
        return carsData.map((e) => Cars.fromMap(e)).toList();
      } else {
        throw Exception("Không thể tải danh sách xe mới nhất");
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Cars>> getDiscountedCars() async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse("$baseUrl/api/cars/discounted"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        // ✅ Nếu backend trả về { data: [...] }
        final List<dynamic> carsData =
            (jsonResponse is Map && jsonResponse.containsKey('data'))
            ? jsonResponse['data']
            // ✅ Nếu backend trả về mảng trực tiếp
            : (jsonResponse is List ? jsonResponse : []);
        return carsData.map((e) => Cars.fromMap(e)).toList();
      } else {
        throw Exception("Không thể tải danh sách xe mới nhất");
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Cars>> getFavoriteCars() async {
    final box = Hive.box("login");
    final token = box.get("token");
    final response = await http.get(
      Uri.parse('$baseUrl/api/favorites'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['favorites'] as List)
          .map((item) => Cars.fromMap(item))
          .toList();
    } else {
      throw Exception('Không thể tải danh sách xe yêu thích');
    }
  }

  static Future<void> addFavorite(String carId) async {
    final box = Hive.box("login");
    final token = box.get("token");
    final response = await http.post(
      Uri.parse('$baseUrl/api/favorites/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'carId': carId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể thêm xe vào danh sách yêu thích');
    }
  }
}
