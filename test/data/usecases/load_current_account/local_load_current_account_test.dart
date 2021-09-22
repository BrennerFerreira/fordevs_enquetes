import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/data/cache/cache.dart';
import 'package:fordevs_enquetes/data/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './local_load_current_account_test.mocks.dart';

@GenerateMocks([FetchSecureCacheStorage])
void main() {
  test('Should call FetchSecureCacheStorage with correct value', () async {
    final fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    final sut = LocalLoadCurrentAccount(fetchSecureCacheStorage);

    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
