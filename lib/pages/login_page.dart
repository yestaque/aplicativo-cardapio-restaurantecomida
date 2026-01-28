import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool carregando = false;
  String dataHora = "";
  Timer? timer;

  double? temperatura;
  String cidade = "Detectando...";

  @override
  void initState() {
    super.initState();
    atualizarHora();
    detectarCidade();

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      atualizarHora();
      buscarTemperatura();
    });
  }

  void atualizarHora() {
    final agora = DateTime.now();
    final formatado = DateFormat("dd/MM/yyyy • HH:mm").format(agora);

    setState(() {
      dataHora = formatado;
    });
  }

  Future<void> detectarCidade() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      cidade = placemarks.first.locality ?? "Cidade desconhecida";
    });

    buscarTemperatura();
  }

  Future<void> buscarTemperatura() async {
    const apiKey = "SUA_API_KEY_OPENWEATHER"; // 🔑 coloque sua key aqui

    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$cidade&units=metric&lang=pt_br&appid=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      temperatura = data['main']['temp'];
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      setState(() => carregando = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login realizado com sucesso 🍔")),
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
        const SnackBar(content: Text("Conta criada com sucesso 🎉")),
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
      backgroundColor: const Color(0xFFFFF3E0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fastfood, size: 80, color: Colors.deepOrange),
                  const SizedBox(height: 10),

                  const Text(
                    "Bem-vindo à Lanchonete",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 🕒 DATA E HORA
                  Text(
                    dataHora,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  // 🌡️ CIDADE E TEMPERATURA
                  Text(
                    temperatura == null
                        ? "📍 $cidade • carregando clima..."
                        : "📍 $cidade • ${temperatura!.toStringAsFixed(1)}°C 🌡️",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (carregando)
                    const CircularProgressIndicator(color: Colors.deepOrange)
                  else ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text("Entrar", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    TextButton(
                      onPressed: cadastrar,
                      child: const Text("Criar conta",
                          style: TextStyle(color: Colors.deepOrange)),
                    ),
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
