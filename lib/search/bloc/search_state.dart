part of 'search_bloc.dart';

class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResultsLoaded extends SearchState {
  final List<Event> events;

  SearchResultsLoaded(this.events);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
