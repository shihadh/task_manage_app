import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _tasksBox = 'tasks_box';
  static const String _syncQueueBox = 'sync_queue';

  Future<void> init() async {
    print("StorageService: initializing Hive...");
    await Hive.initFlutter();

    print("StorageService: opening boxes...");
    // We store Map<dynamic, dynamic> to avoid TypeAdapter issues
    await Hive.openBox(_tasksBox);
    await Hive.openBox(_syncQueueBox);
    print("StorageService: Hive initialized successfully.");
  }

  // Auth Token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // User Data
  Future<void> saveUser(String userJson) async {
    await _secureStorage.write(key: _userKey, value: userJson);
  }

  Future<String?> getUser() async {
    return await _secureStorage.read(key: _userKey);
  }

  Future<void> deleteUser() async {
    await _secureStorage.delete(key: _userKey);
  }

  // Hive - Tasks
  Box get taskBox => Hive.box(_tasksBox);
  Box get syncQueueBox => Hive.box(_syncQueueBox);
}
