import 'package:flutter/material.dart';
import 'app_data.dart';

class TaskPage extends StatefulWidget {
  final DateTime date;
  TaskPage({Key? key, DateTime? date})
    : date = date ?? DateTime.now(),
      super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final Color darkBlue = const Color(0xFF001F3F);
  final Color cyan = const Color(0xFF00FFFF);
  final TextEditingController addController = TextEditingController();

  String get key => dateKeyFromDate(widget.date);

  void _addTaskDialog() {
    addController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Adicionar tarefa'),
        content: TextField(
          controller: addController,
          decoration: InputDecoration(hintText: 'Título da tarefa'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = addController.text.trim();
              if (text.isNotEmpty) {
                AppData.instance.addTaskForDate(
                  key,
                  Task(title: text, done: false),
                );
                AppData.instance.sortTasksForDate(key);
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _toggleDone(Task t) {
    setState(() {
      t.done = !t.done;
      AppData.instance.sortTasksForDate(key);
    });
  }

  void _removeTask(Task t) {
    setState(() {
      AppData.instance.removeTaskForDate(key, t);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = AppData.instance.getTasksForDateKey(key);
    AppData.instance.sortTasksForDate(key);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarefas - ${widget.date.day}/${widget.date.month}/${widget.date.year}',
        ),
        backgroundColor: darkBlue,
      ),
      backgroundColor: cyan.withOpacity(0.05),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tarefas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    if (tasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text('Nenhuma tarefa neste dia. Adicione uma!'),
                      )
                    else
                      Column(
                        children: tasks.map((t) {
                          return Dismissible(
                            key: Key(t.title + t.done.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              _removeTask(t);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tarefa removida')),
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: t.done,
                                onChanged: (_) => _toggleDone(t),
                                activeColor: darkBlue,
                              ),
                              title: Text(
                                t.title,
                                style: TextStyle(
                                  decoration: t.done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _addTaskDialog,
              icon: Icon(Icons.add),
              label: Text('Adicionar tarefa'),
              style: ElevatedButton.styleFrom(backgroundColor: darkBlue),
            ),
          ],
        ),
      ),
    );
  }
}
