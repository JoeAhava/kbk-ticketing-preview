import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_phone_number/edit_phone_number_state.dart';

class EditPhoneNumberCubit extends Cubit<EditPhoneNumberState> {
  EditPhoneNumberCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(EditPhoneNumberState(false));

  final AuthenticationRepository _authenticationRepository;


  Future<bool> updatePhoneNumber(String phoneNumber, BuildContext context) async{
    emit(EditPhoneNumberState(true));
    try{
      await _authenticationRepository.updatePhoneNumber(phoneNumber,context);
      emit(EditPhoneNumberState(false));
      return true;
    } catch (e){
      emit(EditPhoneNumberState(false));
      return false;
    }
  }


}
