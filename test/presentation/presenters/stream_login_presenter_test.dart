import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordevs_enquetes/presentation/presenters/stream_login_presenter.dart';
import 'package:fordevs_enquetes/presentation/presenters/validation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_login_presenter_test.mocks.dart';

@GenerateMocks([Validation])
void main() {
  test('Should call Validation with correct email', () {
    final validation = MockValidation();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();
    when(
      validation.validate(field: anyNamed('field'), value: anyNamed('value')),
    ).thenAnswer((_) => null);

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
