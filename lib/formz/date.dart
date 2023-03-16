import 'package:formz/formz.dart';

enum DateValidationError { invalid, tooEarly, tooLate }

class Date extends FormzInput<DateTime, DateValidationError> {
  final DateTime after;
  final DateTime before;

  const Date.pure()
      : this.after = null,
        this.before = null,
        super.pure(null);

  const Date.dirty({this.after, this.before, DateTime value = null})
      : super.dirty(value);

  @override
  DateValidationError validator(DateTime value) {
    if (this.before != null && !value.isBefore(this.before))
      return DateValidationError.tooLate;
    if (this.after != null && !value.isAfter(this.after))
      return DateValidationError.tooEarly;
    return null;
  }
}
