import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/event.dart';

part 'waiting_list_event.dart';
part 'waiting_list_state.dart';

class WaitingListBloc
    extends Bloc<WaitingEventListEvent, WaitingEventListState> {
  final HomeRepository _homeRepository;

  WaitingListBloc(this._homeRepository) : super(WaitingEventListLoading());

  @override
  Stream<WaitingEventListState> mapEventToState(
      WaitingEventListEvent event) async* {
    try {
      // We only have one event for now
      if (event is LoadWaitingEventList) {
        // Get the list of events by category name
        List<Event> events = await _homeRepository.getWaitingEventsByUser();
        yield WaitingEventListLoaded(events);
      }
    } catch (ex) {
      // throw ex;
      yield WaitingEventListFailed(ex);
    }
  }
}
