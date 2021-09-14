import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/data/usecases/http_client.dart';
import 'package:fordevs_enquetes/data/usecases/remote_authentication.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  test('Should call HttpClient with correct URL', () async {
    // arrange
    final httpClient = MockHttpClient();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // act
    await sut.auth();

    // assert
    verify(httpClient.request(url: url));
  });
}
