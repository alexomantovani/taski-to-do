import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../core/enums/view_type.dart';
import '../core/extensions/context_ext.dart';
import '../core/services/assets.dart';
import '../core/services/navigation_provider.dart';
import '../core/services/styles.dart';
import 'label_header.dart';

class EmptyTasks extends StatelessWidget {
  const EmptyTasks({
    super.key,
    this.type = ViewType.todo,
  });

  final ViewType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        type == ViewType.todo || type == ViewType.create
            ? LabelHeader()
            : const SizedBox.shrink(),
        const Spacer(),
        Center(
          child: Column(
            children: [
              SvgPicture.asset(Assets.kIcEmptyBoard),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  type == ViewType.todo
                      ? 'You have no task listed.'
                      : 'No results found.',
                  style: context.textTheme.bodyMedium,
                ),
              ),
              type == ViewType.todo
                  ? GestureDetector(
                      onTap: () => Provider.of<NavigationProvider>(context,
                              listen: false)
                          .setCurrentIndex(1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Styles.kPrimaryBlueWithOpacity,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Styles.kPrimaryBlue,
                            ),
                            const SizedBox(width: 14.0),
                            Text(
                              'Create Task',
                              style: context.textTheme.titleMedium!
                                  .copyWith(color: Styles.kPrimaryBlue),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
