part of '../../../auth/bloc/verification/verification_bloc.dart';

enum VerificationStatus {
  requestingPhone,
  sendingCode,
  requestingCode,
  verifyingCode,
  codeVerified,
  codeRejected,
}

class VerificationState extends Equatable {
  final PhoneNumber phoneNumber;
  final VerificationCode code;
  final FormzStatus phoneNumberStatus;
  final FormzStatus codeStatus;
  final VerificationStatus verificationStatus;
  final String errorMessage;
  final String verificationId;

  const VerificationState(
      {this.phoneNumber,
      this.code,
      this.phoneNumberStatus,
      this.codeStatus,
      this.verificationStatus,
      this.errorMessage,
      this.verificationId});

  bool showingPhone() => [
        VerificationStatus.sendingCode,
        VerificationStatus.requestingPhone
      ].contains(verificationStatus);

  VerificationState copyWith(
      {PhoneNumber phoneNumber,
      VerificationCode code,
      FormzStatus phoneNumberStatus,
      FormzStatus codeStatus,
      VerificationStatus verificationStatus,
      String errorMessage,
      String verificationId}) {
    return VerificationState(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        code: code ?? this.code,
        phoneNumberStatus: phoneNumberStatus ?? this.phoneNumberStatus,
        codeStatus: codeStatus ?? this.codeStatus,
        verificationStatus: verificationStatus ?? this.verificationStatus,
        errorMessage: errorMessage ?? '',
        // reset error message if not specified
        verificationId: verificationId ?? this.verificationId);
  }

  @override
  List<Object> get props => [
        phoneNumber,
        phoneNumberStatus,
        codeStatus,
        verificationStatus,
        errorMessage
      ];
}
