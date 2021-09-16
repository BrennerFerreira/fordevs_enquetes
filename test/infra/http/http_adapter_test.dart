import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/infra/http/http_adapter.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  group('post', () {
    test('should call post with correct values', () async {
      final client = MockClient();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();

      when(client.post(any)).thenAnswer((_) async => Response('body', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(Uri.parse(url))).called(1);
    });
  });
}
