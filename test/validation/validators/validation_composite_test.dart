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
    mockValidationField(validation1, fieldName: 'other field');

    validation2 = MockFieldValidation();
    mockValidationField(validation2);

    validation3 = MockFieldValidation();
    mockValidationField(validation3);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test('Should return null if all validators return null or empty', () {
    mockValidationField(validation2, error: '');

    final error = sut.validate(field: 'any field', value: 'any value');

    expect(error, null);
  });

  test('Should return the first error if one or more fields returns an error',
      () {
    mockValidationField(validation1, error: 'error validation 1');
    mockValidationField(validation2, error: 'error validation 2');
    mockValidationField(validation3, error: 'error validation 3');

    final error = sut.validate(field: 'any field', value: 'any value');

    expect(error, 'error validation 1');
  });

  test('Should return the first error of the field requested', () {
    mockValidationField(
      validation1,
      fieldName: 'other field',
      error: 'error validation 1',
    );
    mockValidationField(validation2, error: 'error validation 2');
    mockValidationField(validation3, error: 'error validation 3');

    final error = sut.validate(field: 'any field', value: 'any value');

    expect(error, 'error validation 2');
  });
}
