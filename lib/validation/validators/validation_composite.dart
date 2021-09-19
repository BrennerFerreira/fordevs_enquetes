import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    final filteredValidations = validations.where(
      (validation) => validation.field == field,
    );

    for (final validation in filteredValidations) {
      final error = validation.validate(value: value);

      if (error != null && error.isNotEmpty) {
        return error;
      }
    }

    return null;
  }
}
