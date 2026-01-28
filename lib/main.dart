import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/features/tasks/model/task_model.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/dio_client.dart';
import 'features/auth/service/auth_service.dart';
import 'features/tasks/service/task_service.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/tasks/controller/task_controller.dart';
import 'features/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

    // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(TaskModelAdapter());


  // Initialize Services
  final storageService = StorageService();
  await storageService.init();

  final connectivityService = ConnectivityService();

  // Core Services
  final dioClient = DioClient(storageService);

  // Domain Services
  final authService = AuthService(dioClient);
  final taskService = TaskService(dioClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AuthController(authService, storageService)..checkLoginStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              TaskController(taskService, storageService, connectivityService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
