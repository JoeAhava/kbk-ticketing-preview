import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:tuple/tuple.dart';
import 'package:ticketing/formz/formz.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const SignupState());

  final AuthenticationRepository _authenticationRepository;

  void displayNameChanged(String value) {
    final displayName = DisplayName.dirty(value);
    emit(state.copyWith(
      displayName: displayName,
      status: Formz.validate([
        displayName,
        state.email,
        state.password,
        state.passwordConfirmation,
        state.phoneNumber
      ]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.displayName,
        email,
        state.password,
        state.passwordConfirmation,
        state.phoneNumber
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.displayName,
        state.email,
        password,
        state.passwordConfirmation,
        state.phoneNumber
      ]),
    ));
  }

  void passwordConfirmationChanged(String value) {
    final passwordConfirmation = PasswordConfirmation.dirty(
        Tuple2<String, String>(state.password.value, value));
    emit(state.copyWith(
      passwordConfirmation: passwordConfirmation,
      status: Formz.validate([
        state.displayName,
        state.email,
        state.password,
        passwordConfirmation,
        state.phoneNumber
      ]),
    ));
  }

  void phoneNumberChanged(String value) {
    final phoneNumber = PhoneNumber.dirty(value);
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      status: Formz.validate([
        state.displayName,
        state.email,
        state.password,
        state.passwordConfirmation,
        phoneNumber
      ]),
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
