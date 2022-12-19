import 'package:flutter/material.dart';
import 'package:my_smart_home/view/auth/AuthGate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_smart_home/utils/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppHome());
}
class AppHome extends StatelessWidget {
  const AppHome({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
