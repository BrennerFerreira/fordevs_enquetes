import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    for (final validation in validations) {
      final error = validation.validate(value: value);

      if (error != null && error.isNotEmpty) {
        return error;
      }
    }

    return null;
  }
}
