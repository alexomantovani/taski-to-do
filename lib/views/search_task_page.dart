import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/enums/task_type.dart';
import '../core/enums/view_type.dart';
import '../core/extensions/context_ext.dart';
import '../core/services/assets.dart';
import '../core/services/styles.dart';
import '../viewmodels/task_view_model.dart';
import '../widgets/custom_field.dart';
import '../widgets/empty_tasks.dart';
import '../widgets/loading_widget.dart';
import '../widgets/task_error_widget.dart';
import '../widgets/tasks_list_view.dart';

class SearchTaskPage extends StatefulWidget {
  const SearchTaskPage({super.key});

  @override
  State<SearchTaskPage> createState() => _SearchTaskPageState();
}

class _SearchTaskPageState extends State<SearchTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
            child: CustomField(
              controller: taskController,
              filled: true,
              fillColor: Styles.kPrimaryPale,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: SvgPicture.asset(
                  Assets.kIcSearch,
                  colorFilter:
                      ColorFilter.mode(Styles.kPrimaryBlue, BlendMode.srcIn),
                ),
              ),
              hintText: 'Search tasks',
              hintStyle: context.textTheme.bodyMedium,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    taskController.text = '';
                    Provider.of<TaskViewModel>(context, listen: false)
                        .getTasksByTitle(taskController.text);
                  },
                  icon: SvgPicture.asset(
                    Assets.kIcClose,
                  ),
                ),
              ),
              onChanged: (value) =>
                  Provider.of<TaskViewModel>(context, listen: false)
                      .getTasksByTitle(value),
            ),
          ),
        ),
        Expanded(
          child: Consumer<TaskViewModel>(
            builder: (context, taskViewModel, child) {
              switch (taskViewModel.state) {
                case TaskState.loading:
                  return LoadingWidget();

                case TaskState.filterSuccess || TaskState.loadSuccess:
                  final tasks = context.taskViewModel.tasks
                      .where((task) => task.title
                          .toLowerCase()
                          .contains(taskController.text.toLowerCase()))
                      .toList();
                  if (tasks.isEmpty) {
                    return const EmptyTasks(type: ViewType.search);
                  }

                  return TasksListView(tasks: tasks, type: ViewType.search);

                case TaskState.error:
                  return TaskErrorWidget();

                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
