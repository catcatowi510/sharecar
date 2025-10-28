import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'favorite_cars_screen.dart';
import 'main.dart';
import 'about_app_screen.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Box boxLogin = Hive.box("login");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản của tôi'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔸 Header tài khoản (mới)
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Nền gradient
              Container(
                height: 110,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Card thông tin người dùng nổi
              Positioned(
                bottom: -40,
                left: 20,
                right: 20,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage(
                            'assets/images/avatar_default.png',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Nguyễn Văn A",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "nguyenvana@example.com",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          }, // sau có thể mở trang sửa hồ sơ
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60), // để tránh card che nội dung
          // 🔸 Danh sách tùy chọn
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuItem(
                  icon: Icons.favorite_outline,
                  title: "Xe yêu thích",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteCarsScreen(),
                      ),
                    );
                  },
                ),
                // _buildMenuItem(
                //   icon: Icons.location_on_outlined,
                //   title: "Địa chỉ của tôi",
                //   onTap: () {
                //     _showAddressDialog(context);
                //   },
                // ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: "Đổi mật khẩu",
                  onTap: () {
                    _showChangePasswordDialog(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: "Trung tâm hỗ trợ",
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: "Giới thiệu ứng dụng",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutAppScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: "Đăng xuất",
                  color: Colors.red,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Xác nhận"),
                        content: const Text(
                          "Bạn có chắc muốn đăng xuất không?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Hủy"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Đăng xuất"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // 🧹 Xóa trạng thái đăng nhập
                      await boxLogin.put("loginStatus", false);
                      await boxLogin.delete("phone");

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Đăng xuất thành công")),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // 🔐 Hộp thoại đổi mật khẩu
  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController oldPass = TextEditingController();
    final TextEditingController newPass = TextEditingController();
    final TextEditingController confirmPass = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đổi mật khẩu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu hiện tại",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nhập lại mật khẩu mới",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              if (newPass.text != confirmPass.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("❌ Mật khẩu nhập lại không khớp"),
                  ),
                );
              } else if (newPass.text.isEmpty || oldPass.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("⚠️ Vui lòng nhập đầy đủ thông tin"),
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Đổi mật khẩu thành công")),
                );
              }
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }

  // 🏠 Hộp thoại quản lý địa chỉ
  // void _showAddressDialog(BuildContext context) {
  //   final TextEditingController addressController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Địa chỉ của tôi"),
  //       content: TextField(
  //         controller: addressController,
  //         decoration: const InputDecoration(
  //           labelText: "Nhập địa chỉ nhận xe",
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Hủy"),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
  //           onPressed: () {
  //             Navigator.pop(context);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text("✅ Đã lưu địa chỉ: ${addressController.text}"),
  //               ),
  //             );
  //           },
  //           child: const Text("Lưu"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
