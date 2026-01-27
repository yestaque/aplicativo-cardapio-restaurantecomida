import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel Admin")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pedidos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              final status = pedido['status'];
              final valor = pedido['valor'];

              return ListTile(
                title: Text("Pedido: ${pedido.id}"),
                subtitle: Text("Valor: R\$ ${valor.toStringAsFixed(2)}"),
                trailing: DropdownButton<String>(
                  value: status,
                  items: const [
                    DropdownMenuItem(value: "PENDENTE", child: Text("PENDENTE")),
                    DropdownMenuItem(value: "PAGO", child: Text("PAGO")),
                    DropdownMenuItem(value: "ENTREGUE", child: Text("ENTREGUE")),
                  ],
                  onChanged: (novoStatus) {
                    FirebaseFirestore.instance
                        .collection('pedidos')
                        .doc(pedido.id)
                        .update({'status': novoStatus});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
