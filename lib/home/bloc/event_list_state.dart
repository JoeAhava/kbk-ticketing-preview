part of 'event_list_bloc.dart';

class EventListState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventListLoading extends EventListState {}

class JoinedEventListLoading extends EventListState {}

class CancelledEventListLoading extends EventListState {}

class EventListLoaded extends EventListState {
  final List<Event> events;

  EventListLoaded(this.events);
}

class JoinedEventListLoaded extends EventListState {
  final List<Event> events;

  JoinedEventListLoaded(this.events);
}

class CancelledEventListLoaded extends EventListState {
  final List<Event> events;

  CancelledEventListLoaded(this.events);
}

class EventListFailed extends EventListState {
  final String message;

  EventListFailed(this.message);
}
