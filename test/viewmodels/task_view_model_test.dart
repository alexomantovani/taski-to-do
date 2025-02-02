import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taski_to_do/models/task_model.dart';
import 'package:taski_to_do/repositories/task_repository.dart';
import 'package:taski_to_do/viewmodels/task_view_model.dart';

import 'task_view_model_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository mockRepository;
  late TaskViewModel taskViewModel;

  setUp(() {
    mockRepository = MockTaskRepository();
    taskViewModel = TaskViewModel(mockRepository);
  });

  group('Case success', () {
    test('Should load Tasks correctly', () async {
      final tasks = [
        TaskModel(
          id: '1',
          title: 'Task 1',
          description: 'Description 1',
          status: Status.todo,
          createdAt: '2024-01-30',
        ),
        TaskModel(
          id: '2',
          title: 'Task 2',
          description: 'Description 2',
          status: Status.todo,
          createdAt: '2024-01-30',
        ),
      ];

      when(mockRepository.getTasks()).thenAnswer((_) async => tasks);

      await taskViewModel.loadTasks();

      expect(taskViewModel.tasks.length, 2);
      expect(taskViewModel.tasks.first.id, '1');
      expect(taskViewModel.tasks.last.id, '2');
    });

    test('Should add a new Task and update the current List', () async {
      final task = TaskModel(
        id: '3',
        title: 'New Task',
        description: 'Description',
        status: Status.done,
        createdAt: '2024-01-30',
      );

      when(mockRepository.addTask(task)).thenAnswer((_) async {});
      when(mockRepository.getTasks()).thenAnswer((_) async => [task]);

      await taskViewModel.addTask(task);

      expect(taskViewModel.tasks.length, 1);
      expect(taskViewModel.tasks.first.id, '3');
      verify(mockRepository.addTask(task)).called(1);
    });

    test('Should update a Task and reflect in the current List', () async {
      final originalTask = TaskModel(
        id: '1',
        title: 'Task',
        description: 'Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      final updatedTask = originalTask.copyWith(
        title: 'Updated Task',
        status: Status.done,
      );

      when(mockRepository.updateTask(updatedTask)).thenAnswer((_) async {});
      when(mockRepository.getTasks()).thenAnswer((_) async => [updatedTask]);

      await taskViewModel.updateTask(updatedTask);

      expect(taskViewModel.tasks.length, 1);
      expect(taskViewModel.tasks.first.title, 'Updated Task');
      expect(taskViewModel.tasks.first.status, Status.done);
      verify(mockRepository.updateTask(updatedTask)).called(1);
    });

    test('Should delete a Task and remove from the current List', () async {
      final task = TaskModel(
        id: '1',
        title: 'Task',
        description: 'Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      when(mockRepository.deleteTask(task.id)).thenAnswer((_) async {});
      when(mockRepository.getTasks()).thenAnswer((_) async => []);

      await taskViewModel.deleteTask('1');

      expect(taskViewModel.tasks.isEmpty, true);
      verify(mockRepository.deleteTask('1')).called(1);
    });

    test('Should delete all Tasks and clear the current List', () async {
      when(mockRepository.getTasks()).thenAnswer((_) async => []);
      when(mockRepository.deleteAllTasks()).thenAnswer((_) async {});

      await taskViewModel.deleteAllTasks();

      expect(taskViewModel.tasks.isEmpty, true);
      verifyNever(mockRepository.deleteAllTasks());
    });

    test('Should get a Task by its ID', () async {
      final task = TaskModel(
        id: '1',
        title: 'Task',
        description: 'Description',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      when(mockRepository.getTaskById('1')).thenAnswer((_) async => task);

      final retrievedTask = await taskViewModel.getTaskById('1');

      expect(retrievedTask, isNotNull);
      expect(retrievedTask!.id, '1');
    });

    test('Should filter Tasks by Status', () async {
      final tasks = [
        TaskModel(
            id: '1',
            title: 'Task 1',
            status: Status.todo,
            createdAt: '2024-01-30'),
        TaskModel(
            id: '2',
            title: 'Task 2',
            status: Status.todo,
            createdAt: '2024-01-30'),
        TaskModel(
            id: '3',
            title: 'Task 3',
            status: Status.done,
            createdAt: '2024-01-30'),
      ];

      when(mockRepository.getTasks()).thenAnswer((_) async => tasks);
      await taskViewModel.getTasksByStatus(Status.todo);

      expect(taskViewModel.tasks.length, 2);
      expect(taskViewModel.tasks.first.status, Status.todo);
    });
  });

  group('Case failure', () {
    test('Should throw an Error when adding a Task with a duplicate ID',
        () async {
      final task = TaskModel(
        id: '1',
        title: 'Task 1',
        status: Status.todo,
        createdAt: '2024-01-30',
      );

      when(mockRepository.addTask(task))
          .thenThrow(Exception('Task with ID 1 already exists'));

      expect(
        () async => await taskViewModel.addTask(task),
        throwsA(isA<Exception>()),
      );
    });

    test('Should throw an Error when updating a non-existing Task', () async {
      final updatedTask = TaskModel(
        id: '99',
        title: 'Updated Task',
        status: Status.done,
        createdAt: '2024-01-30',
      );

      when(mockRepository.updateTask(updatedTask))
          .thenThrow(Exception('Task with ID 99 not found'));

      expect(
        () async => await taskViewModel.updateTask(updatedTask),
        throwsA(isA<Exception>()),
      );
    });

    test('Should throw an Error when deleting a non-existing Task', () async {
      when(mockRepository.deleteTask('99'))
          .thenThrow(Exception('Task with ID 99 not found'));

      expect(
        () async => await taskViewModel.deleteTask('99'),
        throwsA(isA<Exception>()),
      );
    });

    test('Should return null when getting a non-existing Task', () async {
      when(mockRepository.getTaskById('99')).thenAnswer((_) async => null);

      final retrievedTask = await taskViewModel.getTaskById('99');

      expect(retrievedTask, isNull);
    });
  });
}
