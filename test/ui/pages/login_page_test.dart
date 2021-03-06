import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginPresenter])
void main() {
  late MockLoginPresenter loginPresenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<String?> authErrorController;
  late StreamController<String?> navigateToController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    authErrorController = StreamController<String?>();
    navigateToController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(loginPresenter.emailErrorStream).thenAnswer(
      (_) => emailErrorController.stream,
    );

    when(loginPresenter.passwordErrorStream).thenAnswer(
      (_) => passwordErrorController.stream,
    );

    when(loginPresenter.authErrorStream).thenAnswer(
      (_) => authErrorController.stream,
    );

    when(loginPresenter.navigateToStream).thenAnswer(
      (_) => navigateToController.stream,
    );

    when(loginPresenter.isFormValidStream).thenAnswer(
      (_) => isFormValidController.stream,
    );

    when(loginPresenter.isLoadingStream).thenAnswer(
      (_) => isLoadingController.stream,
    );
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    authErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    loginPresenter = MockLoginPresenter();

    initStreams();
    mockStreams();

    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(loginPresenter),
        ),
        GetPage(
          name: '/fake_route',
          page: () => const Scaffold(body: Text('fake page')),
        ),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() => closeStreams());

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

    expect(find.byType(CircularProgressIndicator), findsNothing);
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

  testWidgets('Should present no error if password is valid', (tester) async {
    // arrange
    await loadPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets(
      'Should present no error if password is valid and LoginPresenter returns an empty string',
      (tester) async {
    // arrange
    await loadPage(tester);

    passwordErrorController.add('');
    await tester.pump();

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should enable login button if form is valid', (tester) async {
    // arrange
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final loginButton = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(loginButton.onPressed, isNotNull);
  });

  testWidgets('Should disable login button if form is invalid', (tester) async {
    // arrange
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final loginButton = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(loginButton.onPressed, null);
  });

  testWidgets('Should call authentication on form submit', (tester) async {
    // arrange
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(loginPresenter.auth()).called(1);
  });

  testWidgets('Should present loading', (tester) async {
    // arrange
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (tester) async {
    // arrange
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if authentication fails',
      (tester) async {
    // arrange
    await loadPage(tester);

    authErrorController.add('auth error');
    await tester.pump();

    expect(find.text('auth error'), findsOneWidget);
  });

  testWidgets('Should navigate to page', (tester) async {
    // arrange
    await loadPage(tester);

    navigateToController.add('/fake_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/fake_route');
    expect(find.text('fake page'), findsOneWidget);
  });
}
