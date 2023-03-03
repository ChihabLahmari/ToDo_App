import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/domain/model/todo.dart';
import 'app/app.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());

  // open a box
  await Hive.openBox('myBox');

  runApp(const MainApp());
}
