import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  bool isCompleted;
  @HiveField(4)
  String remarks;
  @HiveField(5)
  String updatedAt;
  @HiveField(6)
  bool isSynced; // Local flag for offline updates

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.remarks,
    required this.updatedAt,
    this.isSynced = true,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      remarks: json['remarks'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      isSynced: json['isSynced'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'remarks': remarks,
      'updatedAt': updatedAt,
      'isSynced': isSynced,
    };
  }

  TaskModel copyWith({bool? isCompleted, String? remarks, bool? isSynced}) {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      remarks: remarks ?? this.remarks,
      updatedAt: DateTime.now().toIso8601String(),
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
