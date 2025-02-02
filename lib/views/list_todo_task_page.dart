import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums/task_type.dart';
import '../core/extensions/context_ext.dart';
import '../viewmodels/task_view_model.dart';
import '../widgets/empty_tasks.dart';
import '../widgets/loading_widget.dart';
import '../widgets/task_error_widget.dart';
import '../widgets/tasks_list_view.dart';

class ListTodoTaskPage extends StatelessWidget {
  const ListTodoTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(builder: (context, taskViewModel, child) {
      switch (taskViewModel.state) {
        case TaskState.initial ||
              TaskState.createSuccess ||
              TaskState.filterSuccess:
          context.initTasks();
          return SizedBox.shrink();

        case TaskState.loading:
          return LoadingWidget();

        case TaskState.loadSuccess:
          final tasks = taskViewModel.tasksNotifier.value;
          if (tasks.isEmpty) return const EmptyTasks();

          return TasksListView(tasks: tasks);

        case TaskState.error:
          return TaskErrorWidget();

        default:
          return const SizedBox.shrink();
      }
    });
  }
}
