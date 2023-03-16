import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/formz/email.dart';
import 'package:ticketing/formz/password.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> loginWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.loginWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.loginWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on NoSuchMethodError {
      emit(state.copyWith(status: FormzStatus.pure));
    } catch(e) {
      // throw e;
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
  // Future<void> passwordReset() async {
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     await _authenticationRepository.sendResetEmail(state.email.value);
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } on NoSuchMethodError {
  //     emit(state.copyWith(status: FormzStatus.pure));
  //   } catch(e) {
  //     // throw e;
  //     print(e.toString());
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }
}
