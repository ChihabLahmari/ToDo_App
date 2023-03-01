import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_app/presentation/resources/app_size.dart';
import 'package:todo_app/presentation/resources/app_strings.dart';
import 'package:todo_app/presentation/resources/assets_manager.dart';
import 'package:todo_app/presentation/resources/color_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<String> todoList = [
    'hello i am chihab',
    'hello i am chihab',
    'hello i am chihab',
    'hello i am chihab',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorManager.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          size: AppSize.s30,
          color: ColorManager.dark,
        ),
        actions: [
          CircleAvatar(
            backgroundColor: ColorManager.purple,
            backgroundImage: const AssetImage(ImageAssets.chihab),
          ),
          const SizedBox(
            width: AppSize.s14,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSize.s10, horizontal: AppSize.s14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kBottomNavigationBarHeight + kBottomNavigationBarHeight,
              ),
              Text(
                AppStrings.allTodos,
                style: TextStyle(
                  fontSize: AppSize.s30,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.dark,
                ),
              ),
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: todoList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: AppSize.s20);
                },
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: AppSize.s50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s10),
                      color: ColorManager.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppSize.s10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_box_outline_blank,
                            color: ColorManager.purple,
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
