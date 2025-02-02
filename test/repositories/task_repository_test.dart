import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:taski_to_do/models/task_model.dart';
import 'package:taski_to_do/repositories/task_repository.dart';

void main() {
  late Box<TaskModel> taskBox;
  late TaskRepository taskRepository;

  setUpAll(() {
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(StatusAdapter());
  });

  setUp(() async {
    await setUpTestHive();
    taskBox = await Hive.openBox<TaskModel>('test_tasks');
    taskRepository = TaskRepository(taskBox);
  });

  tearDown(() async {
    await taskBox.clear();
    await taskBox.close();
  });

  group('Case success', () {
    test('Should add a new [TaskModel] to [Hive]', () async {
      final task = TaskModel(
        id: '1',
        title: 'New Task',
        description: 'Task Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      await taskRepository.addTask(task);
      final retrievedTask = await taskRepository.getTaskById('1');

      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.id, '1');
      expect(retrievedTask.title, 'New Task');
      expect(retrievedTask.status, Status.todo);
    });

    test('Should get all saved Tasks', () async {
      await taskRepository.addTask(TaskModel(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        status: Status.todo,
        createdAt: '2024-01-30',
      ));

      await taskRepository.addTask(TaskModel(
        id: '2',
        title: 'Task 2',
        description: 'Description 2',
        status: Status.todo,
        createdAt: '2024-01-30',
      ));

      final tasks = await taskRepository.getTasks();

      expect(tasks.length, 2);
      expect(tasks[0].id, '1');
      expect(tasks[1].id, '2');
    });

    test('Should update an existing Task', () async {
      final task = TaskModel(
        id: '1',
        title: 'Original Task',
        description: 'Original Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      await taskRepository.addTask(task);

      final updatedTask = task.copyWith(
        title: 'Updated Task',
        status: Status.done,
      );

      await taskRepository.updateTask(updatedTask);
      final retrievedTask = await taskRepository.getTaskById('1');

      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.title, 'Updated Task');
      expect(retrievedTask.status, Status.done);
    });

    test('Should delete a Task by ID', () async {
      final task = TaskModel(
        id: '1',
        title: 'Task to delete',
        description: 'Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      await taskRepository.addTask(task);
      await taskRepository.deleteTask('1');

      final retrievedTask = await taskRepository.getTaskById('1');

      expect(retrievedTask, isNull);
      expect((await taskRepository.getTasks()).isEmpty, true);
    });

    test('Should delete all saved Tasks', () async {
      await taskRepository.addTask(TaskModel(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        status: Status.todo,
        createdAt: '2024-01-30',
      ));

      await taskRepository.addTask(TaskModel(
        id: '2',
        title: 'Task 2',
        description: 'Description 2',
        status: Status.done,
        createdAt: '2024-01-30',
      ));

      expect((await taskRepository.getTasks()).length, 2);

      await taskRepository.deleteAllTasks();

      expect((await taskRepository.getTasks()).isEmpty, true);
    });
  });

  group('Case failure', () {
    test('Should not add a Task with a duplicate ID', () async {
      final task1 = TaskModel(
        id: '1',
        title: 'Task 1',
        description: 'Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      final task2 = TaskModel(
        id: '1',
        title: 'Task 2',
        description: 'Different Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      await taskRepository.addTask(task1);

      expect(() => taskRepository.addTask(task2), throwsA(isA<Exception>()));
    });

    test('Should throw an [Exception] when updating a non-existing Task',
        () async {
      final updatedTask = TaskModel(
        id: '999',
        title: 'Updated Task',
        description: 'Updated Description',
        status: Status.done,
        createdAt: '2024-01-30',
      );

      expect(() => taskRepository.updateTask(updatedTask),
          throwsA(isA<Exception>()));
    });

    test('Should throw an [Exception] when deleting a non-existing Task',
        () async {
      expect(() => taskRepository.deleteTask('99'), throwsA(isA<Exception>()));
    });

    test('Should return [null] when getting a Task that does not exist',
        () async {
      final retrievedTask = await taskRepository.getTaskById('999');
      expect(retrievedTask, isNull);
    });

    test('Should not fail when deleting all Tasks from an empty database',
        () async {
      await taskRepository.deleteAllTasks();

      expect((await taskRepository.getTasks()).isEmpty, true);
    });
  });
}
