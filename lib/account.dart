import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Page Account",
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
