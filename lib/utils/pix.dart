String gerarPix({
  required String chave,
  required String nome,
  required String cidade,
  required double valor,
}) {
  return '''
000201
010212
26360014BR.GOV.BCB.PIX
0114$chave
52040000
5303986
54${valor.toStringAsFixed(2).padLeft(6, '0')}
5802BR
59${nome.length.toString().padLeft(2, '0')}$nome
60${cidade.length.toString().padLeft(2, '0')}$cidade
62070503***
6304
'''.replaceAll('\n', '');
}
