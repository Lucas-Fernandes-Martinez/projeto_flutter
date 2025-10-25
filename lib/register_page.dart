import 'package:flutter/material.dart';
import 'app_data.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Color darkBlue = const Color(0xFF001F3F);
  final Color cyan = const Color(0xFF00FFFF);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  void attemptRegister() {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => message = 'Preencha todos os campos.');
      return;
    }
    final ok = AppData.instance.registerUser(email, pass);
    if (ok) {
      // auto-login
      AppData.instance.login(email, pass);
      Navigator.pushReplacementNamed(context, '/calendar');
    } else {
      setState(() => message = 'Usuário já cadastrado com esse email.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cyan.withOpacity(0.05),
      appBar: AppBar(title: Text('Cadastro'), backgroundColor: darkBlue),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: attemptRegister,
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(child: Text('Cadastrar')),
                    ),
                  ),
                  if (message.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text(message, style: TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
