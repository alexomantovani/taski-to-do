import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/task_type.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/utils/core_utils.dart';
import '../../../viewmodels/task_view_model.dart';
import '../../../widgets/empty_tasks.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/tasks_list_view.dart';
import '../widgets/create_modal.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CoreUtils.showWidgetOnInit(
      context: context,
      child: CreateModal(
        formKey: _formKey,
        titleController: titleController,
        descriptionController: descriptionController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, child) {
        switch (taskViewModel.state) {
          case TaskState.initial || TaskState.filterSuccess:
            context.initTasks();
            return const SizedBox.shrink();

          case TaskState.loading:
            return LoadingWidget();

          case TaskState.createSuccess ||
                TaskState.loadSuccess ||
                TaskState.getByIdSuccess:
            final tasks = taskViewModel.tasksNotifier.value;
            if (tasks.isEmpty) return const EmptyTasks();

            return TasksListView(tasks: tasks);

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
