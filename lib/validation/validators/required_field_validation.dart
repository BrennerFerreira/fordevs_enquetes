import 'package:fordevs_enquetes/validation/validators/field_validation.dart';

class RequiredFieldValidation implements FieldValidation {
  final String _field;

  RequiredFieldValidation(this._field);

  @override
  String get field => _field;

  @override
  String? validate(String value) {}
}
