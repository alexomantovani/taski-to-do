import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/task_view_model.dart';
import '../services/navigation_provider.dart';

extension ContextExt on BuildContext {
  TextTheme get textTheme => TextTheme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get width => size.width;

  double get height => size.height;

  TaskViewModel get taskViewModel => read<TaskViewModel>();

  NavigationProvider get navigationProvider =>
      Provider.of<NavigationProvider>(this, listen: false);

  initTasks() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await taskViewModel.loadTasks();
    });
  }
}
