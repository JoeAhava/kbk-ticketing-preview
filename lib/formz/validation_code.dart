import 'package:formz/formz.dart';

enum VerificationCodeValidationError { invalid }

class VerificationCode
    extends FormzInput<String, VerificationCodeValidationError> {
  const VerificationCode.pure() : super.pure('');

  const VerificationCode.dirty([String value = '']) : super.dirty(value);

  @override
  VerificationCodeValidationError validator(String value) {
    return value.length >= 6 ? null : VerificationCodeValidationError.invalid;
  }
}
