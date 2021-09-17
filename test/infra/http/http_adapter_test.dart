import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/data/http/http_error.dart';
import 'package:fordevs_enquetes/infra/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late MockClient client;
  late HttpAdapter sut;
  late String url;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    PostExpectation mockRequest() => when(
          client.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        );

    void mockResponse({
      int? statusCode,
      String body = '{"anyKey": "anyValue"}',
    }) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode ?? 200));
    }

    setUp(() => mockResponse());

    test('should call post with correct values', () async {
      await sut.request(url: url, method: 'post', body: {'anyKey': 'anyValue'});

      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({'anyKey': 'anyValue'}),
      )).called(1);
    });

    test('should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers'))).called(1);
    });

    test('should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'anyKey': 'anyValue'});
    });

    test('should return null if post returns 200 without data', () async {
      mockResponse(body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response.containsKey('accessToken'), true);
      expect(response['accessToken'], null);
    });

    test('should return null if post returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response.containsKey('accessToken'), true);
      expect(response['accessToken'], null);
    });

    test('should return null if post returns 204 with data', () async {
      mockResponse(statusCode: 204);

      final response = await sut.request(url: url, method: 'post');

      expect(response.containsKey('accessToken'), true);
      expect(response['accessToken'], null);
    });

    test('should return BadRequestError if post returns 400', () async {
      mockResponse(statusCode: 400);

      final futureResponse = sut.request(url: url, method: 'post');

      expect(futureResponse, throwsA(HttpError.badRequest));
    });

    test('should return UnauthorizedError if post returns 401', () async {
      mockResponse(statusCode: 401);

      final futureResponse = sut.request(url: url, method: 'post');

      expect(futureResponse, throwsA(HttpError.unauthorized));
    });

    test('should return ForbiddenError if post returns 403', () async {
      mockResponse(statusCode: 403);

      final futureResponse = sut.request(url: url, method: 'post');

      expect(futureResponse, throwsA(HttpError.forbidden));
    });

    test('should return NotFoundError if post returns 404', () async {
      mockResponse(statusCode: 404);

      final futureResponse = sut.request(url: url, method: 'post');

      expect(futureResponse, throwsA(HttpError.notFound));
    });

    test('should return ServerError if post returns 500', () async {
      mockResponse(statusCode: 500);

      final futureResponse = sut.request(url: url, method: 'post');

      expect(futureResponse, throwsA(HttpError.serverError));
    });
  });
}
