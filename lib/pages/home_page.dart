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
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Cardápio",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoricoPedidosPage()),
              );
            },
          ),

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

      body: Column(
        children: [
          const SizedBox(height: 12),

          // Banner superior
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFA7A5A), Color(0xFFFFC371)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Bem-vindo!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Peça agora e receba rápido.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.delivery_dining, size: 45, color: Colors.white),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Lista de comidas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: comidas.length,
              itemBuilder: (context, index) {
                final comida = comidas[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalhePage(comida: comida),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Row(
                      children: [
                        // Imagem
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          child: Image.asset(
                            comida.imagem,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Texto
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comida.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  comida.descricao,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "R\$ ${comida.preco.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
