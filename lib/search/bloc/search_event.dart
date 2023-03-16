part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DoSearch extends SearchEvent {
  final String query;

  DoSearch(this.query);
}
