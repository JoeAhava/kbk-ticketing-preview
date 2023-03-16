import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_email/edit_email_state.dart';

class EditEmailCubit extends Cubit<EditEmailState> {
  EditEmailCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(EditEmailState(false));

  final AuthenticationRepository _authenticationRepository;

  Future<bool> updateEmail(String email) async {
    emit(EditEmailState(true));
    try {
      await _authenticationRepository.updateEmail(email);
      emit(EditEmailState(false));
      return true;
    } catch (e) {
      emit(EditEmailState(false));
      return false;
    }
  }
}
