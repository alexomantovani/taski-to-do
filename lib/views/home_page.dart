import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/navigation_provider.dart';
import '../core/services/persistent_home.dart';
import '../core/services/styles.dart';
import '../widgets/actions_widget.dart';
import '../widgets/leading_widget.dart';
import '../widgets/task_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      backgroundColor: Styles.kStandardWhite,
      appBar: AppBar(
        backgroundColor: Styles.kStandardWhite,
        automaticallyImplyLeading: false,
        leading: LeadingWidget(),
        leadingWidth: context.width * 0.25,
        actions: [ActionsWidget()],
      ),
      body: PersistentHome.pages[navigationProvider.currentIndex],
      bottomNavigationBar: TaskNavigationBar(
        onTap: (value) {
          if (value == 2) {
            context.taskViewModel.restartState();
          }
          navigationProvider.setCurrentIndex(value);
        },
      ),
    );
  }
}
