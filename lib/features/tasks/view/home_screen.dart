import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/tasks/widgets/premium_fab.dart';
import 'package:task_manager/features/tasks/widgets/stat_card.dart';
import 'package:task_manager/features/tasks/widgets/sync_status_bar.dart';
import 'package:task_manager/features/tasks/widgets/task_tile_widgets.dart';
import '../controller/task_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../core/constants/text_const.dart';
import '../../../core/theme/color_const.dart';
import '../../auth/view/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient and Shapes (Matching App Theme)
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
            left: -50,
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
            bottom: 200,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2575FC).withOpacity(0.15),
              ),
            ),
          ),

          // Main Scroll Content
          Consumer<TaskController>(
            builder: (context, controller, _) {
              final pendingCount = controller.tasks
                  .where((t) => !t.isCompleted)
                  .length;
              final completedCount = controller.tasks.length - pendingCount;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Premium Floating App Bar
                      SliverAppBar(
                        expandedHeight: 240.0,
                        floating: false,
                        pinned: true,
                        stretch: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          stretchModes: const [
                            StretchMode.blurBackground,
                            StretchMode.zoomBackground,
                          ],
                          background: Container(
                            padding: const EdgeInsets.only(
                              top: 60,
                              left: 24,
                              right: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat(
                                            'EEEE, MMM d',
                                          ).format(DateTime.now()),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.6,
                                            ),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const Text(
                                          'Dashboard',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: ColorConst.white.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white24,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.logout_rounded,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => _handleLogout(context),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                // Quick Stats Row
                                Row(
                                  children: [
                                    StatCard(
                                      label: 'Pending',
                                      count: pendingCount,
                                      icon: Icons.pending_actions_rounded,
                                      color: Colors.orangeAccent,
                                    ),
                                    const SizedBox(width: 16),
                                    StatCard(
                                      label: 'Completed',
                                      count: completedCount,
                                      icon: Icons.task_alt_rounded,
                                      color: Colors.greenAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Sync Status
                      if (controller.lastSyncedAt != null ||
                          controller.errorMessage != null)
                        SliverToBoxAdapter(
                          child: SyncStatusBar(controller: controller),
                        ),

                      // Task Header
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'YOUR TASKS',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),

                      // Tasks Logic
                      if (controller.isLoading && controller.tasks.isEmpty)
                        const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      else if (controller.tasks.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.auto_graph_rounded,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  TextConst.home['noTasks']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverToBoxAdapter(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.tasks.length,
                            itemBuilder: (context, index) {
                              final task = controller.tasks[index];
                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                  milliseconds: 300 + (index * 50),
                                ),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: TaskTile(task: task),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: PremiumFab(),
    );
  }

  void _handleLogout(BuildContext context) {
    context.read<AuthController>().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
