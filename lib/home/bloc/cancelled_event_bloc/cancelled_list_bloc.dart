import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/event.dart';

part 'cancelled_list_event.dart';
part 'cancelled_list_state.dart';

class CancelledListBloc
    extends Bloc<CancelledEventListEvent, CancelledEventListState> {
  final HomeRepository _homeRepository;

  CancelledListBloc(this._homeRepository) : super(CancelledEventListLoading());

  @override
  Stream<CancelledEventListState> mapEventToState(
      CancelledEventListEvent event) async* {
    try {
      // We only have one event for now
      if (event is LoadCancelledEventList) {
        // Get the list of events by category name
        List<Event> events = await _homeRepository.getCancelledEventsByUser();
        yield CancelledEventListLoaded(events);
      }
    } catch (ex) {
      // throw ex;
      yield CancelledEventListFailed(ex);
    }
  }
}
