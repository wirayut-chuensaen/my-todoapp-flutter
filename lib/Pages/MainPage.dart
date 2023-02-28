// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Pages/AddEditTodoPage.dart';
import 'package:todo_app/Pages/LoginPage.dart';
import 'package:todo_app/Services/TodoService.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';
import 'package:todo_app/Widgets/AppSnackBar.dart';
import 'package:todo_app/Widgets/AppText.dart';
import '../Services/AuthService.dart';
import '../Models/Todo.dart';
import '../Widgets/AppDialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _email = "";
  String _versionNumber = "";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.light;
    initVersionNumber();
  }

  void initVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {
      _versionNumber = 'Version $version ($buildNumber)';
    });
  }

  void onResetPassword() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        onPopScope: false,
        dialogType: DialogType.input,
        dialogLogo: DialogLogo.contact,
        dialogTitle: "Enter your email",
        dialogDescription:
            "We will send you an email to reset your password by email.",
        inputPlaceHolder: "Email",
        inputValue: _email,
        onInputChange: (value) {
          _email = value;
        },
        onConfirmBtnPress: () => onResetPasswordProcess(),
      ),
    );
  }

  void onResetPasswordProcess() {
    if (_email == AuthService.getUserEmail()) {
      Navigator.pop(context); // pop previous dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppDialog(
          dialogType: DialogType.comfirm,
          dialogLogo: DialogLogo.warning,
          onPopScope: false,
          dialogTitle: "Confirm send reset password email?",
          onConfirmBtnPress: () async {
            EasyLoading.show(status: "Loading...");
            bool isReseted = await AuthService.resetPassword(context, _email);
            if (isReseted) {
              EasyLoading.dismiss();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AppDialog(
                  dialogType: DialogType.alert,
                  dialogLogo: DialogLogo.check,
                  onPopScope: false,
                  dialogDescription:
                      "Password reset email sent successfully. If you can't find it, it might be in your junk mail.",
                  onConfirmBtnPress: () {
                    Navigator.pop(context);
                    onLogout();
                  },
                ),
              );
            } else {
              EasyLoading.dismiss();
              Navigator.pop(context);
              snackbar("Something went wrong.", context);
            }
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AppDialog(
          dialogType: DialogType.alert,
          dialogLogo: DialogLogo.cross,
          dialogTitle: "Email invalid",
          dialogDescription: "Input email and account email do not match.",
          onConfirmBtnPress: () => Navigator.pop(context),
        ),
      );
    }
  }

  void onLogout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        dialogType: DialogType.comfirm,
        dialogLogo: DialogLogo.warning,
        onPopScope: false,
        dialogTitle: "Confirm logout?",
        onConfirmBtnPress: () async {
          var prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          await AuthService.logout().then((value) {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => const LoginPage())));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBarCustom(
        title: "Hi, ${AuthService.getUserDisplayName()}",
        onPress: () => _scaffoldKey.currentState?.openDrawer(),
        isMain: true,
      ),
      // drawer: buildDrawer(),
      drawer: buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_main.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: buildListBody(),
      ),
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

  Widget buildListBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: TodoService().getTodoListOfCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          showDialog(
            context: context,
            builder: (context) => AppDialog(
              dialogType: DialogType.alert,
              dialogLogo: DialogLogo.warning,
              dialogTitle: "oops!",
              dialogDescription: "Something went wrong\nCannot get todo list.",
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // ex. loading widget
        } else if (snapshot.data!.size == 0) {
          return const Center(
            child: AppText(text: "There are no TODOs, add them!"),
          );
        } else if (snapshot.hasData && snapshot.data!.size > 0) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 50,
              bottom: 80,
            ),
            itemBuilder: (context, index) => TodoItem(
              snapshot: snapshot,
              index: index,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: kToolbarHeight + 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: Colors.grey.shade100,
                          spreadRadius: 4,
                          blurRadius: 8,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/todo.jpg",
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppText(
                    text: "My Todo App",
                    color: Theme.of(context).primaryColor,
                    size: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(
                    text: "by Wirayut Chuensaen",
                    color: Theme.of(context).primaryColor,
                  ),
                  AppText(
                    text: "@github/wirayut-chuensaen",
                    color: Theme.of(context).primaryColor,
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
                    iconColor: Theme.of(context).primaryColor,
                    title: const AppText(text: "Reset password"),
                    onTap: () => onResetPassword(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    iconColor: Theme.of(context).primaryColor,
                    title: const AppText(text: "About"),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "About",
                        applicationIcon: const Icon(
                          Icons.menu_book,
                          color: Colors.blue,
                          size: 30,
                        ),
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: "My Todo App",
                                fontWeight: FontWeight.bold,
                                size: 16,
                              ),
                              AppText(
                                text: _versionNumber,
                              ),
                              const AppText(
                                text: "by Wirayut Chuensaen",
                              ),
                              const AppText(
                                text: "@github/wirayut-chuensaen",
                              ),
                              const AppText(text: "Feature :"),
                              const AppText(
                                  text:
                                      " - Authenticate with Firebase(Login, Sign up and reset password)"),
                              const AppText(
                                  text:
                                      " - Read/write data with Firebase(Create update and delete todo)"),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    iconColor: Colors.red,
                    title: const AppText(
                      text: "Log out",
                      color: Colors.red,
                    ),
                    onTap: () => onLogout(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;

  const TodoItem({
    super.key,
    required this.snapshot,
    required this.index,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  Todo? todo;
  bool expandState = true;

  @override
  void initState() {
    super.initState();
    todo = Todo.fromJson(widget.snapshot.data!.docs[widget.index].data()
        as Map<String, dynamic>);
  }

  @override
  void didUpdateWidget(TodoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.snapshot != oldWidget.snapshot) {
      todo = Todo.fromJson(widget.snapshot.data!.docs[widget.index].data()
          as Map<String, dynamic>);
    }
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
                                )));
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
          title: AppText(text: todo!.todoTitle.toString()),
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
