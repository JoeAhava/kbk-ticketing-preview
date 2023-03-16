import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/bloc/edit_bio_and_location/edit_bio_and_location_state.dart';

class EditBioAndLocationCubit extends Cubit<EditBioAndLocationState> {
  EditBioAndLocationCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(EditBioAndLocationState(false));

  final AuthenticationRepository _authenticationRepository;


  Future<bool> updateBioAndLocation(String bio, String location, String id) async{
    emit(EditBioAndLocationState(true));
    try{
      await _authenticationRepository.updateBioAndLocation(bio,location,id);
      emit(EditBioAndLocationState(false));
      return true;
    } catch (e){
      emit(EditBioAndLocationState(false));
      return false;
    }
  }


}
