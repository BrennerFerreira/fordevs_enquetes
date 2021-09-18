import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/presentation/presenters/stream_login_presenter.dart';
import 'package:fordevs_enquetes/presentation/presenters/validation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_login_presenter_test.mocks.dart';

@GenerateMocks([Validation])
void main() {
  late MockValidation validation;
  late StreamLoginPresenter sut;
  late String email;

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test('Should call Validation with correct email', () {
    when(
      validation.validate(field: anyNamed('field'), value: anyNamed('value')),
    ).thenReturn(null);

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if Validation fails', () {
    when(
      validation.validate(field: anyNamed('field'), value: anyNamed('value')),
    ).thenReturn('any error');

    expectLater(sut.emailErrorStream, emits('any error'));

    sut.validateEmail(email);
  });
}
