import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController =
      TextEditingController(text: "Nguyễn Văn A");
  final TextEditingController emailController =
      TextEditingController(text: "nguyenvana@example.com");
  final TextEditingController phoneController =
      TextEditingController(text: "0901234567");
  final TextEditingController yearController =
      TextEditingController(text: "1995");

  String gender = "Nam";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa tài khoản"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh đại diện
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/avatar_default.png'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        // 🧠 Sau này có thể thêm chức năng chọn ảnh
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Tên
            const Text("Họ và tên"),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: _inputDecoration("Nhập họ và tên"),
            ),
            const SizedBox(height: 16),

            // Email
            const Text("Email"),
            const SizedBox(height: 6),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration("Nhập email"),
            ),
            const SizedBox(height: 16),

            // Số điện thoại
            const Text("Số điện thoại"),
            const SizedBox(height: 6),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration("Nhập số điện thoại"),
            ),
            const SizedBox(height: 16),

            // Năm sinh
            const Text("Năm sinh"),
            const SizedBox(height: 6),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Nhập năm sinh"),
            ),
            const SizedBox(height: 16),

            // Giới tính
            const Text("Giới tính"),
            const SizedBox(height: 6),
            Row(
              children: [
                _genderOption("Nam"),
                _genderOption("Nữ"),
                _genderOption("Khác"),
              ],
            ),

            const SizedBox(height: 30),

            // Nút lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text(
                  "Lưu thay đổi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // 🧠 Gọi API cập nhật thông tin (sau này)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("✅ Cập nhật thông tin thành công"),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Giới tính lựa chọn
  Widget _genderOption(String value) {
    return Expanded(
      child: RadioListTile<String>(
        value: value,
        groupValue: gender,
        activeColor: Colors.orange,
        title: Text(value),
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: (val) {
          setState(() {
            gender = val!;
          });
        },
      ),
    );
  }

  // Input decoration đẹp
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange, width: 2),
      ),
    );
  }
}
