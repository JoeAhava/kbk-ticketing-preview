import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_display_name/edit_display_name_state.dart';

class EditDisplayNameCubit extends Cubit<EditDisplayNameState> {
  EditDisplayNameCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(EditDisplayNameState(false));

  final AuthenticationRepository _authenticationRepository;


  Future<bool> updateDisplayName(String name) async{
    emit(EditDisplayNameState(true));
    try{
      await _authenticationRepository.updateDisplayName(name);
      emit(EditDisplayNameState(false));
      return true;
    } catch (e){
      emit(EditDisplayNameState(false));
      return false;
    }
  }


}
