import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taski_to_do/models/task_model.dart';

import '../../../core/enums/task_type.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/services/assets.dart';
import '../../../core/services/navigation_provider.dart';
import '../../../core/services/styles.dart';
import '../../../viewmodels/task_view_model.dart';
import '../../../widgets/custom_field.dart';

class CreateModal extends StatelessWidget {
  const CreateModal({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 30.0),
              CustomField(
                controller: titleController,
                defaultBorder: false,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SvgPicture.asset(Assets.kIcEmptyBox),
                ),
                hintText: "What’s in your mind?",
                hintStyle: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 30.0),
              CustomField(
                controller: descriptionController,
                defaultBorder: false,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SvgPicture.asset(Assets.kIcEdit),
                ),
                hintText: "Add a note...",
                hintStyle: context.textTheme.bodyMedium,
              ),
              SizedBox(height: context.height / 5),
              Consumer<TaskViewModel>(
                builder: (context, taskViewModel, child) {
                  switch (taskViewModel.state) {
                    case TaskState.loading:
                      return const CircularProgressIndicator();
                    default:
                      return TextButton(
                        onPressed: () => _createTask(context),
                        child: Text(
                          'Create',
                          style: context.textTheme.titleLarge!
                              .copyWith(color: Styles.kPrimaryBlue),
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createTask(
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
      final newTask = TaskModel(
        id: DateTime.now().toString(),
        title: titleController.text,
        description: descriptionController.text,
        status: Status.todo,
        createdAt: DateTime.now().toIso8601String(),
      );

      await taskViewModel.addTask(newTask);

      if (!context.mounted) return;
      _closeModal(context);
      _backTodo(context);
    }
  }

  void _closeModal(BuildContext context) {
    Navigator.pop(context);
  }

  void _backTodo(BuildContext context) {
    Provider.of<NavigationProvider>(context, listen: false).setCurrentIndex(0);
  }
}
