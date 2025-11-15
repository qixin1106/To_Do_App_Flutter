import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTilePage extends StatelessWidget {
  final String taskName;
  final bool taskDone;
  final DateTime createdAt;
  final Function(bool?)? onChanged;
  Function(BuildContext)? deleteButton;

  TodoTilePage({
    super.key,
    required this.taskName,
    required this.taskDone,
    required this.createdAt,
    required this.onChanged,
    required this.deleteButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteButton,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // checkbox
                  Checkbox(
                    value: taskDone,
                    onChanged: onChanged,
                    activeColor: Colors.black,
                  ),
                  // task name
                  Expanded(
                    child: Text(
                      taskName,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        decoration: taskDone ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              // creation time
              Text(
                'Created: ${createdAt.month}/${createdAt.day}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
