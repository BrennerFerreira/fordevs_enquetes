import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/data/cache/cache.dart';
import 'package:fordevs_enquetes/data/usecases/save_current_account/save_current_account.dart';
import 'package:fordevs_enquetes/domain/entities/entities.dart';
import 'package:fordevs_enquetes/domain/errors/errors.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './local_save_current_account_test.mocks.dart';

@GenerateMocks([SaveSecureCacheStorage])
void main() {
  late MockSaveSecureCacheStorage saveSecureCacheStorage;
  late LocalSaveCurrentAccount sut;
  late AccountEntity account;
  setUp(() {
    saveSecureCacheStorage = MockSaveSecureCacheStorage();
    sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );
    account = AccountEntity(faker.guid.guid());
  });

  test('Should call SaveCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
      saveSecureCacheStorage.saveSecure(key: "token", value: account.token),
    );
  });

  test('Should throw UnexpectedError if save fails', () async {
    when(saveSecureCacheStorage.saveSecure(
      key: anyNamed('key'),
      value: anyNamed('value'),
    )).thenThrow(Exception());

    final futureResult = sut.save(account);

    expect(futureResult, throwsA(DomainError.unexpected));
  });
}
