import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:todo_app/Pages/AddTodoPage.dart';
import 'package:todo_app/Services/todoService.dart';
import 'package:todo_app/Widgets/AppBarCustom.dart';
import 'package:todo_app/Widgets/AppText.dart';

import '../Models/Todo.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedExpansionTile = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: "Todo list"),
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
              builder: (context) => const AddTodoPage(),
            ),
          );
        },
      ),
    );
  }

  Widget buildListBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: TodoService().getTodoListOfCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: AppText(text: "Something went wrong"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          EasyLoading.instance.maskType = EasyLoadingMaskType.black;
          EasyLoading.show(status: 'Loading...');
        } else if (snapshot.data!.size == 0) {
          EasyLoading.dismiss();
          return const Center(
            child: AppText(text: "There are no TODOs, add them!"),
          );
        } else if (snapshot.hasData && snapshot.data!.size > 0) {
          EasyLoading.dismiss();
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Todo todo = Todo.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ExpansionTile(
                      initiallyExpanded: index == selectedExpansionTile,
                      onExpansionChanged: ((newState) {
                        if (newState) {
                          setState(() {
                            selectedExpansionTile = index;
                          });
                        } else {
                          setState(() {
                            selectedExpansionTile = -1;
                          });
                        }
                      }),
                      leading: const Icon(Icons.fiber_manual_record),
                      title: AppText(text: todo.todoTitle),
                      trailing: const Icon(Icons.keyboard_arrow_down),
                      children: todo.taskList
                          .asMap()
                          .entries
                          .map(
                            (task) => CheckboxListTile(
                              contentPadding: const EdgeInsets.only(left: 30),
                              value: task.value.status,
                              title: AppText(
                                  text: task.value.taskDescription.toString()),
                              onChanged: (value) {
                                setState(
                                  () {
                                    task.value.status = value;
                                    TodoService().updateByID(
                                        todo.toJson(), todo.uuid.toString());
                                  },
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
