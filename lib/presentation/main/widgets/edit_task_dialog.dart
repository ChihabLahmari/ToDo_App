// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/resources/font_manager.dart';

import '../../resources/app_size.dart';
import '../../resources/color_manager.dart';
import '../bloc/cubit.dart';

class EditTaskDialogBox extends StatelessWidget {
  final TextEditingController controller;
  MainCubit cubit;
  String task;
  int index;

  EditTaskDialogBox(
    Key? key,
    this.controller,
    this.cubit,
    this.task,
    this.index,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = task;
    return AlertDialog(
      backgroundColor: ColorManager.primary,
      shadowColor: ColorManager.purple.withOpacity(0.5),
      content: Container(
        height: AppSize.s120,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorManager.dark,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorManager.purple,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorManager.purple,
                  ),
                ),
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
                SizedBox(width: AppSize.s20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      cubit.editTask(index, controller.text);
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
                            "Done",
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
