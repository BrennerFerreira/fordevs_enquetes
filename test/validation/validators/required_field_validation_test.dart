import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any field');
  });

  test('Should return null if value is not empty', () {
    expect(sut.validate(value: 'any value'), null);
  });

  test('Should return value if value is null or empty', () {
    expect(sut.validate(), 'Campo obrigatório');
    expect(sut.validate(value: ''), 'Campo obrigatório');
  });
}
