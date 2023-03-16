part of '../../../auth/bloc/verification/verification_bloc.dart';

@immutable
abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object> get props => [];
}

class SendCodeEvent extends VerificationEvent {
  const SendCodeEvent({this.phoneNumber});

  final String phoneNumber;
}

class VerifyCodeEvent extends VerificationEvent {
  const VerifyCodeEvent({this.code});

  final String code;
}

class PhoneNumberChanged extends VerificationEvent {
  const PhoneNumberChanged(this.phoneNumber);

  final String phoneNumber;
}

class VerificationCodeChanged extends VerificationEvent {
  const VerificationCodeChanged(this.code);

  final String code;
}

class VerificationErrorEvent extends VerificationEvent {
  final String message;

  const VerificationErrorEvent(this.message);
}
