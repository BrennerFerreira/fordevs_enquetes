import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any field');
  });

  test('Should return null if email is empty or null', () {
    expect(sut.validate(value: ''), null);
    expect(sut.validate(), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate(value: faker.internet.email()), null);
  });
}
