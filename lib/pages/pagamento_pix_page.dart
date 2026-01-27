import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PagamentoPixPage extends StatelessWidget {
  final double total;

  const PagamentoPixPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    const pixChave = "email@pix.com";

    final pixPayload = "PIX:$pixChave|VALOR:$total";

    return Scaffold(
      appBar: AppBar(title: const Text("Pagamento PIX")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Total: R\$ $total",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          QrImageView(
            data: pixPayload,
            size: 200,
          ),
          const SizedBox(height: 20),
          const Text("Escaneie o QR Code para pagar"),
        ],
      ),
    );
  }
}
