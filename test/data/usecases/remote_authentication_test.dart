import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/data/http/http.dart';
import 'package:fordevs_enquetes/data/usecases/remote_authentication.dart';
import 'package:fordevs_enquetes/domain/errors/domain_error.dart';
import 'package:fordevs_enquetes/domain/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteAuthentication sut;
  late MockHttpClient httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test('Should call HttpClient with correct values', () async {
    // assert
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      },
    );

    // act
    await sut.auth(params);

    // assert
    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: {
          'email': params.email,
          'password': params.password,
        },
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    // arrange
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    // act
    final future = sut.auth(params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    // arrange
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.notFound);

    // act
    final future = sut.auth(params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    // arrange
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.unauthorized);

    // act
    final future = sut.auth(params);

    // assert
    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an AccountEntity if HttpClient returns 200', () async {
    // arrange
    final accessToken = faker.guid.guid();
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => {
        'accessToken': accessToken,
        'name': faker.person.name(),
      },
    );

    // act
    final account = await sut.auth(params);

    // assert
    expect(account.token, accessToken);
  });

  test(
      'Should return an UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    // arrange
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => {
        'invalidKey': 'invalidValue',
      },
    );

    // act
    final future = sut.auth(params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
