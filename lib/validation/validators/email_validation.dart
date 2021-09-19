import 'package:fordevs_enquetes/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String _field;

  EmailValidation(this._field);

  @override
  String get field => _field;

  @override
  String? validate({String? value}) {
    return null;
  }
}
