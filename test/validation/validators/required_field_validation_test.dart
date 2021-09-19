import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/validation/validators/required_field_validation.dart';

void main() {
  test('Should return null if value is not empty', () {
    final sut = RequiredFieldValidation('any field');

    final error = sut.validate(value: 'any value');

    expect(error, null);
  });

  test('Should return value if value is empty', () {
    final sut = RequiredFieldValidation('any field');

    final error = sut.validate();

    expect(error, 'Campo obrigatório');
  });
}
