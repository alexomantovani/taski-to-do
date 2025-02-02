import 'package:flutter/material.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/styles.dart';

class TaskErrorWidget extends StatelessWidget {
  const TaskErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error on Loading Tasks',
        style: context.textTheme.labelLarge!.copyWith(
          color: Styles.kPrimaryDelete,
        ),
      ),
    );
  }
}
