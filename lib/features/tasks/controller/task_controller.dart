import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../service/task_service.dart';
import '../model/task_model.dart';

class TaskController with ChangeNotifier {
  final TaskService _taskService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService;

  final TextEditingController remarksController = TextEditingController();
  bool _isCompletedDetail = false;
  bool _isUpdating = false;

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastSyncedAt;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  bool get isCompletedDetail => _isCompletedDetail;
  String? get errorMessage => _errorMessage;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  TaskController(
    this._taskService,
    this._storageService,
    this._connectivityService,
  ) {
    _loadLocalTasks();
    _connectivityService.connectionStatus.listen((isConnected) {
      if (isConnected) {
    syncOfflineUpdates();
    _lastSyncedAt = DateTime.now();
    notifyListeners();
  }

    });
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  void setCompletedDetail(bool val) {
    _isCompletedDetail = val;
    notifyListeners();
  }

  void initializeDetail(TaskModel task) {
    remarksController.text = task.remarks;
    _isCompletedDetail = task.isCompleted;
    notifyListeners();
  }

  void _loadLocalTasks() {
    final box = _storageService.taskBox;
    _tasks = box.values.map((data) {
      final Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);
      return TaskModel.fromJson(json);
    }).toList();
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    // Basic offline check first
    if (!await _connectivityService.checkConnection()) {
      _loadLocalTasks();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final (data, error) = await _taskService.fetchTasks();

    if (error != null) {
      _errorMessage = error;
      _loadLocalTasks(); // Fallback to local on error
    } else {
      final fetchedTasks = data ?? [];

      // Update local storage
      final box = _storageService.taskBox;
      await box.clear();
      for (var task in fetchedTasks) {
        await box.put(task.id, task.toJson());
      }

      _tasks = fetchedTasks;
      _lastSyncedAt = DateTime.now();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveTaskUpdate(int taskId) async {
    _isUpdating = true;
    notifyListeners();

    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) {
      _isUpdating = false;
      notifyListeners();
      return false;
    }

    final updatedLocalTask = _tasks[index].copyWith(
      isCompleted: _isCompletedDetail,
      remarks: remarksController.text,
      isSynced: false,
    );

    //  Always update locally first
    _tasks[index] = updatedLocalTask;
    await _storageService.taskBox.put(taskId, updatedLocalTask.toJson());
    notifyListeners();

    // Try syncing if online
    if (await _connectivityService.checkConnection()) {
      final (_, error) = await _taskService.updateTask(taskId, {
        'isCompleted': updatedLocalTask.isCompleted,
        'remarks': updatedLocalTask.remarks,
      });

      if (error == null) {
        final syncedTask = updatedLocalTask.copyWith(isSynced: true);
        _tasks[index] = syncedTask;
        await _storageService.taskBox.put(taskId, syncedTask.toJson());
        notifyListeners();
      }
    }

    _isUpdating = false;
    notifyListeners();
    return true;
  }

  Future<void> syncOfflineUpdates() async {
    final box = _storageService.taskBox;
    final unsyncedTasks = box.values
        .map((data) {
          final Map<String, dynamic> json = Map<String, dynamic>.from(
            data as Map,
          );
          return TaskModel.fromJson(json);
        })
        .where((t) => !t.isSynced)
        .toList();

    for (var task in unsyncedTasks) {
      final (updatedTask, error) = await _taskService.updateTask(task.id, {
        'isCompleted': task.isCompleted,
        'remarks': task.remarks,
      });

      if (error == null) {
        final syncedTask = task.copyWith(isSynced: true);
        await box.put(task.id, syncedTask.toJson());
      }
    }

    if (unsyncedTasks.isNotEmpty) {
      _loadLocalTasks();
    }
  }
}
