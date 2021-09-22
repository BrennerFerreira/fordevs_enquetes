import 'package:fordevs_enquetes/data/cache/cache.dart';

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount(this.fetchSecureCacheStorage);

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
