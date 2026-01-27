import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comida.dart';
import '../models/carrinho.dart';

class DetalhePage extends StatelessWidget {
  final Comida comida;

  const DetalhePage({super.key, required this.comida});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(comida.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                comida.imagem,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              comida.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(comida.descricao),
            const SizedBox(height: 10),
            Text(
              "R\$ ${comida.preco.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<Carrinho>(
                    context,
                    listen: false,
                  ).adicionar(comida);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Adicionado ao carrinho"),
                    ),
                  );
                },
                child: const Text("Pedir"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
