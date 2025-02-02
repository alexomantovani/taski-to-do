import 'package:flutter/material.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/styles.dart';
import '../core/enums/view_type.dart';

class LabelHeader extends StatelessWidget {
  const LabelHeader({
    super.key,
    this.taskCounter,
    this.type = ViewType.todo,
  });

  final int? taskCounter;
  final ViewType? type;

  @override
  Widget build(BuildContext context) {
    return type == ViewType.delete
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed Tasks',
                  style: context.textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => context.taskViewModel.deleteAllTasks(),
                  child: Text(
                    'Delete all',
                    style: context.textTheme.titleMedium!.copyWith(
                      color: Styles.kPrimaryDelete,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome, ',
                        style: context.textTheme.titleLarge,
                      ),
                      TextSpan(
                        text: 'John.',
                        style: context.textTheme.titleLarge!
                            .copyWith(color: Styles.kPrimaryBlue),
                      ),
                    ],
                  ),
                ),
                Text(
                  taskCounter != null && taskCounter! == 1
                      ? 'You’ve got $taskCounter task to do.'
                      : taskCounter != null && taskCounter! > 1
                          ? 'You’ve got $taskCounter tasks to do.'
                          : 'Create tasks to achieve more.',
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          );
  }
}
