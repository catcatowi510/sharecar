import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history.dart';
import 'account.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");

  @override
  Widget build(BuildContext context) {
    if (_boxLogin.get("loginStatus") ?? false) {
      return HomeScreen();
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
          Container(color: Colors.black.withOpacity(0.5)), // Overlay
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  //padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
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
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 60,
                                ),
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
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: Colors.orange,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onEditingComplete: () =>
                                      _focusNodePassword.requestFocus(),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập số điện thoại.";
                                    } else if (!_boxAccounts.containsKey(
                                      value,
                                    )) {
                                      return "Số điện thoại chưa được đăng ký.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _controllerPassword,
                                  focusNode: _focusNodePassword,
                                  obscureText: _obscurePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Mật khẩu',
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.orange,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: _obscurePassword
                                          ? const Icon(
                                              Icons.visibility_outlined,
                                            )
                                          : const Icon(
                                              Icons.visibility_off_outlined,
                                            ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập mật khẩu.";
                                    } else if (value !=
                                        _boxAccounts.get(
                                          _controllerPhone.text,
                                        )) {
                                      return "Sai mật khẩu.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Tính năng đang được phát triển',
                                          ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        minimumSize: const Size(120, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _boxLogin.put("loginStatus", true);
                                          _boxLogin.put(
                                            "phone",
                                            _controllerPhone.text,
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScreen(),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Đăng nhập',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.orange,
                                        ),
                                        minimumSize: const Size(120, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen(),
                                          ),
                                        );
                                      },
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

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerPhone.dispose();
    _controllerPassword.dispose();
    super.dispose();
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
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();

  final Box _boxAccounts = Hive.box("accounts");
  bool _obscurePassword = true;

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
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)), // Overlay
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  //padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
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
                                const Text(
                                  "ĐĂNG KÝ TÀI KHOẢN",
                                  style: TextStyle(
                                    color: Color(0xFFFF8C00),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _controllerPhone,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: "Số điện thoại",
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: Colors.orange,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập số điện thoại.";
                                    } else if (_boxAccounts.containsKey(
                                      value,
                                    )) {
                                      return "Số điện thoại đã tồn tại.";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      _focusNodeEmail.requestFocus(),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _controllerEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    prefixIcon: const Icon(
                                      Icons.mail,
                                      color: Colors.orange,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập email.";
                                    } else if (!(value.contains('@') &&
                                        value.contains('.'))) {
                                      return "Email không hợp lệ";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      _focusNodePassword.requestFocus(),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _controllerPassword,
                                  obscureText: _obscurePassword,
                                  focusNode: _focusNodePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    labelText: "Mật khẩu",
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.orange,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: _obscurePassword
                                          ? const Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.orange,
                                            )
                                          : const Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.orange,
                                            ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập mật khẩu.";
                                    } else if (value.length < 6) {
                                      return "Mật khẩu không được nhỏ hơn 6 ký tự.";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      _focusNodeConfirmPassword.requestFocus(),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _controllerConFirmPassword,
                                  obscureText: _obscurePassword,
                                  focusNode: _focusNodeConfirmPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    labelText: "Xác nhận mật khẩu",
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.orange,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: _obscurePassword
                                          ? const Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.orange,
                                            )
                                          : const Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.orange,
                                            ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập lại mật khẩu.";
                                    } else if (value !=
                                        _controllerPassword.text) {
                                      return "Mật khẩu không giống nhau.";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        minimumSize: const Size(120, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                        side: const BorderSide(
                                          color: Colors.orange,
                                        ),
                                        minimumSize: const Size(120, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _boxAccounts.put(
                                            _controllerPhone.text,
                                            _controllerConFirmPassword.text,
                                          );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              width: 200,
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: const Text(
                                                "Đăng ký thành công!",
                                              ),
                                            ),
                                          );
                                          _formKey.currentState?.reset();
                                          Navigator.pop(context);
                                        }
                                      },
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

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerPhone.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
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
  final pages = [
    const HomeScreen(),
    const HistoryScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFF8C00),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 36),
            const SizedBox(width: 8),
            const Text(
              "SHARE CAR",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: pages[pageIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) => setState(() => pageIndex = value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch Sử'),
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
