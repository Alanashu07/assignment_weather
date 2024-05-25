import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/Screens/home_screen.dart';
import 'package:weather_app/Screens/login_screen.dart';
import 'package:weather_app/Services/auth_services.dart';
import 'package:weather_app/Widgets/custom_text_field.dart';
import 'package:weather_app/Widgets/utils.dart';

import '../Styles/app_style.dart';
import '../Widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  final double temperature;

  const SignUpScreen({super.key, required this.temperature});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isSecurePassword = true;
  bool isSecureConfirmPassword = true;

  AuthService authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() async {
    const Center(
      child: CircularProgressIndicator(),
    );
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return;
    }
    if (password != confirmPassword) {
      return;
    }
    User? user = await authService.signUpWithEmail(context, email, password, widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor);
    if (user != null) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.rightToLeftPop,
              childCurrent: SignUpScreen(
                temperature: widget.temperature,
              )));
      Navigator.pop(context);
    }
  }

  googleSignIn() {
    signInWithGoogle().then((user) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.rightToLeftPop,
              childCurrent: SignUpScreen(
                temperature: widget.temperature,
              )));
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Welcome User',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Enter details to create your account',
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        obscureText: false,
                        suffixIcon: Icon(
                          Icons.person_outline,
                          color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor,
                        ),
                        label: 'Name',
                        hint: 'Enter your name',
                        color: widget.temperature >= 30
                            ? AppStyle.mainColor
                            : AppStyle.winterColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        obscureText: false,
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor,
                        ),
                        label: 'E-mail',
                        hint: 'Enter your email',
                        color: widget.temperature >= 30
                            ? AppStyle.mainColor
                            : AppStyle.winterColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        obscureText: isSecurePassword,
                        suffixIcon: togglePassword(),
                        label: 'Password',
                        hint: 'Enter your password',
                        color: widget.temperature >= 30
                            ? AppStyle.mainColor
                            : AppStyle.winterColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        obscureText: isSecureConfirmPassword,
                        suffixIcon: toggleConfirmPassword(),
                        label: 'Confirm Password',
                        hint: 'Confirm your password',
                        color: widget.temperature >= 30
                            ? AppStyle.mainColor
                            : AppStyle.winterColor,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 28,
              ),
              CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_passwordController.text ==
                          _confirmPasswordController.text) {
                        signUp();
                      } else {
                        showSnackBar(context, 'Passwords does not match', widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor);
                      }
                    }
                  },
                  startColor: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor,
                  endColor: widget.temperature >= 30 ? AppStyle.accentColor : AppStyle.winterAccent,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
              const SizedBox(
                height: 24,
              ),
              Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'OR',
                    style: TextStyle(fontSize: 16),
                  )),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: googleSignIn,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue with Google',
                      style: TextStyle(color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'images/google.png',
                      scale: 20,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: LoginScreen(
                                  temperature: widget.temperature,
                                ),
                                type: PageTransitionType.bottomToTopJoined,
                                childCurrent: SignUpScreen(
                                  temperature: widget.temperature,
                                )));
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor),
                      ))
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            isSecurePassword = !isSecurePassword;
          });
        },
        icon: isSecurePassword
            ? Icon(
                CupertinoIcons.eye,
                size: 30,
                color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor,
              )
            : Icon(
                CupertinoIcons.eye_slash,
                size: 30,
                color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor,
              ));
  }

  Widget toggleConfirmPassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            isSecureConfirmPassword = !isSecureConfirmPassword;
          });
        },
        icon: isSecureConfirmPassword
            ? Icon(
                CupertinoIcons.eye,
                size: 30,
                color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor,
              )
            : Icon(
                CupertinoIcons.eye_slash,
                size: 30,
                color: widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor,
              ));
  }
}
