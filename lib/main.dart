import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history.dart';
import 'account.dart';

void main() {
  runApp(const ShareCarApp());
}

class ShareCarApp extends StatelessWidget {
  const ShareCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Car',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF8C00),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

// ====================== MÀN HÌNH ĐĂNG NHẬP ==========================
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg_car.jpg', fit: BoxFit.cover),
          // ignore: deprecated_member_use
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', height: 60),
                    const SizedBox(height: 12),
                    const Text(
                      "WELCOME TO SHARE CAR",
                      style: TextStyle(
                        color: Color(0xFFFF8C00),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        prefixIcon: const Icon(Icons.phone, color: Colors.orange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tính năng đang được phát triển'),
                            ),
                          );
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(120, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          },
                          child: const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orange),
                            minimumSize: const Size(120, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text('Đăng ký', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== MÀN HÌNH ĐĂNG KÝ ==========================
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/images/logo.png', height: 40),
                const SizedBox(width: 8),
                const Text('SHARE CAR'),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg_car.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "ĐĂNG KÝ TÀI KHOẢN",
                      style: TextStyle(
                        color: Color(0xFFFF8C00),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(label: 'Số điện thoại', icon: Icons.phone),
                    const SizedBox(height: 16),
                    _buildTextField(label: 'Tên tài khoản', icon: Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField(label: 'Mật khẩu', icon: Icons.lock, isPassword: true),
                    const SizedBox(height: 16),
                    _buildTextField(label: 'Xác nhận mật khẩu', icon: Icons.lock_outline, isPassword: true),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            minimumSize: const Size(120, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orange),
                            minimumSize: const Size(120, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đăng ký thành công!')),
                            );
                          },
                          child: const Text('Đăng ký', style: TextStyle(color: Colors.orange)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
// Main Page
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final pages = [const HomeScreen(), const HistoryScreen(), const AccountScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFF8C00),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 36,
            ),
            const SizedBox(width: 8),
            const Text(
              "SHARE CAR",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     child: Row(
        //       children: [
        //         Text("Trang chủ", style: TextStyle(color: Colors.white)),
        //         SizedBox(width: 16),
        //         Text("Dịch vụ", style: TextStyle(color: Colors.white)),
        //         SizedBox(width: 16),
        //         Text("Điểm đến", style: TextStyle(color: Colors.white)),
        //         SizedBox(width: 16),
        //         Text("Kết nối", style: TextStyle(color: Colors.white)),
        //         SizedBox(width: 16),
        //         Text("Tài khoản", style: TextStyle(color: Colors.white)),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) => setState(() => pageIndex = value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch Sử',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Tài Khoản',
          ),
        ],
      // ... more configuration
      ),
    );
  }
}
