import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testeflutter/models/task.dart';

class TasksController extends ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Map<int, TaskModel> _models = {};
  Map<int, TaskModel> get tasks => _models;
  String _query = "";
  String get query => _query;

  Future<void> loadTasks() async {
    String? storedTasks = await _storage.read(key: 'tasks');
    if (storedTasks != null) {
      List<dynamic> taskList = jsonDecode(storedTasks);
      for (var taskJson in taskList) {
        TaskModel task = TaskModel.fromJson(taskJson);
        _models[task.name.hashCode] = task;
      }
    }
  }

  Future<void> _saveTasks() async {
    List<Map<String, dynamic>> taskList =
        _models.values.map((task) => task.toJson()).toList();
    String jsonTasks = jsonEncode(taskList);
    await _storage.write(key: 'tasks', value: jsonTasks);
  }

  void addTask(String name) {
    int id = name.hashCode;

    if (_models.containsKey(id)) {
      _setTask(id, false);
      return;
    }

    TaskModel task = TaskModel(name: name, done: false);

    _models[id] = task;

    _saveTasks();
    notifyListeners();
  }

  Map<int, TaskModel> searchTasks() {
    if (_query.isEmpty) {
      return _models;
    }

    Map<int, TaskModel> filteredTasks = {};
    _models.forEach((taskid, task) {
      if (task.name.toLowerCase().contains(_query.toLowerCase())) {
        filteredTasks[taskid] = task;
      }
    });
    return filteredTasks;
  }

  void updateQuery(String val) {
    _query = val;
    notifyListeners();
  }

  void delTask(int id) {
    _models.removeWhere((taskname, task) {
      return taskname == id;
    });
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(int id) {
    TaskModel? task = _models[id];
    if (task != null) {
      task.done = !task.done;
      _saveTasks();
      notifyListeners();
    }
  }

  void _setTask(int id, bool set) {
    TaskModel? task = _models[id];

    if (task != null) {
      task.done = set;
      _saveTasks();
      notifyListeners();
    }
  }
}
