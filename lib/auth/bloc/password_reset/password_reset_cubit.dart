import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/formz/email.dart';

part 'password_reset_state.dart';

enum ResetStatus { sending, sent, failed, none}

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const PasswordResetState());

  final AuthenticationRepository _authenticationRepository;

  Future<void> passwordReset(String email) async {
    emit(state.copyWith(status: ResetStatus.sending));
    try {
      await _authenticationRepository.sendResetEmail(email);
      emit(state.copyWith(status: ResetStatus.sent));
    } on NoSuchMethodError {
      emit(state.copyWith(status: ResetStatus.failed));
    } catch(e) {
      throw e;
      // emit(state.copyWith(status: ResetStatus.failed));
    }
  }
}
