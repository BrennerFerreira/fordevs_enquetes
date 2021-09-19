import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/validation/validators/required_field_validation.dart';

void main() {
  test('Should return null if value is not empty', () {
    final sut = RequiredFieldValidation('any field');

    final error = sut.validate('any value');

    expect(error, null);
  });
}
