import 'package:fordevs_enquetes/data/usecases/save_current_account/save_cache_storage.dart';
import 'package:fordevs_enquetes/domain/errors/domain_error.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
        key: "token",
        value: account.token,
      );
    } on Exception {
      throw DomainError.unexpected;
    }
  }
}
