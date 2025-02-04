import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/assets.dart';
import '../core/services/styles.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final Function(TaskModel) onUpdate;
  final Function(String)? onToggleExpansion;
  final Function(String)? onDeleteTask;
  final ValueNotifier<Map<String, bool>>? expandedTasks;

  const TaskItem({
    super.key,
    required this.task,
    required this.onUpdate,
    required this.onToggleExpansion,
    required this.expandedTasks,
    this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDeleteTask != null || task.status == Status.done
          ? null
          : () {
              context.taskViewModel.getTaskById(task.id);
              context.navigationProvider.setCurrentIndex(1);
            },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Styles.kPrimaryPale,
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              IconButton(
                onPressed: () => onUpdate(
                  task.copyWith(
                    status:
                        task.status == Status.todo ? Status.done : Status.todo,
                  ),
                ),
                icon: SvgPicture.asset(
                  task.status == Status.todo
                      ? Assets.kIcEmptyBox
                      : onDeleteTask != null
                          ? Assets.kIcDone
                          : Assets.kIcDoneBox,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        task.title,
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    expandedTasks != null && task.status == Status.todo
                        ? ValueListenableBuilder<Map<String, bool>>(
                            valueListenable: expandedTasks!,
                            builder: (context, expandedMap, child) {
                              final isExpanded = expandedMap[task.id] ?? false;

                              return AnimatedCrossFade(
                                duration: const Duration(milliseconds: 200),
                                crossFadeState: isExpanded
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                firstChild: Text(
                                  task.description ?? '',
                                  style: context.textTheme.bodyMedium,
                                ),
                                secondChild: const SizedBox.shrink(),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              onDeleteTask != null
                  ? IconButton(
                      onPressed: () => onDeleteTask!(task.id),
                      icon: SvgPicture.asset(Assets.kIcTrashCan),
                    )
                  : IconButton(
                      onPressed: () => onToggleExpansion != null
                          ? onToggleExpansion!(task.id)
                          : null,
                      icon: SvgPicture.asset(Assets.kIcDots),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
