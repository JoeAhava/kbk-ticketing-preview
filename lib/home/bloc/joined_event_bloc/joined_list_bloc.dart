import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/event.dart';

part 'joined_list_event.dart';
part 'joined_list_state.dart';

class JoinedListBloc extends Bloc<JoinedEventListEvent, JoinedEventListState> {
  final HomeRepository _homeRepository;

  JoinedListBloc(this._homeRepository) : super(JoinedEventListLoading());

  @override
  Stream<JoinedEventListState> mapEventToState(
      JoinedEventListEvent event) async* {
    try {
      // We only have one event for now
      if (event is LoadJoinedEventList) {
        // Get the list of events by category name
        List<Event> events = await _homeRepository.getEventsByUser();
        yield JoinedEventListLoaded(events);
      }
    } catch (ex) {
      throw ex;
      // yield JoinedEventListFailed(ex);
    }
  }
}
