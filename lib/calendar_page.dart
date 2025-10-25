import 'package:flutter/material.dart';
import 'app_data.dart';
import 'task_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Color darkBlue = const Color(0xFF001F3F);
  final Color cyan = const Color(0xFF00FFFF);

  DateTime selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: darkBlue,
              onPrimary: Colors.white,
              onSurface: darkBlue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: darkBlue),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void openTasksForSelectedDate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskPage(date: selectedDate)),
    ).then((_) {
      // Ao voltar da tela de tarefas, atualizar a lista
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = dateKeyFromDate(selectedDate);
    final tasks = AppData.instance.getTasksForDateKey(key);

    return Scaffold(
      backgroundColor: cyan.withOpacity(0.05),
      appBar: AppBar(
        title: const Text('Calendário'),
        backgroundColor: darkBlue,
        actions: [
          IconButton(
            onPressed: () {
              AppData.instance.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Text(
                'Bem-vindo, ${AppData.instance.loggedUser?.email ?? ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Data selecionada',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _pickDate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkBlue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Selecionar dia'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: openTasksForSelectedDate,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: darkBlue,
                                side: BorderSide(color: darkBlue),
                              ),
                              child: const Text('Abrir tarefas'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Tarefas neste dia: ${tasks.length}'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.calendar_today,
                                color: darkBlue,
                              ),
                              title: const Text('Visão rápida'),
                              subtitle: const Text(
                                'Selecione um dia e abra as tarefas para visualizar ou editar.',
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (tasks.isEmpty)
                              const Text(
                                'Nenhuma tarefa para a data selecionada.',
                              )
                            else
                              ...tasks.map(
                                (t) => ListTile(
                                  title: Text(t.title),
                                  trailing: Icon(
                                    t.done
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color: t.done ? Colors.green : darkBlue,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
