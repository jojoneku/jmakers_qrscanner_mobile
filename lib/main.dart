import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jmaker_qrscanner_mobile/firebase_options.dart';
import 'package:jmaker_qrscanner_mobile/routes/app_router.dart';
import 'package:jmaker_qrscanner_mobile/styles/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MaterialApp.router(
      theme: ThemeData(primaryColor: mainYellow),
      routerConfig: appRouter.config(),
    );
  }
}
