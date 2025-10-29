import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history.dart';
import 'account.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/api_service.dart';

void main() async {
  await _initHive();
  runApp(const ShareCarApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
  await Hive.openBox("cars_rents");
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

      // Thêm cấu hình ngôn ngữ để Flutter có thể tạo MaterialLocalizations
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'), // Tiếng Việt
        Locale('en', 'US'), // Tiếng Anh (fallback)
      ],

      home: const LoginScreen(),
    );
  }
}

// ====================== MÀN HÌNH ĐĂNG NHẬP ==========================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final Box _boxLogin = Hive.box("login");

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final res = await ApiService.login(
        _controllerPhone.text.trim(),
        _controllerPassword.text.trim(),
      );

      if (res['token'] != null) {
        // ✅ Lưu token và thông tin người dùng
        await _boxLogin.put("loginStatus", true);
        await _boxLogin.put("token", res['token']);
        await _boxLogin.put("user", res['user']);

        // Chuyển sang màn hình chính
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        _showError(res['message'] ?? "Đăng nhập thất bại");
      }
    } catch (e) {
      _showError("Lỗi kết nối đến máy chủ");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_boxLogin.get("loginStatus") ?? false) {
      return MainScreen();
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)), // overlay
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
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
                      TextFormField(
                        controller: _controllerPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Số điện thoại',
                          prefixIcon: const Icon(Icons.phone, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Vui lòng nhập số điện thoại." : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controllerPassword,
                        focusNode: _focusNodePassword,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Vui lòng nhập mật khẩu." : null,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Tính năng đang phát triển")),
                            );
                          },
                          child: const Text('Quên mật khẩu?', style: TextStyle(color: Colors.orange)),
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
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
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
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
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
          ),
        ],
      ),
    );
  }
}
// ====================== MÀN HÌNH ĐĂNG KÝ ==========================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 8),
            const Text('SHARE CAR'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)), // overlay
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      // Họ tên
                      TextFormField(
                        controller: _controllerName,
                        decoration: InputDecoration(
                          labelText: "Họ và tên",
                          prefixIcon: const Icon(Icons.person, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập họ tên.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Số điện thoại
                      TextFormField(
                        controller: _controllerPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Số điện thoại",
                          prefixIcon: const Icon(Icons.phone, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập số điện thoại.";
                          }
                          return null;
                        },
                        onEditingComplete: () => _focusNodeEmail.requestFocus(),
                      ),
                      const SizedBox(height: 16),
                      // Email
                      TextFormField(
                        controller: _controllerEmail,
                        focusNode: _focusNodeEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.mail, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập email.";
                          } else if (!(value.contains('@') && value.contains('.'))) {
                            return "Email không hợp lệ.";
                          }
                          return null;
                        },
                        onEditingComplete: () => _focusNodePassword.requestFocus(),
                      ),
                      const SizedBox(height: 16),
                      // Mật khẩu
                      TextFormField(
                        controller: _controllerPassword,
                        focusNode: _focusNodePassword,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Mật khẩu",
                          prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập mật khẩu.";
                          } else if (value.length < 6) {
                            return "Mật khẩu phải có ít nhất 6 ký tự.";
                          }
                          return null;
                        },
                        onEditingComplete: () =>
                            _focusNodeConfirmPassword.requestFocus(),
                      ),
                      const SizedBox(height: 16),
                      // Xác nhận mật khẩu
                      TextFormField(
                        controller: _controllerConfirmPassword,
                        focusNode: _focusNodeConfirmPassword,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Xác nhận mật khẩu",
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value != _controllerPassword.text) {
                            return "Mật khẩu không trùng khớp.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      _loading
                          ? const CircularProgressIndicator(color: Colors.orange)
                          : Row(
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
                                  child: const Text(
                                    'Đăng nhập',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.orange),
                                    minimumSize: const Size(120, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _register,
                                  child: const Text(
                                    'Đăng ký',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _loading = true);

  final result = await ApiService.register(
    _controllerName.text,
    _controllerPhone.text,
    _controllerEmail.text,
    _controllerPassword.text,
  );

  setState(() => _loading = false);

  if (result["success"] == true) {
    // Hiển thị thông báo đăng ký thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đăng ký thành công! Vui lòng đăng nhập."),
        backgroundColor: Colors.green,
      ),
    );

    // Chờ 1 giây để người dùng đọc thông báo rồi chuyển sang màn hình đăng nhập
    await Future.delayed(const Duration(seconds: 1));

    // Chuyển màn hình
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  } else {
    // Nếu thất bại, hiện lỗi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result["message"] ?? "Đăng ký thất bại."),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerName.dispose();
    _controllerPhone.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }
}

// Main Page
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final pages = const [HomeScreen(), HistoryScreen(), AccountScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFF8C00),
        centerTitle: true, // 👉 căn giữa tiêu đề
        title: Image.asset('assets/images/logo.png', height: 40),
      ),
      body: SafeArea(
        // Giữ trạng thái của từng trang
        child: IndexedStack(index: pageIndex, children: pages),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) => setState(() => pageIndex = value),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch Sử'),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Tài Khoản',
          ),
        ],
      ),
    );
  }
}
