import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/search/repository/search_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchRepository, SearchState initialState)
      : super(SearchEmpty());

  final SearchRepository _searchRepository;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is DoSearch) {
      //TODO search algolia here and and yield SearchResultsLoaded
      try {
        yield SearchLoading();
        final events = await _searchRepository.search(event.query);
        yield SearchResultsLoaded(events);
      } catch (ex) {
        print(ex);
        yield SearchError("Something is wrong");
      }
    }
  }
}
