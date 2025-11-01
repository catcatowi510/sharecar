import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String appName = "Share Car";
  String version = "";
  String buildNumber = "";

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giới thiệu ứng dụng"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔸 Logo
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    appName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Phiên bản $version (Build $buildNumber)",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 🔹 Giới thiệu
            const Text(
              "Giới thiệu",
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ứng dụng Share Car giúp người dùng dễ dàng thuê và chia sẻ xe hơi nhanh chóng, an toàn và tiện lợi. "
              "Bạn có thể tìm kiếm xe phù hợp, đặt xe trong vài phút và theo dõi trạng thái thuê ngay trên điện thoại.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 24),

            // 🔹 Tính năng nổi bật
            const Text(
              "Tính năng nổi bật",
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: const [
                _FeatureItem(
                  icon: Icons.directions_car,
                  title: "Đặt xe dễ dàng",
                  desc: "Chọn xe bạn muốn và đặt nhanh chỉ trong vài bước.",
                ),
                _FeatureItem(
                  icon: Icons.security,
                  title: "An toàn & tin cậy",
                  desc: "Mọi giao dịch đều được bảo mật và xác minh người dùng.",
                ),
                _FeatureItem(
                  icon: Icons.attach_money,
                  title: "Giá cả minh bạch",
                  desc: "Chi phí thuê xe hiển thị rõ ràng, không phụ phí ẩn.",
                ),
                _FeatureItem(
                  icon: Icons.support_agent,
                  title: "Hỗ trợ 24/7",
                  desc: "Đội ngũ hỗ trợ sẵn sàng giúp bạn mọi lúc, mọi nơi.",
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔹 Liên hệ
            const Text(
              "Liên hệ & hỗ trợ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Email: support@sharecar.vn\nHotline: 1900 8888 68\nWebsite: www.sharecar.vn",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 30),

            // 🔹 Bản quyền
            const Text(
              "© 2025 Share Car. Tất cả các quyền được bảo lưu.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔸 Widget hiển thị tính năng
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(desc),
    );
  }
}
