import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_restaurante/main.dart';

void main() {
  testWidgets('App inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(MeuApp());

    expect(find.text('Cardápio'), findsOneWidget);
  });
}
