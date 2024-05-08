import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/home.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: mainYellow
      ),
      home: const home(),
    );
  }
}
