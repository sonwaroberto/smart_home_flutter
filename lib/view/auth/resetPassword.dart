import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_smart_home/view/auth/signIn.dart';
import 'package:my_smart_home/view/auth/signUp.dart';

Future<void> main() async {
  runApp(const ResetPassword());
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPassword createState() => _ResetPassword();
}

final navigatorKey = GlobalKey<NavigatorState>();
String? _errMsg = '';

class _ResetPassword extends State<ResetPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
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
                          "Enter Your Email Address To Reset \n Your Password",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            decoration: const InputDecoration(
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
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4)),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                resetPassword();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text('Reset Password',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.lock_reset,
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
                                text: 'Have an account? ',
                                children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const SignIn()));
                                    },
                                  text: 'Sign In now',
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

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      const snackBar = SnackBar(
        content: Text(
          'Password Reset Mail send successfully',
          style: TextStyle(color: Colors.green),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SignIn()));
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Reset Password Error",
                style: TextStyle(color: Colors.blue),
              ),
              content: Text(
                e.message.toString(),
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
    }
  }
}
