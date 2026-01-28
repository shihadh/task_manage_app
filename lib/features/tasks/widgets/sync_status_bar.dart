import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/tasks/controller/task_controller.dart';

class SyncStatusBar extends StatelessWidget {
  final TaskController controller;

  const SyncStatusBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isError = controller.errorMessage != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: (isError ? Colors.redAccent : Colors.greenAccent)
                .withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (isError ? Colors.redAccent : Colors.greenAccent)
                  .withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isError ? Icons.bolt_rounded : Icons.cloud_done_rounded,
                size: 18,
                color: isError ? Colors.redAccent : Colors.greenAccent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  controller.errorMessage ??
                      'Last synced at ${DateFormat('hh:mm a').format(controller.lastSyncedAt!)}',
                  style: TextStyle(
                    color: (isError ? Colors.redAccent : Colors.greenAccent)
                        .withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ),
                onPressed: controller.fetchTasks,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
