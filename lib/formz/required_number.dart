import 'package:formz/formz.dart';

enum RequiredNumberValidationError { invalid }

class RequiredNumber extends FormzInput<double, RequiredNumberValidationError> {
  const RequiredNumber.pure() : super.pure(0);

  const RequiredNumber.dirty([double value = 0]) : super.dirty(value);

  @override
  RequiredNumberValidationError validator(double value) {
    return value > 0 ? null : RequiredNumberValidationError.invalid;
  }
}
