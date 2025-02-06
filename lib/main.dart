import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/auth/Login_Page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lencho/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lencho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(), // Or your initial route.
    );
  }
}
