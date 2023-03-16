import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum TimeValidationError { invalid }

class Time extends FormzInput<TimeOfDay, TimeValidationError> {
  final TimeOfDay after;
  final TimeOfDay before;

  const Time.pure()
      : this.after = null,
        this.before = null,
        super.pure(null);

  const Time.dirty({this.after, this.before, TimeOfDay value = null})
      : super.dirty(value);

  @override
  TimeValidationError validator(TimeOfDay value) {
    return null;
  }
}
