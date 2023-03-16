part of 'event_list_bloc.dart';

class EventListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEventList extends EventListEvent {
  final String categoryId;

  LoadEventList(this.categoryId);
}

class LoadEventListByDate extends EventListEvent {
  final DateTime date;
  final Category category;
  final SubCategory sub;

  LoadEventListByDate(this.date, {this.category, this.sub});
}

class LoadJoinedEventList extends EventListEvent {}

class LoadCancelledEventList extends EventListEvent {}
