import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  final HomeRepository _homeRepository;

  EventListBloc(this._homeRepository) : super(EventListLoading());

  @override
  Stream<EventListState> mapEventToState(EventListEvent event) async* {
    try {
      yield (EventListLoading());
      // We only have one event for now
      if (event is LoadEventList) {
        // Get the list of events by category name
        List<Event> events =
            await _homeRepository.getEventsByCategoryId(event.categoryId);
        yield EventListLoaded(events);
      } else if (event is LoadEventListByDate) {
        List<Event> events = await _homeRepository.getEventsByDateFromCategory(
            date: event.date,
            category: event.category,
            subCategoryName: event.sub.name);
        yield EventListLoaded(events);
      }
      // else if (event is LoadJoinedEventList) {
      //   List<Event> events = await _homeRepository.getEventsByUser();
      //   yield JoinedEventListLoaded(events);
      // }
    } catch (ex) {
      throw ex;
      // yield EventListFailed(ex.toString());
    }
  }
}
