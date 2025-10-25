import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  String? title;
  CustomLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Text(
        title!,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}
