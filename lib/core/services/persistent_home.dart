import 'package:flutter/widgets.dart';
import 'package:taski_to_do/views/createtask/views/create_task_page.dart';
import 'package:taski_to_do/views/done_task_page.dart';
import 'package:taski_to_do/views/list_todo_task_page.dart';
import 'package:taski_to_do/views/search_task_page.dart';

class PersistentHome {
  const PersistentHome._();

  static const List<Widget> pages = <Widget>[
    ListTodoTaskPage(),
    CreateTaskPage(),
    SearchTaskPage(),
    DoneTaskPage(),
  ];
}
