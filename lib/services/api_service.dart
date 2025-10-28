import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/rental_history.dart';

class ApiService {
  static const String baseUrl =
      "https://68f38e35fd14a9fcc4291b81.mockapi.io"; // 🔧 Thay URL thật của bạn

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
    final response = await http.get(Uri.parse('$baseUrl/share_cars/api/v1/history/$id'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return RentalHistory.fromJson(json);
    } else {
      throw Exception('Không thể tải chi tiết thuê xe');
    }
  }
}
