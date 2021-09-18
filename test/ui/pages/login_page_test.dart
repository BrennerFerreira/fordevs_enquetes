import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/ui/pages/pages.dart';

void main() {
  testWidgets('Should load with correct initial state', (tester) async {
    // arrange
    const loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    // assert
    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('E-mail'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason: '''When a TextFormField has only one Text child, it means it has
      no errors, since one child of this type will always be the labelText
      property''',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason: '''When a TextFormField has only one Text child, it means it has
      no errors, since one child of this type will always be the labelText
      property''',
    );

    final loginButton = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(loginButton.onPressed, null);
  });
}
