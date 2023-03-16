part of 'waiting_list_bloc.dart';

class WaitingEventListState extends Equatable {
  @override
  List<Object> get props => [];
}

class WaitingEventListLoading extends WaitingEventListState {}

class WaitingEventListLoaded extends WaitingEventListState {
  final List<Event> events;

  WaitingEventListLoaded(this.events);
}

class WaitingEventListFailed extends WaitingEventListState {
  final String message;

  WaitingEventListFailed(this.message);
}
