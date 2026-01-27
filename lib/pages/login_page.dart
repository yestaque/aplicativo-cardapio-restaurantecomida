import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool carregando = false;

  Future<void> login() async {
    try {
      setState(() => carregando = true);

    await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: emailController.text.trim(),
  password: senhaController.text.trim(),
);

// 🔥 REDIRECIONA
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => HomePage()),
);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login realizado ✅")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Erro no login")),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

  Future<void> cadastrar() async {
    try {
      setState(() => carregando = true);

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso ✅")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Erro no cadastro")),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            if (carregando)
              const CircularProgressIndicator()
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text("Entrar"),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: cadastrar,
                child: const Text("Criar conta"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
