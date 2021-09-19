import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/validation/protocols/protocols.dart';
import 'package:fordevs_enquetes/validation/validators/validators.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'validation_composite_test.mocks.dart';

@GenerateMocks([FieldValidation])
void main() {
  late MockFieldValidation validation1;
  late MockFieldValidation validation2;
  late MockFieldValidation validation3;
  late ValidationComposite sut;

  void mockValidationField(
    MockFieldValidation fieldValidation, {
    String fieldName = 'any field',
    String? error,
  }) {
    when(fieldValidation.field).thenReturn(fieldName);
    when(fieldValidation.validate(value: anyNamed('value'))).thenReturn(error);
  }

  setUp(() {
    validation1 = MockFieldValidation();
    mockValidationField(validation1);

    validation2 = MockFieldValidation();
    mockValidationField(validation2);

    validation3 = MockFieldValidation();
    mockValidationField(validation3, fieldName: 'other field');

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validators return null or empty', () {
    mockValidationField(validation2, error: '');

    final error = sut.validate(field: 'any field', value: 'any value');

    expect(error, null);
  });
}
