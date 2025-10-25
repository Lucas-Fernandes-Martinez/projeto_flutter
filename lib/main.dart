import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'calendar_page.dart';
import 'task_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color darkBlue = const Color(0xFF001F3F);
  final Color cyan = const Color(0xFF00FFFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACQA - Tarefas',
      theme: ThemeData(
        primaryColor: darkBlue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: darkBlue,
          secondary: cyan,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/calendar': (context) => CalendarPage(),
        '/tasks': (context) => TaskPage(),
      },
    );
  }
}
