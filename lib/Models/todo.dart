import "package:todo_app/Models/Task.dart";

class Todo {
  final String uuid;
  final String todoTitle;
  List<Task> taskList;

  Todo({
    this.uuid = "",
    required this.todoTitle,
    required this.taskList,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      uuid: json["uuid"],
      todoTitle: json["todo_title"],
      taskList: json["task_list"] != null
          ? List.of(json["task_list"]).map((i) => Task.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "todo_title": todoTitle,
      "task_list": taskList.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Task{uuid: $uuid, todo_title: $todoTitle, task_list: $taskList}';
  }
}
