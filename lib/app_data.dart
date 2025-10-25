// Crie este arquivo em lib/app_data.dart
class User {
  final String email;
  final String password;
  User({required this.email, required this.password});
}

class Task {
  String title;
  bool done;
  Task({required this.title, this.done = false});
}

/// Chave de data no formato yyyy-MM-dd
String dateKeyFromDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class AppData {
  AppData._private();
  static final AppData instance = AppData._private();

  final List<User> users = [];
  User? loggedUser;

  /// tarefas por data
  final Map<String, List<Task>> tasksByDate = {};

  // Usuário: adicionar (retorna false se já existir)
  bool registerUser(String email, String password) {
    if (users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return false;
    }
    users.add(User(email: email, password: password));
    return true;
  }

  // Login (simulado)
  bool login(String email, String password) {
    final found = users.firstWhere(
      (u) =>
          u.email.toLowerCase() == email.toLowerCase() &&
          u.password == password,
      orElse: () => User(email: '', password: ''),
    );
    if (found.email == '') return false;
    loggedUser = found;
    return true;
  }

  void logout() {
    loggedUser = null;
  }

  // Tarefas
  List<Task> getTasksForDateKey(String key) {
    return tasksByDate[key] ?? [];
  }

  void addTaskForDate(String key, Task t) {
    tasksByDate.putIfAbsent(key, () => []);
    tasksByDate[key]!.add(t);
  }

  void removeTaskForDate(String key, Task t) {
    tasksByDate[key]?.remove(t);
  }

  void sortTasksForDate(String key) {
    final list = tasksByDate[key];
    if (list == null) return;
    final pending = list.where((t) => !t.done).toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    final done = list.where((t) => t.done).toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    tasksByDate[key] = [...pending, ...done];
  }
}
