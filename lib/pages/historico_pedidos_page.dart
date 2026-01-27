import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoricoPedidosPage extends StatelessWidget {
  const HistoricoPedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Pedidos")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .where('userId', isEqualTo: user!.uid)
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
                trailing: Text(status),
              );
            },
          );
        },
      ),
    );
  }
}
