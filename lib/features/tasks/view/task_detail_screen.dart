import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/task_controller.dart';
import '../model/task_model.dart';
import '../../../core/theme/color_const.dart';
import '../../../core/constants/text_const.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().initializeDetail(widget.task);
    });
  }

  Future<void> _onSave() async {
    final taskController = context.read<TaskController>();
    final success = await taskController.saveTaskUpdate(widget.task.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            TextConst.detail['saveSuccess'] ?? 'Task updated successfully',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.greenAccent.withOpacity(0.8),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          TextConst.detail['title'] ?? 'Task Details',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient and Shapes
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E),
                ],
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6A11CB).withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2575FC).withOpacity(0.15),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Consumer<TaskController>(
              builder: (context, controller, child) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Glassmorphism Card for Content
                          ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 15.0,
                                sigmaY: 15.0,
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: ColorConst.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: ColorConst.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Status Header
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildStatusBadge(
                                          controller.isCompletedDetail
                                              ? 'COMPLETED'
                                              : 'IN PROGRESS',
                                          controller.isCompletedDetail
                                              ? Colors.greenAccent
                                              : Colors.orangeAccent,
                                        ),
                                        if (!widget.task.isSynced)
                                          const Icon(
                                            Icons.sync_problem_rounded,
                                            color: Colors.orangeAccent,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),

                                    // Title & Description
                                    Text(
                                      widget.task.title,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      widget.task.description,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.7),
                                        height: 1.5,
                                      ),
                                    ),
                                    const Divider(
                                      height: 48,
                                      color: Colors.white24,
                                    ),

                                    // Interactive Section
                                    Text(
                                      (TextConst.detail['remarksLabel'] ??
                                              'REMARKS')
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.5),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: controller.remarksController,
                                      maxLines: 4,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        hintText:
                                            TextConst.detail['remarksHint'] ??
                                            'Add your remarks here...',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.05,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        TextConst.detail['markCompleted'] ??
                                            "Mark as Completed",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      value: controller.isCompletedDetail,
                                      activeColor: const Color(0xFF6A11CB),
                                      checkColor: Colors.white,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      onChanged: (val) {
                                        controller.setCompletedDetail(
                                          val ?? false,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 40),

                                    // Save Button
                                    Container(
                                      height: 56,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          colors: controller.isUpdating
                                              ? [
                                                  Colors.grey.withOpacity(0.3),
                                                  Colors.grey.withOpacity(0.3),
                                                ]
                                              : [
                                                  const Color(0xFF6A11CB),
                                                  const Color(0xFF2575FC),
                                                ],
                                        ),
                                        boxShadow: controller.isUpdating
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF6A11CB,
                                                  ).withOpacity(0.3),
                                                  blurRadius: 15,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: controller.isUpdating
                                            ? null
                                            : _onSave,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: controller.isUpdating
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Text(
                                                (TextConst.detail['saveButton'] ??
                                                        'SAVE CHANGES')
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
