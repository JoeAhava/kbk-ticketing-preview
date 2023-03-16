part of 'sub_category_bloc.dart';

class SubCategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSubCategory extends SubCategoryEvent {
  final SubCategory subCategory;

  LoadSubCategory(this.subCategory);
}
