import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider.dart';
import './taskDetailScreen.dart';
import './addTaskScreen.dart';

class TaskListScreen extends StatelessWidget {
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
        title: Text('Task List'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                color: const Color.fromARGB(255, 147, 125, 160),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Dismissible(
                    key: Key(task.title),
                    onDismissed: (direction) {
                      taskProvider.deleteTask(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task deleted')),
                      );
                    },
                    background: Container(color: Colors.red ,child: Center(child: Text('delete Task',style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),)),),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        //color: const Color.fromARGB(255, 102, 124, 223),  // Darker container background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title:  Text(
                              task.importance,
                              style: TextStyle(
                                color: _getImportanceColor(task.importance),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.title, style: TextStyle(color: Colors.white,
                            fontSize: 20)),
                            Text(
                              'Due Date: ${task.dueDate.year}/${task.dueDate.month}/${task.dueDate
                          .day}',
                              style: TextStyle(color: Colors.white70),
                            ),
                           
                          ],
                        ),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            taskProvider.toggleTaskCompletion(index);
                          },
                          activeColor: Colors.green,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetailScreen(task: task, index: index),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
