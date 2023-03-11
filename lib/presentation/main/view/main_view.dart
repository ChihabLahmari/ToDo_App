import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo_app/app/app_prefs.dart';
import 'package:todo_app/domain/model/todo.dart';
import 'package:todo_app/presentation/main/bloc/cubit.dart';
import 'package:todo_app/presentation/main/bloc/states.dart';
import 'package:todo_app/presentation/resources/app_size.dart';
import 'package:todo_app/presentation/resources/app_strings.dart';
import 'package:todo_app/presentation/resources/assets_manager.dart';
import 'package:todo_app/presentation/resources/color_manager.dart';
import 'package:todo_app/presentation/resources/font_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/edit_task_dialog.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final TextEditingController _taskTextEditingController = TextEditingController();
  final TextEditingController _searchEditingController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MainCubit(),
      child: BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MainCubit.get(context);
          cubit.getDataFromLocal();
          List todoList;
          if (_searchEditingController.text.isEmpty) {
            todoList = cubit.db.toDoList;
          } else {
            todoList = cubit.filteredList;
          }
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
              iconTheme: IconThemeData(color: ColorManager.dark, size: AppSize.s30),
              leading: CircleAvatar(
                backgroundColor: ColorManager.primary,
                child: SizedBox(
                  height: AppSize.s30,
                  width: AppSize.s30,
                  child: Image.asset(
                    ImageAssets.todo1,
                  ),
                ),
              ),
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.track_changes),
              //   ),
              //   Builder(builder: (context) {
              //     return IconButton(
              //         icon: Icon(Icons.menu),
              //         onPressed: () {
              //           Scaffold.of(context).openEndDrawer();
              //         });
              //   }),
              // ],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => removeTasksDialog(context, cubit),
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      // color: ColorManager.purple,
                      size: AppSize.s30,
                    ),
                  )
                ],
              ),
              titleSpacing: 0,
            ),
            endDrawer: Drawer(
              backgroundColor: ColorManager.primary,
              child: ListView(
                // padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Text(
                        AppStrings.devContact,
                        style: TextStyle(
                          fontSize: AppSize.s17,
                          color: ColorManager.dark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.instagram),
                    title: const Text(AppStrings.instagramAccounte),
                    subtitle: const Text(AppStrings.tapToOpen),
                    onTap: () {
                      goToUrl(AppStrings.instaLink);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.github),
                    title: const Text(AppStrings.githubAccounte),
                    subtitle: const Text(AppStrings.tapToOpen),
                    onTap: () {
                      goToUrl(AppStrings.gitHubLink);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.linkedinIn),
                    title: const Text(AppStrings.linkdInAccounte),
                    subtitle: const Text(AppStrings.tapToOpen),
                    onTap: () {
                      goToUrl(AppStrings.linkedinLink);
                    },
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text(AppStrings.appVersion),
                    subtitle: Text(AppStrings.appVersionNum),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSize.s10, horizontal: AppSize.s14),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: kBottomNavigationBarHeight + kBottomNavigationBarHeight,
                      ),
                      Container(
                        width: double.infinity,
                        height: AppSize.s50,
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(AppSize.s20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.s10),
                          child: seachTextField(cubit),
                        ),
                      ),
                      const SizedBox(height: AppSize.s20),
                      Expanded(
                        child: todoList.isNotEmpty
                            ? allTasks(todoList, cubit)
                            : Center(child: Lottie.asset(JsonAssets.empty)),
                      ),
                      if (_searchEditingController.text.isEmpty) addNewTaskBar(cubit, context),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget seachTextField(MainCubit cubit) {
    return TextFormField(
      controller: _searchEditingController,
      onChanged: (value) {
        cubit.searchTask(_searchEditingController.text);
      },
      decoration: InputDecoration(
        label: const Text(AppStrings.search),
        prefixIcon: Icon(Icons.search, color: ColorManager.purple),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          top: AppSize.s5,
          left: AppSize.s5,
          right: AppSize.s5,
          bottom: AppSize.s10,
        ),
        labelStyle: TextStyle(
          color: ColorManager.grey,
          fontSize: FontSize.s18,
          fontWeight: FontWeightManager.medium,
        ),
      ),
    );
  }

  Widget allTasks(List<dynamic> todoList, MainCubit cubit) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(
          //   height: kBottomNavigationBarHeight + kBottomNavigationBarHeight,
          // ),
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
              return taskItem(todoList.reversed.toList(), index, cubit, _controller);
            },
          )
        ],
      ),
    );
  }

  Widget taskItem(
    List todoList,
    int index,
    MainCubit cubit,
    TextEditingController controller,
  ) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // _searchEditingController.text == '' ?
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) {
                  return EditTaskDialogBox(
                    key,
                    controller,
                    cubit,
                    todoList[index].task,
                    todoList[index].id,
                  );
                },
              );
            },
            icon: Icons.edit,
            backgroundColor: ColorManager.purple,
            borderRadius: BorderRadius.circular(20),
          ),
          // : SizedBox(),
          SlidableAction(
            onPressed: (context) {
              cubit.removeTask(todoList[index].id, _searchEditingController.text);
            },
            icon: Icons.delete,
            backgroundColor: ColorManager.red,
            borderRadius: BorderRadius.circular(AppSize.s20),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s20),
          color: ColorManager.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSize.s14),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  cubit.doneTask(todoList[index].id);
                },
                child: Icon(
                  todoList[index].isDone ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                  color: ColorManager.purple,
                ),
              ),
              const SizedBox(width: AppSize.s30),
              Expanded(
                child: Text(
                  todoList[index].task,
                  style: TextStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s18,
                    fontWeight: FontWeightManager.medium,
                    decoration: todoList[index].isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSize.s20),
              // if (todoList[index].image != null)
              todoList[index].image != null
                  ?

                  // Container(
                  //     height: AppSize.s100,
                  //     width: AppSize.s100,
                  //     child: Shimmer.fromColors(
                  //       baseColor: Colors.grey[850]!,
                  //       highlightColor: Colors.grey[800]!,
                  //       child: Container(
                  //         height: AppSize.s100,
                  //         decoration: BoxDecoration(
                  //           color: ColorManager.purple,
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //       ),
                  //     ),
                  //   )

                  // CachedNetworkImage(
                  //     imageUrl: '',
                  //     imageBuilder: (context, imageProvider) {
                  //       return Container(
                  //         height: AppSize.s100,
                  //         width: AppSize.s100,
                  //         decoration: BoxDecoration(
                  //           color: ColorManager.white,
                  //           borderRadius: BorderRadius.circular(AppSize.s10),
                  //           image: DecorationImage(
                  //             image: MemoryImage(
                  //               base64Decode(todoList[index].image),
                  //             ),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     fit: BoxFit.cover,
                  //     placeholder: (context, url) => Shimmer.fromColors(
                  //       baseColor: Colors.grey[850]!,
                  //       highlightColor: Colors.grey[800]!,
                  //       child: Container(
                  //         height: AppSize.s100,
                  //         decoration: BoxDecoration(
                  //           color: Colors.black,
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //       ),
                  //     ),
                  //     errorWidget: (context, url, error) => Shimmer.fromColors(
                  //       baseColor: Colors.grey[850]!,
                  //       highlightColor: Colors.grey[800]!,
                  //       child: Container(
                  //         height: AppSize.s100,
                  //         decoration: BoxDecoration(
                  //           color: Colors.black,
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  Container(
                      height: AppSize.s100,
                      width: AppSize.s100,
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(AppSize.s10),
                        image: DecorationImage(
                          image: MemoryImage(
                            base64Decode(todoList[index].image),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const SizedBox(),
              // InkWell(
              //   onTap: () {
              //     cubit.removeTask(todoList[index].task);
              //   },
              //   child: Container(
              //     height: AppSize.s35,
              //     width: AppSize.s35,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(AppSize.s8),
              //       color: ColorManager.red,
              //     ),
              //     child: Center(
              //       child: Icon(
              //         Icons.delete,
              //         color: ColorManager.white,
              //         size: AppSize.s20,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addNewTaskBar(MainCubit cubit, BuildContext context) {
    return Padding(
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _taskTextEditingController,
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
                        const SizedBox(width: AppSize.s5),
                        InkWell(
                          onTap: () {
                            cubit.pickImage();
                          },
                          child: cubit.image == null
                              ? CircleAvatar(
                                  maxRadius: AppSize.s25,
                                  backgroundColor: ColorManager.white,
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: AppSize.s35,
                                    color: ColorManager.purple,
                                  ),
                                )
                              : Container(
                                  height: AppSize.s35,
                                  width: AppSize.s35,
                                  decoration: BoxDecoration(
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.circular(AppSize.s10),
                                    image: DecorationImage(
                                      image: FileImage(cubit.image!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // child: Image.memory(base64Decode(cubit.image.toString())),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSize.s10),
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
              child: InkWell(
                onTap: () {
                  if (_taskTextEditingController.text.isNotEmpty) {
                    cubit.addTask(_taskTextEditingController.text);
                    _taskTextEditingController.clear();
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  }
                },
                child: CircleAvatar(
                  maxRadius: AppSize.s25,
                  backgroundColor: ColorManager.purple,
                  child: Icon(
                    Icons.add,
                    size: AppSize.s35,
                    color: ColorManager.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> goToUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget removeTasksDialog(BuildContext context, MainCubit cubit) {
    return AlertDialog(
      backgroundColor: ColorManager.primary,
      shadowColor: ColorManager.purple.withOpacity(0.5),
      content: Container(
        height: AppSize.s120,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Are you sure you want to delete all tasks ?",
              style: TextStyle(
                color: ColorManager.dark,
                fontSize: AppSize.s20,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s20),
                        color: ColorManager.purple,
                      ),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(AppSize.s10),
                        child: Text(
                          "Cencel",
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: AppSize.s15,
                            fontWeight: FontWeightManager.medium,
                          ),
                        ),
                      )),
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      cubit.deleteAllTasks();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      // height: AppSize.s35,
                      // width: AppSize.s60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s20),
                        color: ColorManager.purple,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSize.s10),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: AppSize.s15,
                              fontWeight: FontWeightManager.medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
