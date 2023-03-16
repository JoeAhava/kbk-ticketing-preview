import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/event.dart';

part 'fav_list_event.dart';
part 'fav_list_state.dart';

class FavListBloc extends Bloc<FavEventListEvent, FavEventListState> {
  final HomeRepository _homeRepository;

  FavListBloc(this._homeRepository) : super(FavEventListLoading());

  @override
  Stream<FavEventListState> mapEventToState(FavEventListEvent event) async* {
    try {
      // We only have one event for now
      if (event is LoadFavEventList) {
        yield FavEventListLoading();
        // Get the list of events by category name
        List<Event> events = await _homeRepository.getFavEventsByUser();
        yield FavEventListLoaded(events);
      }
    } catch (ex) {
      yield FavEventListFailed(ex?.toString());
    }
  }
}
