import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/dio_client.dart';
import '../model/task_model.dart';

class TaskService {
  final DioClient _dioClient;

  TaskService(this._dioClient);

  Future<(List<TaskModel>?, String?)> fetchTasks() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.tasks);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        final tasks = data.map((e) => TaskModel.fromJson(e)).toList();
        return (tasks, null);
      }
      debugPrint("failed to fetch data: ${response.statusCode}");
      return (null, '${response.statusCode} - failed to fetch data');
    } on DioException catch (e) {
      return (
        null,
        (e.response?.data['error'] ?? e.message ?? 'Unknown error').toString(),
      );
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<(TaskModel?, String?)> updateTask(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dioClient.dio.put(
        '${ApiConstants.tasks}/$id',
        data: data,
      );
      if (response.statusCode == 200) {
        final task = TaskModel.fromJson(response.data['data']);
        return (task, null);
      }
      return (null, '${response.statusCode} - failed to update task');
    } on DioException catch (e) {
      return (
        null,
        (e.response?.data['error'] ?? e.message ?? 'Unknown error').toString(),
      );
    } catch (e) {
      return (null, e.toString());
    }
  }
}
