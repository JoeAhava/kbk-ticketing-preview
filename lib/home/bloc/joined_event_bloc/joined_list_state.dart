part of 'joined_list_bloc.dart';

class JoinedEventListState extends Equatable {
  @override
  List<Object> get props => [];
}

class JoinedEventListLoading extends JoinedEventListState {}

class JoinedEventListLoaded extends JoinedEventListState {
  final List<Event> events;

  JoinedEventListLoaded(this.events);
}

class JoinedEventListFailed extends JoinedEventListState {
  final String message;

  JoinedEventListFailed(this.message);
}
