import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String _field;

  const EmailValidation(this._field);

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

  @override
  List<String> get props => [_field];
}
