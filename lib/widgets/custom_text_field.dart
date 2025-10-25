import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String? hintText;
  Function(String)? onChanged;
  CustomTextField({super.key, this.hintText, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'this field is required!';
        }
        return null;
      },
      onChanged: onChanged,
      style: TextStyle(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Color(0xffD5E6F2)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 138, 245, 255),
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.orange, // Change validator text color
          fontSize: 14, // Optional: change font size
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ), // error border
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}

class CustomPasswordTextField extends StatefulWidget {
  Function(String)? onChanged;
  CustomPasswordTextField({super.key, this.onChanged});

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscured,
      validator: (value) {
        if (value!.isEmpty) {
          return 'this field is required!';
        }
        return null;
      },
      onChanged: widget.onChanged,
      style: TextStyle(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: (isObscured)
            ? IconButton(
                icon: Icon(Icons.visibility, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : IconButton(
                icon: Icon(Icons.visibility_off, color: Colors.white),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              ),
        hintText: 'Password',
        hintStyle: TextStyle(fontSize: 14, color: Color(0xffD5E6F2)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 138, 245, 255),
          ),
        ),
        errorStyle: TextStyle(
          color: Colors.orange, // Change validator text color
          fontSize: 14, // Optional: change font size
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ), // error border
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
