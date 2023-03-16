import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/repo/events_repo.dart';
import 'package:ticketing/events/ui/list/bloc/my_events_state.dart';
import 'package:ticketing/vo/resource.dart';

class MyEventsCubit extends Cubit<MyEventsState> {
  EventsRepo _repo;

  MyEventsCubit(this._repo)
      : super(MyEventsState(eventsResource: Resource.loading())) {
    getMyEvents();
  }

  void getMyEvents() async {
    try {
      emit(MyEventsState(eventsResource: Resource.loading()));
      final events = await _repo.getMyEvents();
      emit(MyEventsState(eventsResource: Resource.success(events)));
    } catch (ex) {
      emit(MyEventsState(eventsResource: Resource.error(ex.toString())));
    }
  }
}
