part of 'event_list_bloc.dart';

class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCategory extends CategoryEvent {
  final Category category;

  LoadCategory(this.category);
}
