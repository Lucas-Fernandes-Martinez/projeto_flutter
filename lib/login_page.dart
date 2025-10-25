import 'package:flutter/material.dart';
import 'app_data.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color darkBlue = const Color(0xFF001F3F);
  final Color cyan = const Color(0xFF00FFFF);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String message = '';

  void attemptLogin() {
    final email = emailController.text.trim();
    final pass = passwordController.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => message = 'Preencha email e senha.');
      return;
    }
    final ok = AppData.instance.login(email, pass);
    if (ok) {
      Navigator.pushReplacementNamed(context, '/calendar');
    } else {
      setState(
        () => message = 'Credenciais incorretas ou usuário não cadastrado.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cyan.withOpacity(0.05),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 24),
              Text(
                'Bem Vindo,',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              Text(
                'Use sua conta',
                style: TextStyle(
                  fontSize: 16,
                  color: darkBlue.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 32),
              Card(
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
                        onPressed: attemptLogin,
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('Entrar')),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text('Não é cadastrado? Cadastre-se'),
                      ),
                      if (message.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Text(message, style: TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
