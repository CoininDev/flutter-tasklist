import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testeflutter/controllers/task.dart';
import 'package:testeflutter/views/home_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  await WindowManager.instance.setSize(Size(800, 600));
  await WindowManager.instance.setMinimumSize(Size(220, 220));
  var tasksCtrl = TasksController();
  await tasksCtrl.loadTasks();

  runApp(
    ChangeNotifierProvider(create: (_) => tasksCtrl, child: TodoListApp()),
  );
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
