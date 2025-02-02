import 'package:flutter/material.dart';

import '../core/enums/task_type.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;
  TaskViewModel(this._repository);

  List<TaskModel> _tasks = [];
  TaskState _state = TaskState.initial;

  final ValueNotifier<List<TaskModel>> _tasksNotifier = ValueNotifier([]);
  final ValueNotifier<Map<String, bool>> expandedTasks = ValueNotifier({});

  TaskState get state => _state;
  ValueNotifier<List<TaskModel>> get tasksNotifier => _tasksNotifier;
  List<TaskModel> get tasks => _tasksNotifier.value;

  void restartState() {
    _state = TaskState.initial;
  }

  Future<void> _execute(
      Future<void> Function() action, TaskState successState) async {
    _state = TaskState.loading;
    notifyListeners();

    try {
      await action();
      _state = successState;
    } catch (e) {
      _state = TaskState.error;
      rethrow;
    }

    notifyListeners();
  }

  Future<void> loadTasks() async {
    await _execute(() async {
      await Future.delayed(const Duration(milliseconds: 1000));
      _tasks = await _repository.getTasks();
      _tasks.sort((a, b) => a.status == Status.done ? 1 : -1);
      _tasksNotifier.value = List.from(_tasks);
    }, TaskState.loadSuccess);
  }

  Future<void> addTask(TaskModel task) async {
    await _execute(() async {
      try {
        await _repository.addTask(task);
        await loadTasks();
      } catch (e) {
        rethrow;
      }
    }, TaskState.createSuccess);
  }

  Future<void> updateTask(TaskModel task) async {
    await _execute(() async {
      try {
        await _repository.updateTask(task);
        await loadTasks();
      } catch (e) {
        rethrow;
      }
    }, TaskState.loadSuccess);
  }

  Future<void> deleteTask(String id) async {
    await _execute(() async {
      try {
        await _repository.deleteTask(id);
        await loadTasks();
      } catch (e) {
        rethrow;
      }
    }, TaskState.loadSuccess);
  }

  Future<void> deleteAllTasks() async {
    await _execute(() async {
      final doneTasks =
          _tasks.where((task) => task.status == Status.done).toList();
      for (var task in doneTasks) {
        await _repository.deleteTask(task.id);
      }
      await loadTasks();
    }, TaskState.loadSuccess);
  }

  Future<TaskModel?> getTaskById(String id) async {
    TaskModel? task;
    await _execute(() async {
      await Future.delayed(const Duration(milliseconds: 1000));
      task = await _repository.getTaskById(id);
      if (task != null) {
        _tasksNotifier.value = [task!];
      }
    }, TaskState.filterSuccess);

    return task;
  }

  Future<void> getTasksByStatus(Status status) async {
    await _execute(() async {
      await Future.delayed(const Duration(milliseconds: 1000));
      var filteredTasks = await _repository.getTasks();
      filteredTasks =
          filteredTasks.where((task) => task.status == status).toList();
      _tasksNotifier.value = List.from(filteredTasks);
    }, TaskState.filterSuccess);
  }

  Future<void> getTasksByTitle(String title) async {
    await _execute(() async {
      await Future.delayed(const Duration(milliseconds: 1000));
      var filteredTasks = await _repository.getTasks();
      filteredTasks = filteredTasks
          .where(
              (task) => task.title.toLowerCase().contains(title.toLowerCase()))
          .toList();
      _tasksNotifier.value = List.from(filteredTasks);
    }, title.isEmpty ? TaskState.initial : TaskState.filterSuccess);
  }

  void toggleTaskExpansion(String taskId) {
    expandedTasks.value = {
      ...expandedTasks.value,
      taskId: !(expandedTasks.value[taskId] ?? false),
    };
  }
}
