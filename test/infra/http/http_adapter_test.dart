import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/infra/http/http_adapter.dart';
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
    test('should call post with correct values', () async {
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"anyKey": "anyValue"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      )).called(1);
    });

    test('should call post with correct body', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('{"anyKey": "anyValue"}', 200));

      await sut.request(url: url, method: 'post', body: {'anyKey': 'anyValue'});
      verify(client.post(
        any,
        headers: anyNamed('headers'),
        body: jsonEncode({"anyKey": "anyValue"}),
      )).called(1);
    });

    test('should call post without body', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('{"anyKey": "anyValue"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers'))).called(1);
    });

    test('should return data if post returns 200', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('{"anyKey": "anyValue"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, {'anyKey': 'anyValue'});
    });

    test('should return null if post returns 200 without data', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response['accessToken'], null);
    });
  });
}
