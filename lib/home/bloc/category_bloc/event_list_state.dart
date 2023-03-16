part of 'event_list_bloc.dart';

class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final Category category;

  CategoryLoaded(this.category);
}

class CategoryFailed extends CategoryState {
  final String message;

  CategoryFailed(this.message);
}
