import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Pages/AddEditTodoPage.dart';
import 'package:todo_app/Pages/LoginPage.dart';
import 'package:todo_app/Services/TodoService.dart';
import 'package:todo_app/Widgets/AppText.dart';
import 'package:todo_app/Widgets/AppTextField.dart';
import '../Services/AuthService.dart';
import '../Models/Todo.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final emailTextField = TextEditingController();
  String _email = "";

  void onResetPassword() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) {
        return AlertDialog(
          title: const AppText(text: "Enter your email"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                text: emailTextField,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(50),
                    shadowColor: Colors.grey.withOpacity(0.5),
                    elevation: 2.0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 4),
                        alignment: Alignment.center,
                        child: const AppText(text: "Cancel"),
                      ),
                    ),
                  ),
                  Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                    shadowColor: Colors.grey.withOpacity(0.5),
                    elevation: 2.0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.pop(context);
                        onResetPasswordProcess();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 4),
                        alignment: Alignment.center,
                        child: const AppText(
                          text: "Confirm",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  void onResetPasswordProcess() {
    if (_email == AuthService.getUserEmail()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: ((context) {
            return AlertDialog(
              title: const AppText(text: "Confirm send reset password email?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50),
                        shadowColor: Colors.grey.withOpacity(0.5),
                        elevation: 2.0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 4),
                            alignment: Alignment.center,
                            child: const AppText(text: "Cancel"),
                          ),
                        ),
                      ),
                      Material(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        shadowColor: Colors.grey.withOpacity(0.5),
                        elevation: 2.0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () async {
                            bool isReseted = await AuthService.resetPassword(
                                context, _email);
                            if (isReseted) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: const AppText(
                                        text:
                                            "Send reset password email success.\nPlease check your email(email box or junk box)."),
                                    actions: [
                                      Material(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(50),
                                        shadowColor:
                                            Colors.grey.withOpacity(0.5),
                                        elevation: 2.0,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: () {
                                            Navigator.pop(context);
                                            onLogout();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 4),
                                            alignment: Alignment.center,
                                            child: const AppText(
                                              text: "Confirm",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 4),
                            alignment: Alignment.center,
                            child: const AppText(
                              text: "Confirm",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }));
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Input email and account email do not match.",
      );
    }
  }

  void onLogout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await AuthService.logout().then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const LoginPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          text: "Hi, ${AuthService.getUserDisplayName()}",
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: buildDrawer(),
      body: buildListBody(context),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        label: const AppText(
          text: "Add Todo",
          color: Colors.white,
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTodoPage(),
            ),
          );
        },
      ),
    );
  }

  // for reload page state
  void reloadState() {
    setState(() {});
  }

  Widget buildListBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: TodoService().getTodoListOfCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: "Something went wrong\nCannot get todo list.",
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // ex. loading widget
        } else if (snapshot.data!.size == 0) {
          return const Center(
            child: AppText(text: "There are no TODOs, add them!"),
          );
        } else if (snapshot.hasData && snapshot.data!.size > 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => TodoItem(
                snapshot: snapshot,
                index: index,
                onReloadState: reloadState,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Column(
              children: const [
                SizedBox(
                  height: kToolbarHeight + 50,
                ),
                Center(
                  child: AppText(text: "My Simple Todo App"),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: kToolbarHeight / 2),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.key_outlined),
                  title: const AppText(text: "Reset password"),
                  onTap: () => onResetPassword(),
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const AppText(text: "Log out"),
                  onTap: () => onLogout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;
  final Function onReloadState;

  const TodoItem({
    super.key,
    required this.snapshot,
    required this.index,
    required this.onReloadState,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  Todo? todo;
  bool expandState = false;

  @override
  void initState() {
    super.initState();
    todo = Todo.fromJson(widget.snapshot.data!.docs[widget.index].data()
        as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: true,
          trailing: SizedBox(
            width: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEditTodoPage(
                                  todo: todo,
                                ))).then((value) => widget.onReloadState());
                  },
                  child: AppText(
                    text: "Edit",
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    textDecoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  expandState == true
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          onExpansionChanged: (bool expanded) {
            setState(() => expandState = expanded);
          },
          title: AppText(text: todo!.todoTitle),
          children: todo!.taskList
              .asMap()
              .entries
              .map(
                (task) => CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 30, right: 14),
                  value: task.value.status,
                  title: AppText(text: task.value.taskDescription.toString()),
                  onChanged: (value) {
                    setState(
                      () {
                        task.value.status = value;
                        TodoService()
                            .updateByID(todo!.toJson(), todo!.uuid.toString());
                      },
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
