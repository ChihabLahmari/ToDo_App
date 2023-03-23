import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/domain/model/todo.dart';

const String TO_DO_LIST = "TO_DO_LIST";

class AppPreferences {
  List toDoList = [];

  final _myBox = Hive.box('myBox');

  // first time opening the app
  void creatInitialData() {
    toDoList = [
      Todo(task: "Study", id: DateTime.now().second.toString()),
      Todo(task: "Workout", id: DateTime.now().millisecondsSinceEpoch.toString()),
    ];
  }

  // get data
  void getData() {
    toDoList = _myBox.get(TO_DO_LIST);
  }

  // update data
  void updateData() {
    _myBox.put(TO_DO_LIST, toDoList);
  }

  // delete all tasks
  void deleteAllTasks() {
    _myBox.put(TO_DO_LIST, []);
  }
}
