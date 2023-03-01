import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/splash/splash_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
