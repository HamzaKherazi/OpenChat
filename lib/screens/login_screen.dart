import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/global.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/screens/home_screen.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                  'Login',
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
                  title: 'Login',
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await loginUser();
                      showSnackBar(
                        context,
                        message: 'Login successfully',
                        color: Colors.teal,
                      );
                      Global.email = email;

                      Navigator.pushNamed(context, HomeScreen.id);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showSnackBar(
                          context,
                          message: 'No user found for that email',
                          color: Colors.redAccent,
                        );
                      } else if (e.code == 'wrong-password') {
                        showSnackBar(
                          context,
                          message: 'Wrong password provided for that user',
                          color: Colors.redAccent,
                        );
                      } else if (e.code == 'invalid-email') {
                        showSnackBar(
                          context,
                          message: 'Invalid email',
                          color: Colors.redAccent,
                        );
                      } else {
                        showSnackBar(
                          context,
                          message: e.message.toString(),
                          color: Colors.redAccent,
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
                      "don't have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'RegisterScreen');
                      },
                      child: Text(
                        'Register',
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

  Future<void> loginUser() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
