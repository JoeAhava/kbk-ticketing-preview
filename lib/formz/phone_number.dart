import 'package:formz/formz.dart';

enum PhoneValidationError { invalid }

class PhoneNumber extends FormzInput<String, PhoneValidationError> {
  const PhoneNumber.pure() : super.pure('');

  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  static final RegExp _phoneRegExp = RegExp(r'^(\+?251|0)?9(\d{8})$');

  @override
  PhoneValidationError validator(String value) {
    return _phoneRegExp.hasMatch(value) ? null : PhoneValidationError.invalid;
  }
}
