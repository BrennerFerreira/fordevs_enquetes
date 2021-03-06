import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/domain/entities/entities.dart';
import 'package:fordevs_enquetes/domain/errors/errors.dart';
import 'package:fordevs_enquetes/domain/usecases/usecases.dart';
import 'package:fordevs_enquetes/presentation/presenters/presenters.dart';
import 'package:fordevs_enquetes/presentation/protocols/protocols.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'getx_login_presenter_test.mocks.dart';

@GenerateMocks([Validation, Authentication, SaveCurrentAccount])
void main() {
  late MockValidation validation;
  late MockAuthentication authentication;
  late MockSaveCurrentAccount saveCurrentAccount;
  late GetxLoginPresenter sut;
  late String email;
  late String password;
  late String token;

  PostExpectation mockValidationCall({String? field}) => when(
        validation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String? validationReturn, String? field}) =>
      mockValidationCall(field: field).thenReturn(validationReturn);

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  PostExpectation mockSaveCurrentAccountCall() => when(
        saveCurrentAccount.save(any),
      );

  void mockAuthentication() => mockAuthenticationCall().thenAnswer(
        (_) async => AccountEntity(token),
      );

  void mockAuthenticationError(DomainError error) =>
      mockAuthenticationCall().thenThrow(error);

  void mockSaveCurrentAccountError() =>
      mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);

  setUp(() {
    validation = MockValidation();
    authentication = MockAuthentication();
    saveCurrentAccount = MockSaveCurrentAccount();

    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );

    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAuthentication();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if Validation fails', () {
    mockValidation(validationReturn: 'any error');

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, 'any error'),
    ));

    sut.validateEmail(email);
  });

  test('Should not emit email error again if LoginState does not changes', () {
    mockValidation(validationReturn: 'any error');

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, 'any error'),
    ));

    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if email Validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if Validation fails', () {
    mockValidation(validationReturn: 'any error');

    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, 'any error'),
    ));

    sut.validatePassword(password);
  });

  test('Should not emit password error again if LoginState does not changes',
      () {
    mockValidation(validationReturn: 'any error');

    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, 'any error'),
    ));

    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password Validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit error if only one Validation succeeds', () {
    mockValidation(field: 'email', validationReturn: 'any error');

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, 'any error'),
    ));

    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit true if form is valid', () async {
    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication.auth(
      AuthenticationParams(email: email, password: password),
    )).called(1);
  });

  test('Should call SaveCurrentAccount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.authErrorStream.listen(expectAsync1(
      (error) => expect(
        error,
        'Algo inesperado aconteceu. Tente novamente em breve',
      ),
    ));

    await sut.auth();
  });

  test('Should emit correct events on authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.authErrorStream.listen(expectAsync1(
      (error) => expect(error, 'E-mail e/ou senha incorretos.'),
    ));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.authErrorStream.listen(expectAsync1(
      (error) => expect(
        error,
        'Algo inesperado aconteceu. Tente novamente em breve',
      ),
    ));

    await sut.auth();
  });

  test('Should navigate to surveys page on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/surveys'),
    ));

    await sut.auth();
  });
}
