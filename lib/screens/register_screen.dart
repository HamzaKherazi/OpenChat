import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/global.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/screens/home_screen.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;
  String? password;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(color: Colors.lightBlue),
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 70),
                Image.asset(kLogo, height: 80),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'OpenChat',
                    style: TextStyle(
                      fontFamily: 'JosefinSans',
                      fontSize: 32,

                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 90),

                Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Email',
                  onChanged: (data) {
                    email = data;
                  },
                ),
                SizedBox(height: 10),

                CustomPasswordTextField(
                  onChanged: (data) {
                    password = data;
                  },
                ),
                SizedBox(height: 30),

                CustomButton(
                  title: 'Register',
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await registerUser();
                      showSnackBar(
                        context,
                        message: 'Account is registered successfully!',
                        color: Colors.teal,
                      );

                      addUser();
                      Global.email = email;

                      Navigator.pushNamed(context, HomeScreen.id);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        showSnackBar(
                          context,
                          message: 'The account already exists for that email.',
                          color: Colors.redAccent,
                        );
                      } else if (e.code == 'weak-password') {
                        showSnackBar(
                          context,
                          message: 'The password provided is too weak.',
                          color: Colors.orangeAccent,
                        );
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 5, 251, 255),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }

  Future<void> addUser() async {
    await FirebaseFirestore.instance.collection('users').add({'email': email});
  }
}
