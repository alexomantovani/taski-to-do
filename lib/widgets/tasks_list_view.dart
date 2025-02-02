import 'package:flutter/material.dart';

import '../core/enums/view_type.dart';
import '../core/extensions/context_ext.dart';
import '../models/task_model.dart';
import 'label_header.dart';
import 'task_item.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({
    super.key,
    required this.tasks,
    this.type = ViewType.todo,
  });

  final List<TaskModel> tasks;
  final ViewType? type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        type == ViewType.search
            ? const SizedBox.shrink()
            : LabelHeader(
                taskCounter: type == ViewType.todo
                    ? tasks
                        .where((task) => task.status == Status.todo)
                        .toList()
                        .length
                    : tasks.length,
                type: type,
              ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 26.0,
              vertical: type == ViewType.search || type == ViewType.delete
                  ? 12.0
                  : 32.0,
            ),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => Opacity(
                opacity: type != ViewType.delete &&
                        tasks[index].status == Status.done
                    ? 0.2
                    : 1.0,
                child: TaskItem(
                  task: tasks[index],
                  onUpdate: (updatedTask) =>
                      context.taskViewModel.updateTask(updatedTask),
                  onToggleExpansion: (taskId) =>
                      context.taskViewModel.toggleTaskExpansion(taskId),
                  expandedTasks: context.taskViewModel.expandedTasks,
                  onDeleteTask: type != ViewType.delete
                      ? null
                      : (taskId) => context.taskViewModel.deleteTask(taskId),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
