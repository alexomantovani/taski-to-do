import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/services/navigation_provider.dart';
import 'core/services/styles.dart';
import 'models/task_model.dart';
import 'repositories/task_repository.dart';
import 'viewmodels/task_view_model.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(StatusAdapter());

  final taskBox = await Hive.openBox<TaskModel>('tasks');
  final taskRepository = TaskRepository(taskBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(taskRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Styles.kPrimaryBlue),
        useMaterial3: true,
        textTheme: TextTheme(
          titleLarge: Styles.titleLarge,
          titleMedium: Styles.titleMedium,
          titleSmall: Styles.titleSmall,
          bodyMedium: Styles.bodyMedium,
          bodySmall: Styles.bodySmall,
        ),
      ),
      home: const HomePage(),
    );
  }
}
