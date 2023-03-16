part of 'single_event_bloc.dart';

class SingleEventState extends Equatable {
  final Event event;
  SingleEventState(this.event) : super();
  @override
  List<Object> get props => [event];
}

class SingleEventChecking extends SingleEventState {
  final Event event;
  SingleEventChecking(this.event) : super(event);
  SingleEventState copyWith(Event event) {
    return SingleEventState(event);
  }
}

class SingleEventLoaded extends SingleEventState {
  final Event event;
  final bool favorite;
  final TicketType ticketType;
  final String order_id;
  final int amount;

  SingleEventLoaded(this.event,
      {this.favorite, this.ticketType, this.order_id = null, this.amount = 0})
      : super(event);
}

class SingleEventFailed extends SingleEventState {
  final Event event;
  final String message;

  SingleEventFailed(this.message, this.event) : super(event);
}
