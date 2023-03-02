import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_app/presentation/resources/app_size.dart';
import 'package:todo_app/presentation/resources/app_strings.dart';
import 'package:todo_app/presentation/resources/assets_manager.dart';
import 'package:todo_app/presentation/resources/color_manager.dart';
import 'package:todo_app/presentation/resources/font_manager.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final TextEditingController _toDoTextEditingController = TextEditingController();
  List<String> todoList = [
    'hello i am chihab hello i am chihab',
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
        padding: const EdgeInsets.symmetric(vertical: AppSize.s10, horizontal: AppSize.s14),
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(vertical: AppSize.s20),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: todoList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: AppSize.s20);
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s20),
                          color: ColorManager.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.s14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_box_outline_blank,
                                color: ColorManager.purple,
                              ),
                              const SizedBox(width: AppSize.s30),
                              Expanded(
                                child: Text(
                                  todoList[index],
                                  style: TextStyle(
                                    color: ColorManager.grey,
                                    fontSize: FontSize.s18,
                                    fontWeight: FontWeightManager.medium,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSize.s30),
                              Container(
                                height: AppSize.s35,
                                width: AppSize.s35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.s8),
                                  color: ColorManager.red,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.delete,
                                    color: ColorManager.white,
                                    size: AppSize.s20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSize.s15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: AppSize.s60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSize.s14),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          // padding: const EdgeInsets.all(AppSize.s10),
                          padding: const EdgeInsets.only(left: AppSize.s10, right: AppSize.s10),
                          child: Center(
                            child: TextFormField(
                              controller: _toDoTextEditingController,
                              decoration: InputDecoration(
                                label: const Text(AppStrings.addNewToDo),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                  left: AppSize.s5,
                                  right: AppSize.s5,
                                  bottom: AppSize.s20,
                                ),
                                labelStyle: TextStyle(
                                  color: ColorManager.grey,
                                  fontSize: FontSize.s18,
                                  fontWeight: FontWeightManager.medium,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSize.s15),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s25),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        maxRadius: AppSize.s25,
                        backgroundColor: ColorManager.purple,
                        child: Icon(
                          Icons.add,
                          size: AppSize.s35,
                          color: ColorManager.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
