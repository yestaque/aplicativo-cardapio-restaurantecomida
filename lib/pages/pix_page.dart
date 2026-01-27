import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class PixPage extends StatelessWidget {
  final double valor;
  const PixPage({super.key, required this.valor});

  final String chavePix = "84992160269";

  Future<void> salvarPedidoNoFirestore(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('pedidos').add({
      'userId': user.uid,
      'valor': valor,
      'status': 'PENDENTE', // status inicial
      'data': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pedido salvo com sucesso!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagamento PIX")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Pague com PIX",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Text(
              "Valor: R\$ ${valor.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            Image.network(
              "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=pix:$chavePix",
              height: 200,
              width: 200,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: chavePix));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Chave PIX copiada!")),
                );
              },
              child: const Text("Copiar chave PIX"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await salvarPedidoNoFirestore(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Já paguei"),
            ),
          ],
        ),
      ),
    );
  }
}
