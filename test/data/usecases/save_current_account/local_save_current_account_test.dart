import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/data/usecases/save_current_account/save_cache_storage.dart';
import 'package:fordevs_enquetes/data/usecases/save_current_account/save_current_account.dart';
import 'package:fordevs_enquetes/domain/entities/account_entity.dart';
import 'package:fordevs_enquetes/domain/errors/domain_error.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './local_save_current_account_test.mocks.dart';

@GenerateMocks([SaveSecureCacheStorage])
void main() {
  test('Should call SaveCacheStorage with correct values', () async {
    final saveSecureCacheStorage = MockSaveSecureCacheStorage();
    final sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
    final account = AccountEntity(faker.guid.guid());

    await sut.save(account);

    verify(
      saveSecureCacheStorage.saveSecure(key: "token", value: account.token),
    );
  });

  test('Should throw UnexpectedError if save fails', () async {
    final saveSecureCacheStorage = MockSaveSecureCacheStorage();
    final sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
    final account = AccountEntity(faker.guid.guid());

    when(saveSecureCacheStorage.saveSecure(
      key: anyNamed('key'),
      value: anyNamed('value'),
    )).thenThrow(Exception());

    final futureResult = sut.save(account);

    expect(futureResult, throwsA(DomainError.unexpected));
  });
}
