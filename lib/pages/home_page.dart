import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comida.dart';
import '../models/carrinho.dart';
import 'detalhe_page.dart';
import 'carrinho_page.dart';
import 'historico_pedidos_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Comida> comidas = [
    Comida(
      nome: "Hambúrguer",
      descricao: "Hambúrguer artesanal com queijo",
      preco: 25.0,
      imagem: "assets/imagens/hamburger.jpg",
    ),
    Comida(
      nome: "Pizza",
      descricao: "Pizza de calabresa",
      preco: 40.0,
      imagem: "assets/imagens/pizza.jpg",
    ),
    Comida(
      nome: "Batata Frita",
      descricao: "Batata frita crocante",
      preco: 15.0,
      imagem: "assets/imagens/batata-frita.jpg",
    ),
    Comida(
      nome: "Coca-Cola",
      descricao: "Refrigerante gelado 350ml",
      preco: 8.0,
      imagem: "assets/imagens/coca-cola.jpg",
    ),
    Comida(
      nome: "Sorvete",
      descricao: "Sorvete de chocolate",
      preco: 12.0,
      imagem: "assets/imagens/sorvete.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final carrinho = Provider.of<Carrinho>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cardápio"),
        actions: [
          // Histórico
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoricoPedidosPage()),
              );
            },
          ),

          // Carrinho
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarrinhoPage()),
                  );
                },
              ),
              if (carrinho.itens.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      carrinho.itens.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: comidas.length,
        itemBuilder: (context, index) {
          final comida = comidas[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  comida.imagem,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                comida.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(comida.descricao),
              trailing: Text(
                "R\$ ${comida.preco.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalhePage(comida: comida),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
