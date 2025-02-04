import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:taski_to_do/core/enums/task_type.dart';
import 'package:taski_to_do/core/services/assets.dart';
import 'package:taski_to_do/core/services/navigation_provider.dart';
import 'package:taski_to_do/models/task_model.dart';
import 'package:taski_to_do/viewmodels/task_view_model.dart';
import 'package:taski_to_do/views/createtask/views/create_task_page.dart';
import 'package:taski_to_do/views/home_page.dart';

import 'home_page_test.mocks.dart';

@GenerateMocks([TaskViewModel])
void main() {
  late MockTaskViewModel mockTaskViewModel;

  setUp(() {
    mockTaskViewModel = MockTaskViewModel();

    when(mockTaskViewModel.state).thenReturn(TaskState.loadSuccess);
    when(mockTaskViewModel.tasks).thenReturn([]);

    final tasksNotifier = ValueNotifier<List<TaskModel>>([]);
    when(mockTaskViewModel.tasksNotifier).thenReturn(tasksNotifier);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskViewModel>.value(value: mockTaskViewModel),
        ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider()),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  testWidgets("Checks whether the main elements of the HomePage are rendered",
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets(
      'Checks that when clicking the create button, the modal is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();

    final createTaskPage = find.byType(CreateTaskPage);
    expect(createTaskPage, findsOneWidget);
  });

  testWidgets(
      'Checks if navigation in the BottomNavigationBar changes the screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    final bottomNav = find.byType(BottomNavigationBar);
    expect(bottomNav, findsOneWidget);

    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.toString().contains(Assets.kIcCreate),
      ),
    );

    await tester.pumpAndSettle();

    final createTaskPage = find.byType(CreateTaskPage);
    expect(createTaskPage, findsOneWidget);
  });
}
