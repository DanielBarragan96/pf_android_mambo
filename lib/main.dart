import 'package:entregable_2/colors.dart';
import 'package:entregable_2/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Proyecto final",
      theme: ThemeData(
        primaryColor: kMainPurple,
        accentColor: kLightPurple,
      ),
      home: LoginPage(),
    );
  }
}
