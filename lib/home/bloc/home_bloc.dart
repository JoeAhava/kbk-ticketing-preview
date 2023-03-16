import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._homeRepository) : super(HomeLoading());

  final HomeRepository _homeRepository;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    // we only have one event for now, let's map that
    if (event is LoadHome) {
      try {
        HomeData data = await _homeRepository.getData();
        yield HomeLoadSuccess(data);
      } catch (ex) {
        throw ex;
        yield HomeLoadFailed(ex);
      }
    }
  }
}
