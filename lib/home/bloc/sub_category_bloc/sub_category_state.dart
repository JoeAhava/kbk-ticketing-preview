part of 'sub_category_bloc.dart';

class SubCategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class SubCategoryLoading extends SubCategoryState {}

class SubCategoryLoaded extends SubCategoryState {
  final SubCategory subCategory;

  SubCategoryLoaded(this.subCategory);
}

class SubCategoryFailed extends SubCategoryState {
  final String message;

  SubCategoryFailed(this.message);
}
