import 'package:fordevs_enquetes/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String _field;

  EmailValidation(this._field);

  @override
  String get field => _field;

  @override
  String? validate({String? value}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    return regex.hasMatch(value) ? null : 'E-mail inválido';
  }
}
