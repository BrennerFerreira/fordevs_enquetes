import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String _field;

  const RequiredFieldValidation(this._field);

  @override
  String get field => _field;

  @override
  String? validate({String? value}) {
    return value == null || value.isEmpty ? 'Campo obrigatório' : null;
  }

  @override
  List<String> get props => [_field];
}
