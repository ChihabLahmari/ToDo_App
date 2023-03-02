import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/app_prefs.dart';
import 'package:todo_app/domain/model.dart';
import 'package:todo_app/presentation/main/bloc/states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitState());

  // to be more easily when use this cubit in many places
  static MainCubit get(context) => BlocProvider.of(context);

  List<Todo> tasks = [
    Todo(task: "flutter"),
    Todo(task: "Cubit"),
    Todo(task: "Github"),
    Todo(task: "Instagram", isDone: true),
  ];

  late Box box;

  void getStoredTasks() async {
    box = await Hive.openBox('box');
    
  }

  void addTask(String task) {
    tasks.add(Todo(task: task));

    emit(MainAddTaskState());
  }

  void doneTask(int index) {
    tasks.reversed.toList()[index].isDone = !tasks.reversed.toList()[index].isDone;
    emit(MainDoneTaskState());
  }

  void removeTask(String task) {
    tasks.removeWhere((element) => element.task == task);
    emit(MainRemoveTaskState());
  }
}
