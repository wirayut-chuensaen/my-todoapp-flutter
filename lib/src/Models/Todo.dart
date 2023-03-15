import "package:todo_app/src/Models/Task.dart";

class Todo {
  final String uuid;
  final String? todoTitle;
  final String? startDate;
  final String? endDate;
  List<Task> taskList;

  Todo({
    this.uuid = "",
    required this.todoTitle,
    required this.startDate,
    required this.endDate,
    required this.taskList,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      uuid: json["uuid"],
      todoTitle: json["todo_title"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      taskList: json["task_list"] != null
          ? List.of(json["task_list"]).map((i) => Task.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "todo_title": todoTitle,
      "start_date": startDate,
      "end_date": endDate,
      "task_list": taskList.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Task{uuid: $uuid, todo_title: $todoTitle, start_date: $startDate, end_date: $endDate, task_list: $taskList}';
  }
}
