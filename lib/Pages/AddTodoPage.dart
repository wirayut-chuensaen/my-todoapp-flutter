import 'package:flutter/material.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';
import 'package:todo_app/Widgets/AppText.dart';

import '../Models/Task.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../Models/Todo.dart';
import '../Services/todoService.dart';
import '../Widgets/AppTextField.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController title = TextEditingController();
  String _title = "";

  final List<Task> _taskList = [
    Task.fromJson({"status": false})
  ];

  @override
  void initState() {
    super.initState();
  }

  void onSubmit() {
    bool validateStatus = onValidateForm();
    if (validateStatus == true) {
      Todo todo = Todo(todoTitle: _title, taskList: _taskList);
      TodoService().add(todo.toJson());
      Navigator.pop(context);
    }
  }

  bool onValidateForm() {
    var list = _taskList
        .where((element) =>
            element.taskDescription != "" && element.taskDescription != null)
        .toList();
    if (_title.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Please enter your title.",
      );
      return false;
    } else if (list.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Task list is empty or task dedscription in list is empty.",
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        showBack: true,
        title: "Add Todo",
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        label: const AppText(
          text: "Add Task",
          color: Colors.white,
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          setState(
            () {
              _taskList.add(Task.fromJson({"status": false}));
            },
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(text: "Title"),
            AppTextField(
              text: title,
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 15),
            buildTaskList(),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Theme.of(context).primaryColor,
          child: InkWell(
            onTap: () => onSubmit(),
            child: const SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: AppText(
                  text: "Add Todo",
                  size: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTaskList() {
    if (_taskList.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _taskList.length,
        itemBuilder: (ctx, index) => buildTaskItem(_taskList[index], index),
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 30, bottom: 30),
        child: AppText(
          text: "No task",
          size: 14,
        ),
      ),
    );
  }

  Widget buildTaskItem(Task task, int index) {
    final taskDescription = TextEditingController();
    taskDescription.text =
        task.taskDescription != null ? task.taskDescription.toString() : "";

    void onFormChange() {
      _taskList[index].taskDescription = taskDescription.text;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.only(right: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: "Task ${index + 1}"),
              AppTextField(
                text: taskDescription,
                onChanged: (value) {
                  onFormChange();
                },
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(
              () {
                _taskList.removeAt(index);
              },
            );
          },
          child: Container(
            height: 50,
            width: 34,
            margin: const EdgeInsets.only(top: 18),
            color: Colors.white,
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
