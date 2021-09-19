import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/validation/validators/validators.dart';

void main() {
  test('Should return null if email is empty or null', () {
    final sut = EmailValidation('any field');

    expect(sut.validate(value: ''), null);
    expect(sut.validate(), null);
  });
}
