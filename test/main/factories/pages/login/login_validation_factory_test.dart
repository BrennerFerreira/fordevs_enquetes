import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/main/factories/factories.dart';
import 'package:fordevs_enquetes/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () {
    const expectedValidations = [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
    ];

    final validations = makeLoginValidations();

    expect(validations, expectedValidations);
  });
}
