import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class PixPage extends StatefulWidget {
  final double valor;
  const PixPage({super.key, required this.valor});

  @override
  State<PixPage> createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  final String chavePix = "84992160269";

  bool entregaDomicilio = false;
  final TextEditingController enderecoController = TextEditingController();

  Future<void> salvarPedidoNoFirestore(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (entregaDomicilio && enderecoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe o endereço para entrega")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('pedidos').add({
      'userId': user.uid,
      'valor': widget.valor,
      'tipoEntrega': entregaDomicilio ? 'DOMICILIO' : 'RETIRADA',
      'endereco': entregaDomicilio ? enderecoController.text : '',
      'status': 'PENDENTE',
      'data': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pedido realizado com sucesso!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagamento PIX")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Pagamento via PIX",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Text(
              "Valor: R\$ ${widget.valor.toStringAsFixed(2)}",
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

            const SizedBox(height: 30),

            // 🔹 ENTREGA OU RETIRADA
            SwitchListTile(
              title: const Text("Entrega em domicílio"),
              value: entregaDomicilio,
              onChanged: (value) {
                setState(() {
                  entregaDomicilio = value;
                });
              },
            ),

            // 🔹 CAMPO ENDEREÇO
            if (entregaDomicilio)
              TextField(
                controller: enderecoController,
                decoration: const InputDecoration(
                  labelText: "Endereço completo",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await salvarPedidoNoFirestore(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Já paguei"),
            ),
          ],
        ),
      ),
    );
  }
}
