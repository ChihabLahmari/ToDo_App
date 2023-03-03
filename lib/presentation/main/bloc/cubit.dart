import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/app_prefs.dart';
import 'package:todo_app/domain/model/todo.dart';
import 'package:todo_app/presentation/main/bloc/states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitState());

  // to be more easily when use this cubit in many places
  static MainCubit get(context) => BlocProvider.of(context);

  final _myBox = Hive.box('mybox');
  AppPreferences db = AppPreferences();

  void getDataFromLocal() {
    if (_myBox.get(TO_DO_LIST) == null) {
      db.creatInitialData();
    } else {
      db.getData();
    }
  }

  void addTask(String task) {
    db.toDoList.add(Todo(task: task));

    db.updateData();

    emit(MainAddTaskState());
  }

  void doneTask(int index) {
    db.toDoList.reversed.toList()[index].isDone = !db.toDoList.reversed.toList()[index].isDone;

    db.updateData();

    emit(MainDoneTaskState());
  }

  void editTask(int index, String newTask) {
    db.toDoList.reversed.toList()[index].task = newTask;

    db.updateData();

    emit(MainEditTaskState());
  }

  void removeTask(String task) {
    db.toDoList.removeWhere((element) => element.task == task);

    db.updateData();

    emit(MainRemoveTaskState());
  }
}
