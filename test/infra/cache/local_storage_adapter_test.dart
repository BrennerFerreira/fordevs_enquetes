import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/infra/cache/cache.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './local_storage_adapter_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  test('Should call save secure with correct methods', () async {
    final secureStorage = MockFlutterSecureStorage();
    final sut = LocalStorageAdapter(secureStorage: secureStorage);
    final key = faker.lorem.word();
    final value = faker.guid.guid();

    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });
}
