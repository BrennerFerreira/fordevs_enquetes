import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/ui/pages/pages.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginPresenter])
void main() {
  late MockLoginPresenter loginPresenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    loginPresenter = MockLoginPresenter();

    when(loginPresenter.emailErrorStream).thenAnswer(
      (_) => emailErrorController.stream,
    );

    when(loginPresenter.passwordErrorStream).thenAnswer(
      (_) => passwordErrorController.stream,
    );

    final loginPage = MaterialApp(home: LoginPage(loginPresenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    passwordErrorController.close();
    emailErrorController.close();
  });

  testWidgets('Should load with correct initial state', (tester) async {
    // arrange
    await loadPage(tester);

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

  testWidgets('Should call validate with correct values', (tester) async {
    // arrange
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(loginPresenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(loginPresenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid', (tester) async {
    // arrange
    await loadPage(tester);

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid', (tester) async {
    // arrange
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('E-mail'),
      matching: find.byType(Text),
    );

    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets(
      'Should present no error if email is valid and LoginPresenter returns an empty string',
      (tester) async {
    // arrange
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('E-mail'),
      matching: find.byType(Text),
    );

    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should present error if password is invalid', (tester) async {
    // arrange
    await loadPage(tester);

    passwordErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });
}
