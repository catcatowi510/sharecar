import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/rental_history.dart';
import '../model/cars.dart';
import '../model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiService {
  //static const String baseUrlMockup = "https://68f38e35fd14a9fcc4291b81.mockapi.io"; //
  //static const String baseUrl = "http://10.0.2.2:5000"; //
  static const String baseUrl =
      "https://psychologically-nonpatterned-leonila.ngrok-free.dev"; //

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

  static Future<List<Cars>> getCars(queryParams) async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      // Dùng Uri để build URL an toàn
      final uri = Uri.parse(
        "$baseUrl/api/cars",
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);
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

  static Future<bool> toggleFavorite(Cars car) async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final url = Uri.parse("$baseUrl/api/favorites/${car.id}");

      http.Response response;
      if (car.isFavorite) {
        // ❌ Bỏ yêu thích
        response = await http.delete(url, headers: headers);
      } else {
        // ❤️ Thêm yêu thích
        response = await http.post(url, headers: headers);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Lỗi toggleFavorite: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi toggleFavorite: $e");
      return false;
    }
  }

  static Future<List<RentalHistory>> fetchRentalHistory() async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final url = Uri.parse("$baseUrl/api/rental");
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // ✅ Kiểm tra nếu có trường "data"
        if (responseData["data"] != null) {
          final List<dynamic> data = responseData["data"];
          return data.map((e) => RentalHistory.fromJson(e)).toList();
        } else {
          throw Exception("Không có trường 'data' trong phản hồi API");
        }
      } else {
        throw Exception("Lỗi tải dữ liệu lịch sử: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  static Future<RentalHistory> fetchRentalDetail(String id) async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };
      final response = await http.get(
        Uri.parse('$baseUrl/api/rental/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final dynamic json = jsonDecode(response.body);
        return RentalHistory.fromJson(json["data"]);
      } else {
        throw Exception('Không thể tải chi tiết thuê xe');
      }
    } catch (e) {
      throw Exception('Không thể tải chi tiết thuê xe');
    }
  }

  static Future<Map<String, dynamic>> createpaymentVNPay(body) async {
    final box = Hive.box("login");
    final token = box.get("token");
    final response = await http.post(
      Uri.parse('$baseUrl/api/rental/payment/vnpay'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    return jsonDecode(response.body);
  }

  static Future<bool> cancelRental(id) async {
    final box = Hive.box("login");
    final token = box.get("token");
    final response = await http.post(
      Uri.parse('$baseUrl/api/rental/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({"id": id, "status": "Đã hủy"}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("Lỗi toggleFavorite: ${response.body}");
      return false;
    }
  }
  static Future<User?> getProfile() async {
    try {
      final box = Hive.box("login");
      final token = box.get("token");

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse("$baseUrl/api/user/profile"),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse["data"]);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  static Future<bool> updateProfile(body) async {
    final box = Hive.box("login");
    final token = box.get("token");
    final response = await http.put(
      Uri.parse('$baseUrl/api/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
  static Future<bool> changePass(body) async {
    final box = Hive.box("login");
    final token = box.get("token");
    final response = await http.put(
      Uri.parse('$baseUrl/api/user/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
