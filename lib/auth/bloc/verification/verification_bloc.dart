import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:tuple/tuple.dart';
import 'package:ticketing/formz/formz.dart';

part 'verification_state.dart';

part 'verification_event.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc({@required authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(VerificationState(
          phoneNumber: PhoneNumber.pure(),
          code: VerificationCode.pure(),
          verificationStatus: VerificationStatus.requestingPhone));

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<VerificationState> mapEventToState(VerificationEvent event) async* {
    if (event is SendCodeEvent) {
      yield* _mapSendCodeEventToState(event);
    } else if (event is VerifyCodeEvent) {
      yield* _mapVerifyCodeEventToState(event);
    } else if (event is PhoneNumberChanged) {
      yield _mapPhoneNumberChangedToState(event, state);
    } else if (event is VerificationCodeChanged) {
      yield _mapVerificationCodeChangedToState(event, state);
    } else if (event is VerificationErrorEvent) {
      yield state.copyWith(errorMessage: event.message);
    }
  }

  VerificationState _mapPhoneNumberChangedToState(PhoneNumberChanged event,
      VerificationState state) {
    final phoneNumber = PhoneNumber.dirty(event.phoneNumber);
    return state.copyWith(
        errorMessage: '',
        phoneNumber: phoneNumber,
        phoneNumberStatus: Formz.validate([phoneNumber]));
  }

  VerificationState _mapVerificationCodeChangedToState(
      VerificationCodeChanged event, VerificationState state) {
    final code = VerificationCode.dirty(event.code);
    return state.copyWith(code: code, codeStatus: Formz.validate([code]));
  }

  Stream<VerificationState> _mapVerifyCodeEventToState(
      VerifyCodeEvent event) async* {
    yield state.copyWith(verificationStatus: VerificationStatus.verifyingCode);
    try {
      await _authenticationRepository.verifyPhoneCode(
          state.verificationId, event.code);
      yield state.copyWith(
          verificationStatus: VerificationStatus.codeVerified);
    } catch (e) {
      yield state.copyWith(
          errorMessage: 'Verification Failed',
          verificationStatus: VerificationStatus.codeRejected);
    }
  }

  Stream<VerificationState> _mapSendCodeEventToState(
      SendCodeEvent event) async* {
    yield state.copyWith(verificationStatus: VerificationStatus.sendingCode);
    try {
      Tuple2 result =
      await _authenticationRepository.sendPhoneCode(event.phoneNumber);
      yield state.copyWith(
          verificationId: result.item1,
          verificationStatus: VerificationStatus.requestingCode);
    } catch (e) {
      yield state.copyWith(
          errorMessage: e.toString(),
          verificationStatus: VerificationStatus.requestingPhone);
    }
  }

/*void verificationCodeChanged(String code) {
    final verificationCode = VerificationCode.dirty(code);
    emit(state.copyWith(
        verificationCode: verificationCode,
        status: Formz.validate([verificationCode])));
  }

  Future<void> verifyCode() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      // send validation code to server here
      await _authenticationRepository.loginWithEmailAndPassword(
          email: 'email@email.com', password: '12');
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }*/
}
