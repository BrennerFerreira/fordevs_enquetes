import 'package:fordevs_enquetes/domain/entities/entities.dart';

abstract class SaveCurrentAccount {
  Future<void> save(AccountEntity account);
}
