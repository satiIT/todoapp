import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import '../models/taskClass.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int index;

  TaskDetailScreen({required this.task, required this.index});

  final _subTaskController = TextEditingController();
   Color _getImportanceColor(String importance) {
    switch (importance) {
      case 'Important':
        return const Color.fromARGB(255, 167, 56, 48);
      case 'Medium':
        return Colors.orange;
      case 'Normal':
      default:
        return const Color.fromARGB(255, 41, 117, 44);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             SizedBox(height: 10),
             Card(
                
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                color: const Color.fromARGB(255, 52, 53, 83),
              child: Column(
                children: [
                   Text(
              'Importance: ${task.importance}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getImportanceColor(task.importance),
              )),
            Text('Due :${task.dueDate.year}/${task.dueDate.month}/${task.dueDate
                      .day}',
                     style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getImportanceColor(task.importance),)),
            SizedBox(height: 40),
                ],
              ),
             )
             ,
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return ListView.builder(
                    itemCount: task.subTasks.length,
                    itemBuilder: (context, subTaskIndex) {
                      final subTask = task.subTasks[subTaskIndex];
                      return Card(
                        elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                color: const Color.fromARGB(255, 147, 125, 160),
                        child: ListTile(
                          title: Text(subTask.title),
                          trailing: Checkbox(
                            value: subTask.isCompleted,
                            onChanged: (value) {
                              taskProvider.toggleSubTaskCompletion(
                                  index, subTaskIndex);
                            },
                          ),
                          onLongPress: () {
                            taskProvider.removeSubTask(index, subTaskIndex);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _subTaskController,
              decoration: InputDecoration(labelText: 'New SubTask'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_subTaskController.text.isNotEmpty) {
                  final taskProvider =
                      Provider.of<TaskProvider>(context, listen: false);
                  taskProvider.addSubTask(
                    index,
                    SubTask(title: _subTaskController.text),
                  );
                  _subTaskController.clear();
                }
              },
              child: Text('Add SubTask'),
            ),
          ],
        ),
      ),
    );
  }
}
