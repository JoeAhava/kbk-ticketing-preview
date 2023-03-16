import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';

part 'sub_category_event.dart';
part 'sub_category_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final HomeRepository _homeRepository;

  SubCategoryBloc(this._homeRepository) : super(SubCategoryLoading());

  @override
  Stream<SubCategoryState> mapEventToState(SubCategoryEvent event) async* {
    try {
      yield (SubCategoryLoading());
      // We only have one event for now
      if (event is LoadSubCategory) {
        // Get the list of events by category name
        SubCategory category = event.subCategory;
        yield SubCategoryLoaded(category);
      }
    } catch (ex) {
      throw ex;
      // yield CategoryFailed(ex.toString());
    }
  }
}
