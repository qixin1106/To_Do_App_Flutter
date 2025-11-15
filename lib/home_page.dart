import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/todo_tile_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TodoController _controller = Get.put(TodoController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text('TO DO'),
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();
              _controller.searchQuery.value = '';
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/create-todo'),
        backgroundColor: Colors.yellow,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => _controller.searchQuery.value = value,
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredTodos = _controller.filteredTodos;
              if (filteredTodos.isEmpty) {
                return Center(
                  child: Text(
                    _controller.searchQuery.value.isEmpty ? 'No tasks yet' : 'No matching tasks',
                    style: TextStyle(fontSize: 18.0),
                  ),
                );
              }
              return ListView.builder(
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  final createdAt = DateTime.fromMillisecondsSinceEpoch(todo['createdAt']);
                  return TodoTilePage(
                    taskName: todo['name'],
                    taskDone: todo['done'],
                    createdAt: createdAt,
                    onChanged: (value) => _controller.toggleTodo(index),
                    deleteButton: (context) => _controller.deleteTodo(index),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
