import 'package:formz/formz.dart';
import 'package:tuple/tuple.dart' show Tuple2;

enum PasswordConfirmationValidationError { invalid }

class PasswordConfirmation extends FormzInput<Tuple2<String, String>,
    PasswordConfirmationValidationError> {
  const PasswordConfirmation.pure()
      : super.pure(const Tuple2<String, String>('', ''));

  const PasswordConfirmation.dirty([value = '']) : super.dirty(value);

  @override
  PasswordConfirmationValidationError validator(Tuple2<String, String> value) {
    return value.item1 == value.item2
        ? null
        : PasswordConfirmationValidationError.invalid;
  }
}
