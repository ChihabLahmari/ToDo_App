import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/app_prefs.dart';
import 'package:todo_app/domain/model/todo.dart';
import 'package:todo_app/presentation/main/bloc/states.dart';
import 'package:path/path.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitState());

  // to be more easily when use this cubit in many places
  static MainCubit get(context) => BlocProvider.of(context);

  File? image;
  Uint8List? bytes;
  String? img64;

  final _myBox = Hive.box('mybox');
  AppPreferences db = AppPreferences();

  void getDataFromLocal() {
    if (_myBox.get(TO_DO_LIST) == null) {
      db.creatInitialData();
    } else {
      db.getData();
    }
  }

  void addTask(String task) async {
    db.toDoList.add(Todo(task: task, image: img64));

    image = null;
    img64 = null;

    db.updateData();

    emit(MainAddTaskState());
  }

  void doneTask(int index) {
    db.toDoList.reversed.toList()[index].isDone = !db.toDoList.reversed.toList()[index].isDone;

    db.updateData();

    emit(MainDoneTaskState());
  }

  void editTask(int index, String newTask, String oldTask) {
    print("✅ Edit Task ✅");
    print(index);
    db.toDoList.reversed.toList()[index].task = newTask;

    db.updateData();

    emit(MainEditTaskState());
  }

  void removeTask(String task) {
    db.toDoList.removeWhere((element) => element.task == task);

    db.updateData();

    // TODO: handel this (m3mbalish kfh nmdlha task ki hiya trdli empty w ki n7iha tfzd)
    searchTask(task);

    emit(MainRemoveTaskState());
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      image = File(pickerFile.path);
      print("✅ image ✅ \n $image");

      bytes = File(pickerFile.path).readAsBytesSync();
      print("✅ bytes ✅ \n $bytes");

      img64 = base64Encode(bytes!);
      print("✅ img64 ✅ \n $img64");

      emit(MainPickImageSuccessState());
    } else {
      print("🛑 pick image error 🛑");
      emit(MainPickImageErrorState());
    }
  }

  late List todolist;

  void searchTask(String? value) {
    print("Search started ");
    if (value == '') {
      // print("✅ Not Filtered List ✅");
      todolist = db.toDoList;

      emit(MainSearchTaskState());
    } else {
      // print("✅ Filtered List ✅");
      todolist = db.toDoList.where((element) => element.task.startsWith(value!)).toList();
      emit(MainSearchTaskState());
    }
  }
}
