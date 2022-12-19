import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_smart_home/view/auth/signUp.dart';
import 'package:my_smart_home/view/auth/resetPassword.dart';
import '../home.dart';

Future<void> main() async {
  runApp(const SignIn());
}

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignIn createState() => _SignIn();
}

final navigatorKey = GlobalKey<NavigatorState>();
String? _errMsg = '';

class _SignIn extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size currentScreen = MediaQuery.of(context).size;
    navigatorKey;
    return Form(
        key: _formKey,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Column(children: [
              Expanded(
                  child: Stack(children: [
                Container(
                  height: currentScreen.height * 0.33,
                  width: currentScreen.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/domotica-e-iot.jpg'),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: currentScreen.height * 0.655,
                    width: currentScreen.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28)),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Hi, Welcome Back on E-Home",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Monitor your house from my mobile device",
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            decoration: const InputDecoration(
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    Icons.email,
                                  ), // icon is 48px widget.
                                ),
                                border: OutlineInputBorder(),
                                constraints:
                                    BoxConstraints.tightFor(width: 320),
                                labelText: 'Enter Your Email',
                                isDense: true,
                                hintText: 'sonwaroberto@gmail.com'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == '') {
                                setState(() {
                                  _errMsg = 'require';
                                });
                                return _errMsg;
                              }
                              return null;
                            }),
                        const SizedBox(height: 16),
                        TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            decoration: const InputDecoration(
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                    Icons.password,
                                  ), // icon is 48px widget.
                                ),
                                border: OutlineInputBorder(),
                                constraints:
                                    BoxConstraints.tightFor(width: 320),
                                labelText: 'Enter Your Password',
                                isDense: true,
                                hintText: 'Enter secure password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  _errMsg = 'require';
                                });
                                return _errMsg;
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4)),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signIn();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text('Login',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.login,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                text: 'Forgot ',
                                children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const ResetPassword()));
                                    },
                                  text: 'Password',
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold))
                            ])),
                        const SizedBox(height: 16),
                        RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                text: 'No account? ',
                                children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const SignUp()));
                                    },
                                  text: 'Register Now',
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold))
                            ])),
                      ],
                    ),
                  ),
                ),
              ]))
            ]))));
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((result) => {
              Navigator.of(context).pop(),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              )
            })
        .catchError((err) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Authentification Error",
                  style: TextStyle(color: Colors.blue)),
              content: Text(
                err.message,
                style: const TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
}
