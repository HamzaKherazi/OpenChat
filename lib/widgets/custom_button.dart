import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';

class CustomButton extends StatelessWidget {
  String? title;
  VoidCallback? onPressed;
  CustomButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        foregroundColor: kPrimaryColor,
        backgroundColor: Colors.white,
        minimumSize: Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(7),
        ),
      ),
      onPressed: onPressed,
      child: Text(title!, style: TextStyle(fontSize: 24)),
    );
  }
}
