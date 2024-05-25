import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/Screens/signup_screen.dart';
import 'package:weather_app/Services/auth_services.dart';
import 'package:weather_app/Styles/app_style.dart';
import 'package:weather_app/Widgets/custom_button.dart';
import 'package:weather_app/Widgets/custom_text_field.dart';
import 'package:weather_app/Widgets/utils.dart';
import '../main.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final double temperature;

  const LoginScreen({super.key, required this.temperature});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSecurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  bool isSigning = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    setState(() {
      isSigning = true;
    });
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      return;
    }
    User? user = await authService.signInpWithEmail(context, email, password, widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor);
    if (user != null) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.rightToLeftPop,
              childCurrent: LoginScreen(
                temperature: widget.temperature,
              )));
      setState(() {
        isSigning = false;
      });
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

  forgotPassword() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      showSnackBar(context, 'Enter a valid email',
          widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor);
    }
    try {
      _auth.sendPasswordResetEmail(email: _emailController.text);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.code,
          widget.temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: mq.height * .35,
                    width: mq.width,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(widget.temperature >= 30
                                ? 'images/sunny.jpg'
                                : 'images/thunder.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft)),
                    child: Container(
                        width: mq.width,
                        height: mq.height,
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Know the weather with us',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Enter details to get your account back',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          obscureText: false,
                          suffixIcon: Icon(
                            Icons.email_outlined,
                            color: widget.temperature >= 30
                                ? AppStyle.mainColor
                                : AppStyle.winterColor,
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
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: mq.width,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: forgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: widget.temperature >= 30
                              ? AppStyle.mainColor
                              : AppStyle.winterColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signIn();
                    }
                  },
                  startColor: widget.temperature >= 30
                      ? AppStyle.mainColor
                      : AppStyle.winterColor,
                  endColor: widget.temperature >= 30
                      ? AppStyle.accentColor
                      : AppStyle.winterAccent,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
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
                        style: TextStyle(
                            color: widget.temperature >= 30
                                ? AppStyle.mainColor
                                : AppStyle.winterColor),
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
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: SignUpScreen(
                                    temperature: widget.temperature,
                                  ),
                                  type: PageTransitionType.topToBottomJoined,
                                  childCurrent: LoginScreen(
                                    temperature: widget.temperature,
                                  )));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: widget.temperature >= 30
                                  ? AppStyle.mainColor
                                  : AppStyle.winterColor),
                        ))
                  ],
                ),
                SizedBox(
                  height: mq.height * .05,
                )
              ],
            ),
          ),
        ),
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
                color: widget.temperature >= 30
                    ? AppStyle.mainColor
                    : AppStyle.winterColor,
              )
            : Icon(
                CupertinoIcons.eye_slash,
                size: 30,
                color: widget.temperature >= 30
                    ? AppStyle.mainColor
                    : AppStyle.winterColor,
              ));
  }
}
