// ignore_for_file: public_member_api_docs, sort_constructors_first
class Todo {
  String task;
  bool isDone;
  Todo({
    required this.task,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'isDone': isDone,
    };
  }

  factory Todo.fromMap(Map map) {
    return Todo(
      task: map['task'],
      isDone: map['isDone'],
    );
  }
}
