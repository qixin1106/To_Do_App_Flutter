import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoController extends GetxController {
  static TodoController get to => Get.find();
  final _box = Hive.box('mybox');
  RxList todoList = [].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (_box.get('TODOLIST') == null) {
      createInitialData();
    } else {
      loadData();
    }
  }

  void createInitialData() {
    todoList.value = [
      {
        'name': 'Code App',
        'done': false,
        'createdAt': DateTime.now().millisecondsSinceEpoch
      },
      {
        'name': 'Do Exercise',
        'done': false,
        'createdAt': DateTime.now().millisecondsSinceEpoch
      },
    ];
    updateDatabase();
  }

  void loadData() {
    List loadedData = _box.get('TODOLIST') ?? [];
    // Migrate old data format to new one with timestamps
    todoList.value = loadedData.map((item) {
      if (item is List) {
        // Old format: [name, done]
        return {
          'name': item[0],
          'done': item[1],
          'createdAt': DateTime.now().millisecondsSinceEpoch
        };
      } else {
        // New format: Map
        return item;
      }
    }).toList();
    // Sort by creation time (descending)
    todoList.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
  }

  void updateDatabase() {
    _box.put('TODOLIST', todoList);
  }

  void addTodo(String name) {
    todoList.add({
      'name': name,
      'done': false,
      'createdAt': DateTime.now().millisecondsSinceEpoch
    });
    // Re-sort after adding new item
    todoList.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
    updateDatabase();
  }

  void toggleTodo(int index) {
    todoList[index]['done'] = !todoList[index]['done'];
    updateDatabase();
  }

  void deleteTodo(int index) {
    todoList.removeAt(index);
    updateDatabase();
  }

  List<Map> get filteredTodos => todoList
      .where((todo) => todo['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase()))
      .toList();
}