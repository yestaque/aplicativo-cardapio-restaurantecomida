import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/carrinho.dart';
import '../models/comida.dart';
import 'pix_page.dart'; // IMPORT DO PIX

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carrinho = Provider.of<Carrinho>(context);

    Future<void> finalizarPedido() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('pedidos').add({
        'userId': user.uid,
        'itens': carrinho.itens.entries.map((entry) {
          return {
            'nome': entry.key.nome,
            'preco': entry.key.preco,
            'quantidade': entry.value,
          };
        }).toList(),
        'total': carrinho.total,
        'data': Timestamp.now(),
        'status': 'pendente', // status inicial
        'pagamento': 'pix',  // tipo de pagamento
      });

      carrinho.limpar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido realizado com sucesso!")),
      );

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho")),
      body: carrinho.itens.isEmpty
          ? const Center(child: Text("Carrinho vazio"))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: carrinho.itens.entries.map((entry) {
                      final Comida comida = entry.key;
                      final int quantidade = entry.value;

                      return ListTile(
                        title: Text(comida.nome),
                        subtitle: Text("Qtd: $quantidade"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => carrinho.remover(comida),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => carrinho.adicionar(comida),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Total: R\$ ${carrinho.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // CORREÇÃO: SIZEDBOX NO LUGAR DO BOX
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: carrinho.itens.isEmpty
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PixPage(valor: carrinho.total),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            "Finalizar Pedido",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
