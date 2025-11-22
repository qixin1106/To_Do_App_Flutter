import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _controller = TextEditingController();
  String? _location;
  static const platform = MethodChannel('location_channel');

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      final String result = await platform.invokeMethod('getLocation');
      setState(() {
        _location = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _location = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task name input
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Location preview
            if (_location != null && _location!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _location!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            // Save and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Navigator.pop(context, {
                        'task': _controller.text,
                        'location': _location ?? ''
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}