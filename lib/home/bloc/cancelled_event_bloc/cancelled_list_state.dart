part of 'cancelled_list_bloc.dart';

class CancelledEventListState extends Equatable {
  @override
  List<Object> get props => [];
}

class CancelledEventListLoading extends CancelledEventListState {}

class CancelledEventListLoaded extends CancelledEventListState {
  final List<Event> events;

  CancelledEventListLoaded(this.events);
}

class CancelledEventListFailed extends CancelledEventListState {
  final String message;

  CancelledEventListFailed(this.message);
}
