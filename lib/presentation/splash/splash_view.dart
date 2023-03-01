import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/presentation/main/main_view.dart';
import 'package:todo_app/presentation/resources/app_constants.dart';
import 'package:todo_app/presentation/resources/assets_manager.dart';
import 'package:todo_app/presentation/resources/color_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  startDelay() {
    _timer = Timer(
      const Duration(seconds: AppConstants.splashDelay),
      () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const MainView()));
      },
    );
  }

  @override
  void initState() {
    startDelay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: ColorManager.primary,
      child: Center(
        child: Lottie.asset(JsonAssets.splash),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
