import 'package:hive/hive.dart';

import '../models/task_model.dart';

class TaskRepository {
  final Box<TaskModel> _taskBox;
  TaskRepository(this._taskBox);

  Future<void> addTask(TaskModel task) async {
    if (_taskBox.containsKey(task.id)) {
      throw Exception('Task with ID ${task.id} already exists');
    }
    await _taskBox.put(task.id, task);
  }

  Future<List<TaskModel>> getTasks() async {
    return Future.value(_taskBox.values.toList());
  }

  Future<void> updateTask(TaskModel task) async {
    if (!_taskBox.containsKey(task.id)) {
      throw Exception('Task with ID ${task.id} not found');
    }
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    if (!_taskBox.containsKey(id)) {
      throw Exception('Task with ID $id not found');
    }
    await _taskBox.delete(id);
  }

  Future<void> deleteAllTasks() async {
    await _taskBox.clear();
  }

  Future<TaskModel?> getTaskById(String id) async {
    return _taskBox.get(id);
  }
}
