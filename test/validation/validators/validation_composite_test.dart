import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/validation/protocols/protocols.dart';
import 'package:fordevs_enquetes/validation/validators/validators.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'validation_composite_test.mocks.dart';

@GenerateMocks([FieldValidation])
void main() {
  test('Should return null if all validators return null or empty', () {
    final validation1 = MockFieldValidation();
    when(validation1.field).thenReturn('any field');
    when(validation1.validate(value: anyNamed('value'))).thenReturn(null);

    final validation2 = MockFieldValidation();
    when(validation2.field).thenReturn('any field');
    when(validation2.validate(value: anyNamed('value'))).thenReturn('');

    final sut = ValidationComposite([validation1, validation2]);
    final error = sut.validate(field: 'any field', value: 'any value');

    expect(error, null);
  });
}
