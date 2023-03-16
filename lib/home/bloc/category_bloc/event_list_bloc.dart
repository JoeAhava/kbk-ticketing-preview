import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final HomeRepository _homeRepository;

  CategoryBloc(this._homeRepository) : super(CategoryLoading());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    try {
      yield (CategoryLoading());
      // We only have one event for now
      if (event is LoadCategory) {
        // Get the list of events by category name
        Category category = event.category;
        yield CategoryLoaded(category);
      }
    } catch (ex) {
      throw ex;
      // yield CategoryFailed(ex.toString());
    }
  }
}
