import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  String? image;

  @HiveField(3)
  String id;

  Todo({
    required this.task,
    required this.id,
    this.isDone = false,
    this.image,
  });
}
