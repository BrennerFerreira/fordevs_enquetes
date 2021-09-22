import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/data/cache/cache.dart';
import 'package:fordevs_enquetes/data/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './local_load_current_account_test.mocks.dart';

@GenerateMocks([FetchSecureCacheStorage])
void main() {
  late MockFetchSecureCacheStorage fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
