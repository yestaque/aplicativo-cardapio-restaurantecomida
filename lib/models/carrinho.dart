import 'package:flutter/material.dart';
import 'comida.dart';

class Carrinho extends ChangeNotifier {
  final Map<Comida, int> _itens = {};

  Map<Comida, int> get itens => _itens;

  void adicionar(Comida comida) {
    _itens.update(comida, (qtd) => qtd + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void remover(Comida comida) {
    if (!_itens.containsKey(comida)) return;

    if (_itens[comida]! > 1) {
      _itens[comida] = _itens[comida]! - 1;
    } else {
      _itens.remove(comida);
    }
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }

  double get total {
    double soma = 0;
    _itens.forEach((comida, qtd) {
      soma += comida.preco * qtd;
    });
    return soma;
  }
}
