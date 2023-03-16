import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/event.dart';

part 'single_event_event.dart';
part 'single_event_state.dart';

class SingleEventBloc extends Bloc<SingleEventEvent, SingleEventState> {
  final HomeRepository _homeRepository;
  final Event event;

  SingleEventBloc(this._homeRepository, this.event)
      : super(SingleEventChecking(event));

  @override
  Stream<SingleEventState> mapEventToState(SingleEventEvent event) async* {
    try {
      if (event is CheckStatus) {
        yield SingleEventChecking(this.event.copyWith());
        Event eventResult = await _homeRepository.getEvent(state.event.id);
        print('Event Fetched ${eventResult}');

        if (eventResult == null) {
          yield SingleEventFailed("Event not found", state.event);
        }
        TicketType response = await _homeRepository.checkStatus(state.event.id);
        bool fav = await _homeRepository.checkFavorite(state.event.id);
        Map res = await _homeRepository.checkOrder(state.event.id);
        yield SingleEventLoaded(eventResult,
            favorite: fav,
            ticketType: response,
            order_id: res != null ? res['order_id'] : null,
            amount: res != null ? res['amount'] : null);
      } else if (event is ToggleFav) {
        yield SingleEventChecking(this.event.copyWith());
        bool fav = await _homeRepository.toggleFav(state.event.id, event.fav);
        Map res = await _homeRepository.checkOrder(state.event.id);
        TicketType response = await _homeRepository.checkStatus(state.event.id);
        bool updated;
        if (fav) {
          updated = await _homeRepository.checkFavorite(state.event.id);
        }
        yield SingleEventLoaded(state.event,
            favorite: updated,
            ticketType: response,
            order_id: res != null ? res['order_id'] : null,
            amount: res != null ? res['amount'] : null);
      } else if (event is FetchEvent) {
        yield SingleEventChecking(this.event.copyWith());
        Event eventResult = await _homeRepository.getEvent(state.event.id);
        if (eventResult != null)
          yield SingleEventLoaded(eventResult);
        else
          yield SingleEventFailed("Event not found", null);
      }
    } catch (ex) {
      throw ex;
      // yield SingleEventFailed(ex, state.event);
    }
  }
}
