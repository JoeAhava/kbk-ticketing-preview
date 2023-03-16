part of 'fav_list_bloc.dart';

class FavEventListState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavEventListLoading extends FavEventListState {}

class FavEventListLoaded extends FavEventListState {
  final List<Event> events;

  FavEventListLoaded(this.events);
}

class FavEventListFailed extends FavEventListState {
  final String message;

  FavEventListFailed(this.message);
}
