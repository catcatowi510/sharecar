import 'package:flutter/material.dart';

class FavoriteCarsScreen extends StatelessWidget {
  const FavoriteCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách xe yêu thích mẫu (sau có thể gọi API)
    final List<Map<String, String>> favoriteCars = [
      {
        "name": "Toyota Vios",
        "image": "https://cdn.honda.com.vn/microsite-crv-2023/images/CRV_Grey.png",
        "price": "750.000 đ/ngày"
      },
      {
        "name": "Mazda CX-5",
        "image": "https://cdn.tgdd.vn/Files/2023/06/12/1529547/mazda-cx-5-2023-ra-mat-2.jpg",
        "price": "1.200.000 đ/ngày"
      },
      {
        "name": "VinFast Lux A2.0",
        "image": "https://storage.googleapis.com/vinfast-data-01/vinfast-lux-a20-1.png",
        "price": "1.000.000 đ/ngày"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Xe yêu thích"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: favoriteCars.isEmpty
          ? const Center(
              child: Text(
                "Bạn chưa có xe yêu thích nào.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteCars.length,
              itemBuilder: (context, index) {
                final car = favoriteCars[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        car["image"]!,
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/bg_car.jpg',
                                width: 80, height: 60, fit: BoxFit.cover),
                      ),
                    ),
                    title: Text(
                      car["name"]!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      car["price"]!,
                      style: const TextStyle(color: Colors.orange),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("❌ Đã xóa ${car["name"]} khỏi danh sách yêu thích"),
                          ),
                        );
                      },
                    ),
                    // onTap: () {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content:
                    //           Text("🚗 Mở chi tiết xe: ${car["name"]}"),
                    //     ),
                    //   );
                    // },
                  ),
                );
              },
            ),
    );
  }
}
