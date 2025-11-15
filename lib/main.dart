import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/home_page.dart';
import 'package:todo_app/create_todo_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/create-todo', page: () => CreateTodoPage()),
      ],
      theme: ThemeData(
        primarySwatch: Colors.yellow, // Works with Material 2
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow, // Ensures Material 3 color application
          primary: Colors.yellow, // Explicit primary color
          secondary: Colors.black, // Custom secondary color
        ),
        useMaterial3: true, // Ensuring Material 3 usage
      ),
    );
  }
}
