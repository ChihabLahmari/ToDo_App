import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  String? image;

  Todo({
    required this.task,
    this.isDone = false,
    this.image,
  });
}
