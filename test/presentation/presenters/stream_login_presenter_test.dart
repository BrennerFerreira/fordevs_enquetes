import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/presentation/presenters/stream_login_presenter.dart';
import 'package:fordevs_enquetes/presentation/protocols/validation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_login_presenter_test.mocks.dart';

@GenerateMocks([Validation])
void main() {
  late MockValidation validation;
  late StreamLoginPresenter sut;
  late String email;

  PostExpectation mockValidationCall({String? field}) => when(
        validation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String? validationReturn, String? field}) =>
      mockValidationCall(field: field).thenReturn(validationReturn);

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if Validation fails', () {
    mockValidation(validationReturn: 'any error');

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, 'any error'),
    ));

    sut.validateEmail(email);
  });

  test('Should not emit email error again if LoginState does not changes', () {
    mockValidation(validationReturn: 'any error');

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, 'any error'),
    ));

    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
