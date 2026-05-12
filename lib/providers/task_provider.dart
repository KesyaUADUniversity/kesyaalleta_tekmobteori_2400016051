import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Map<String, dynamic>> _informalNotes = [];
  bool _isDarkMode = false;

  List<Task> get tasks => _tasks;
  List<Map<String, dynamic>> get informalNotes => _informalNotes;
  bool get isDarkMode => _isDarkMode;

  List<Task> get formalTasks => _tasks.where((t) => t.isFormal).toList();
  List<Task> get informalTasks => _tasks.where((t) => !t.isFormal).toList();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  void addInformalNote(String note, bool completed) {
    _informalNotes.add({
      'note': note,
      'completed': completed,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    notifyListeners();
  }

  void toggleNoteStatus(String id) {
    final index = _informalNotes.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _informalNotes[index]['completed'] = 
          !_informalNotes[index]['completed'];
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _informalNotes.removeWhere((n) => n['id'] == id);
    notifyListeners();
  }
}