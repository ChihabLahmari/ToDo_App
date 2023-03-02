import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/presentation/resources/app_constants.dart';
import 'package:todo_app/presentation/resources/app_size.dart';
import 'package:todo_app/presentation/resources/app_strings.dart';
import 'package:todo_app/presentation/resources/assets_manager.dart';
import 'package:todo_app/presentation/resources/color_manager.dart';
import 'package:todo_app/presentation/resources/font_manager.dart';

import '../main/view/main_view.dart';

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
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainView()));
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
      child: Padding(
        padding: const EdgeInsets.all(AppSize.s14),
        child: Stack(
          children: [
            Center(
              child: Lottie.asset(JsonAssets.splash),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeightManager.large,
                  color: ColorManager.purple,
                ),
                child: const Text(
                  AppStrings.madeWithLove,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
