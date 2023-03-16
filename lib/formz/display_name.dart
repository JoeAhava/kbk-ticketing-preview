import 'package:formz/formz.dart';

enum DisplayNameValidationError { invalid }

class DisplayName extends FormzInput<String, DisplayNameValidationError> {
  const DisplayName.pure() : super.pure('');

  const DisplayName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _displayNameRegExp = RegExp(r'[a-zA-Z]{3,} [a-zA-Z]{3,}');

  @override
  DisplayNameValidationError validator(String value) {
    return _displayNameRegExp.hasMatch(value)
        ? null
        : DisplayNameValidationError.invalid;
  }
}
