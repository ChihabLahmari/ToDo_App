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

  late List filteredList;

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
    db.toDoList
        .add(Todo(task: task, image: img64, id: DateTime.now().millisecondsSinceEpoch.toString()));
    // print("✅ ADD task $task :✅ \n ${DateTime.now().millisecondsSinceEpoch}");

    image = null;
    img64 = null;

    db.updateData();

    emit(MainAddTaskState());
  }

  void doneTask(String id) {
    // db.toDoList.reversed.toList()[index].isDone = !db.toDoList.reversed.toList()[index].isDone;

    doneTaskById(id);

    db.updateData();

    emit(MainDoneTaskState());
  }

  void editTask(String id, String newTask) {
    editTaskById(id, newTask);

    db.updateData();

    emit(MainEditTaskState());
  }

  void removeTask(String id, String searchText) {
    // db.toDoList.removeWhere((element) => element.task == task);
    db.toDoList.removeWhere((todo) => todo.id == id);

    // print("✅ id :✅ \n $id");

    db.updateData();

    // TODO: handel this (m3mbalish kfh nmdlha task ki hiya trdli empty w ki n7iha tfzd)
    if (searchText != "") {
      searchTask(searchText);
    }

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

  void searchTask(String? value) {
    // print("🔥 Search started ✅");
    if (value == null || value == '') {
      filteredList = db.toDoList;
      emit(MainSearchTaskState());
    } else {
      filteredList = db.toDoList.where((element) => element.task.startsWith(value)).toList();
      emit(MainSearchTaskState());
    }
  }

  // edit Functions ::
  void editTaskById(String id, String newTask) {
    // find the object in the list using its ID
    Todo? obj = db.toDoList.firstWhere((todo) => todo.id == id, orElse: () => null);

    // if the object is found, update its task property
    if (obj != null) {
      obj.task = newTask;
    }

    // 🛑 IMPORTANT:

    //  the obj is edited in the db.todoList & the FilreredList
    //(because both lists contain a reference to the same object in memory)

    //     If the same object is present in two different lists,
    // editing the object in one list will also update it in the other list.
    // This is because both lists contain a reference to the same object in memory.

    // When you retrieve an object from a list and store it in a variable,
    // you are actually storing a reference to the object,
    // not a copy of the object.
    // So if you edit the object through that variable,
    // the changes will be reflected in all lists that contain a reference to that object.
  }

  void doneTaskById(String id) {
    // find the object in the list using its ID
    Todo? obj = db.toDoList.firstWhere((todo) => todo.id == id, orElse: () => null);

    // if the object is found, update its isDone property
    if (obj != null) {
      obj.isDone = !obj.isDone;
    }
  }
}
