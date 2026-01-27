import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'carrinho.dart';

Future<void> salvarPedido(Carrinho carrinho) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  await FirebaseFirestore.instance.collection('pedidos').add({
    "usuario": user.email,
    "total": carrinho.total,
    "data": Timestamp.now(),
    "itens": carrinho.itens.entries.map((e) {
      return {
        "nome": e.key.nome,
        "quantidade": e.value,
        "preco": e.key.preco,
      };
    }).toList(),
  });

  carrinho.limpar();
}
