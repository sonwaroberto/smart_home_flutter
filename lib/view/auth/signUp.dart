import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_smart_home/view/home.dart';
import 'package:my_smart_home/view/auth/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  runApp(const SignUp());
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUp createState() => _SignUp();
}

final navigatorKey = GlobalKey<NavigatorState>();
String? _errMsg = '';

class _SignUp extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    navigatorKey;
    Size currentScreen = MediaQuery.of(context).size;
    return Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Column(children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: currentScreen.height * 0.33,
                    width: currentScreen.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/domotica-e-iot.jpg'),
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
                                  "Hello, Welcome On E-Home",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  "Create an Account To Get Started",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                TextFormField(
                                    controller: usernameController,
                                    textInputAction: TextInputAction.next,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        prefixIcon: Align(
                                          widthFactor: 1.0,
                                          heightFactor: 1.0,
                                          child: Icon(
                                            Icons.person,
                                          ), // icon is 48px widget.
                                        ),
                                        border: OutlineInputBorder(),
                                        constraints:
                                            BoxConstraints.tightFor(width: 320),
                                        labelText: 'Enter Your Username',
                                        isDense: true,
                                        hintText: 'sonwa boris'),
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
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
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
                                  width: 250,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        signUp();
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const <Widget>[
                                        Text('Create Account',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25)),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        text: 'Have an account? ',
                                        children: [
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const SignIn()));
                                            },
                                          text: 'Sign In now',
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold))
                                    ])),
                              ]))),
                ],
              ),
            ),
          ])),
        ));
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((result) {
      FirebaseFirestore.instance.collection('users').doc(result.user?.uid).set({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "username": usernameController.text.trim(),
        "date": DateTime.now()
      }).then((res) {
        Navigator.of(context).pop();
        const snackBar = SnackBar(
          content: Text(
            'Password Reset Mail send successfully',
            style: TextStyle(color: Colors.green),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }).catchError((err) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Create Account Error",
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
    }).catchError((err) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Create Account error",
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
