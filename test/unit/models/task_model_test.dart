import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:taski_to_do/models/task_model.dart';

void main() {
  setUpAll(() {
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(StatusAdapter());
  });

  group('Case sucess', () {
    test('Should create a [TaskModel] correctly', () {
      final task = TaskModel(
        id: '1',
        title: 'Task Test',
        description: 'Task Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      expect(task.id, '1');
      expect(task.title, 'Task Test');
      expect(task.description, 'Task Description');
      expect(task.status, Status.todo);
      expect(task.createdAt, '2024-01-30');
    });

    test('Should convert [TaskModel] to [JSON] correctly', () {
      final task = TaskModel(
        id: '1',
        title: 'Task Test',
        description: 'Task Description',
        status: Status.done,
        createdAt: '2024-01-30',
      );

      final json = task.toJson();

      expect(json, {
        'id': '1',
        'title': 'Task Test',
        'description': 'Task Description',
        'status': 'done',
        'createdAt': '2024-01-30',
      });
    });

    test('Should convert [JSON] to [TaskModel] correctly', () {
      final json = {
        'id': '1',
        'title': 'Task Test',
        'description': 'Task Description',
        'status': 'todo',
        'createdAt': '2024-01-30',
      };

      final task = TaskModel.fromJson(json);

      expect(task.id, '1');
      expect(task.title, 'Task Test');
      expect(task.description, 'Task Description');
      expect(task.status, Status.todo);
      expect(task.createdAt, '2024-01-30');
    });

    test('Should create a new [TaskModel] applying copyWith', () {
      final task = TaskModel(
        id: '1',
        title: 'Original Task',
        description: 'Original Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      final updatedTask = task.copyWith(
        title: 'Uptaded Task',
        status: Status.done,
      );

      expect(updatedTask.id, '1');
      expect(updatedTask.title, 'Uptaded Task');
      expect(updatedTask.description, 'Original Description');
      expect(updatedTask.status, Status.done);
      expect(updatedTask.createdAt, '2024-01-30');
    });

    test('Should save and retrieve a [TaskModel] from [Hive]', () async {
      await setUpTestHive();
      var box = await Hive.openBox<TaskModel>('test_tasks');

      final task = TaskModel(
        id: '1',
        title: 'Hive Task',
        description: 'Persistence Task',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      await box.put('1', task);

      final retrievedTask = box.get('1');

      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.id, '1');
      expect(retrievedTask.title, 'Hive Task');
      expect(retrievedTask.description, 'Persistence Task');
      expect(retrievedTask.status, Status.todo);
      expect(retrievedTask.createdAt, '2024-01-30');

      await box.close();
    });
  });
  group('Case failure', () {
    test('Should throw an [Error] when converting invalid JSON to TaskModel',
        () {
      final json = {
        'id': '1',
        'title': 'Task Test',
        'description': 'Task Description',
        'status': 'invalid_status',
        'createdAt': '2024-01-30',
      };

      expect(() => TaskModel.fromJson(json), throwsA(isA<ArgumentError>()));
    });

    test('Should throw an [Error] when JSON is missing required fields', () {
      final json = {
        'title': 'Task Test',
        'description': 'Task Description',
        'status': 'doing',
      };

      expect(() => TaskModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test(
        'Should throw an [Error] when retrieving a corrupted TaskModel from Hive',
        () async {
      await setUpTestHive();
      var box = await Hive.openBox('test_tasks');

      await box.put('1', {'invalid': 'data'});

      expect(() => box.get('1') as TaskModel, throwsA(isA<TypeError>()));

      await box.close();
    });
  });
}
