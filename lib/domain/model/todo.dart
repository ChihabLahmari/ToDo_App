import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  bool isDone;
  Todo({
    required this.task,
    this.isDone = false,
  });
}
