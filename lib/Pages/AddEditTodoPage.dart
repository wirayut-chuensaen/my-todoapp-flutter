import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';
import 'package:todo_app/Widgets/AppDialog.dart';
import 'package:todo_app/Widgets/AppSnackBar.dart';
import 'package:todo_app/Widgets/AppText.dart';
import '../Models/Task.dart';
import '../Models/Todo.dart';
import '../Services/TodoService.dart';
import '../Widgets/AppTextField.dart';

class AddEditTodoPage extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoPage({super.key, this.todo});

  @override
  State<AddEditTodoPage> createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  final TextEditingController title = TextEditingController();
  String _title = "";
  String _startDate = "";
  String _endDate = "";
  bool isUpdateTodo = false;

  final List<Task> _taskList = [];

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.light;
    initialTodo();
  }

  void initialTodo() {
    if (widget.todo != null) {
      setState(() {
        isUpdateTodo = true;
        title.text = widget.todo!.todoTitle.toString();
        _title = widget.todo!.todoTitle.toString();
        _startDate = widget.todo!.startDate.toString();
        _endDate = widget.todo!.endDate.toString();
        _taskList.addAll(widget.todo!.taskList);
      });
    }
  }

  void onSubmit() {
    bool validateStatus = onValidateForm();
    if (validateStatus == true) {
      EasyLoading.show(status: "Loading...");
      Todo todo = Todo(
        todoTitle: _title,
        startDate: _startDate,
        endDate: _endDate,
        taskList: _taskList,
      );
      if (isUpdateTodo == false) {
        TodoService().add(todo.toJson());
        snackbar("Todo added.", context);
        Navigator.pop(context);
      } else {
        TodoService().updateByID(todo.toJson(), widget.todo!.uuid);
        snackbar("Todo updated..", context);
        Navigator.pop(context);
      }
      EasyLoading.dismiss();
    }
  }

  bool onValidateForm() {
    var list = _taskList
        .where((element) =>
            element.taskDescription == "" || element.taskDescription == null)
        .toList();
    if (_title.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: "Please enter todo title.",
        ),
      );
      return false;
    } else if (_startDate.isEmpty || _endDate.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription: "Please enter todo start date and end date.",
        ),
      );
      return false;
    } else if (list.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.warning,
          dialogTitle: "Warning",
          dialogDescription:
              "Task list is empty or task dedscription in list is empty.",
        ),
      );
      return false;
    }
    return true;
  }

  void onDeleteTodo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        dialogType: DialogType.comfirm,
        dialogLogo: DialogLogo.cross,
        dialogTitle: "Confirm delete this todo?",
        onPopScope: false,
        confirmDeleteBtn: true,
        onConfirmBtnPress: () {
          TodoService().deleteByID(widget.todo!.uuid);
          snackbar("Deleted", context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildBottomButton() {
    if (isUpdateTodo) {
      return Container(
        width: double.infinity,
        height: 60,
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
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange.shade800,
                  ],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onDeleteTodo(),
                  child: const Center(
                    child: AppText(
                      text: "Delete todo",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.blue,
                  ],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSubmit(),
                  child: const Center(
                    child: AppText(
                      text: "Update todo",
                      color: Colors.white,
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Colors.blue,
              Colors.cyan,
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarCustom(
        title: isUpdateTodo == false ? "Add Todo" : "Update Todo",
        onPress: () => Navigator.pop(context),
        isMain: false,
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_main.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kTextTabBarHeight + 50,
              ),
              const AppText(
                text: "Title",
                size: 16,
              ),
              AppTextField(
                text: title,
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              const AppText(
                text: "Start date",
                size: 16,
              ),
              DatePicker(
                onSelectDate: (date) {
                  setState(() {
                    _startDate = date;
                  });
                },
                date: _startDate,
              ),
              const SizedBox(height: 10),
              const AppText(
                text: "End date",
                size: 16,
              ),
              DatePicker(
                onSelectDate: (date) {
                  setState(() {
                    _endDate = date;
                  });
                },
                date: _endDate,
              ),
              const SizedBox(height: 40),
              buildTaskList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomButton(),
    );
  }

  Widget buildTaskList() {
    if (_taskList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: "Task list :",
            size: 16,
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _taskList.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (ctx, index) => buildTaskItem(_taskList[index], index),
          ),
        ],
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

class DatePicker extends StatefulWidget {
  final Function(String date)? onSelectDate;
  final String? date;

  const DatePicker({super.key, this.onSelectDate, this.date});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String dateShow = "";
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    initDate();
  }

  void initDate() {
    if (widget.date != null && widget.date != "") {
      DateTime tempDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.date.toString());
      setState(() {
        dateShow = "${tempDate.year}-${tempDate.month}-${tempDate.day}";
        dateTime = tempDate;
      });
    }
  }

  void selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(9999),
    );
    if (picked != null) {
      setState(() {
        dateShow = "${picked.year}-${picked.month}-${picked.day}";
      });
      if (widget.onSelectDate != null) {
        String tempDateString =
            DateFormat("yyyy-MM-dd hh:mm:ss").format(picked);
        widget.onSelectDate!(tempDateString);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectDate(),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
              color: const Color.fromRGBO(232, 232, 232, 1), width: 0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: dateShow),
            const Icon(
              Icons.calendar_month,
              color: Colors.grey,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
