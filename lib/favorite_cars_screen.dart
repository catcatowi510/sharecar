import 'package:flutter/material.dart';
import '../model/cars.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class FavoriteCarsScreen extends StatefulWidget {
  const FavoriteCarsScreen({super.key});

  @override
  State<FavoriteCarsScreen> createState() => _FavoriteCarsScreenState();
}

class _FavoriteCarsScreenState extends State<FavoriteCarsScreen> {
  late Future<List<Cars>> futureFavorites;
  final NumberFormat formatCurrency = NumberFormat("#,##0", "vi_VN");

  @override
  void initState() {
    super.initState();
    futureFavorites = ApiService.getFavoriteCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xe yêu thích"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: FutureBuilder<List<Cars>>(
        future: futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Lỗi: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Bạn chưa có xe yêu thích nào.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final cars = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      car.imageUrl,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/bg_car.jpg',
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${formatCurrency.format(car.pricePerDay)} VNĐ/ngày",
                    style: const TextStyle(color: Colors.orange),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final success = await ApiService.toggleFavorite(car);
                      if (success) {
                        setState(() {
                          futureFavorites = ApiService.getFavoriteCars();
                        });
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
