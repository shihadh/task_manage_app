import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:task_manager/features/tasks/model/task_model.dart';
import 'package:task_manager/features/tasks/view/task_detail_screen.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(task: task),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Animated Checkbox Circle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: task.isCompleted
                              ? Colors.greenAccent.withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: task.isCompleted
                                ? Colors.greenAccent.withOpacity(0.5)
                                : Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: task.isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: Colors.greenAccent,
                              )
                            : null,
                      ),
                      const SizedBox(width: 20),

                      // Task Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: task.isCompleted
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Navigation Icon
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
