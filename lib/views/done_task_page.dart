import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums/task_type.dart';
import '../core/enums/view_type.dart';
import '../core/extensions/context_ext.dart';
import '../models/task_model.dart';
import '../viewmodels/task_view_model.dart';
import '../widgets/empty_tasks.dart';
import '../widgets/task_error_widget.dart';
import '../widgets/tasks_list_view.dart';

class DoneTaskPage extends StatelessWidget {
  const DoneTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, child) {
        switch (taskViewModel.state) {
          case TaskState.initial || TaskState.filterSuccess:
            context.initTasks();
            return const SizedBox.shrink();

          case TaskState.loading:
            return const Center(child: CircularProgressIndicator());

          case TaskState.deleteSuccess || TaskState.loadSuccess:
            final tasks = taskViewModel.tasksNotifier.value
                .where((task) => task.status == Status.done)
                .toList();
            if (tasks.isEmpty) {
              return const EmptyTasks(type: ViewType.delete);
            }

            return TasksListView(tasks: tasks, type: ViewType.delete);

          case TaskState.error:
            return TaskErrorWidget();

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
