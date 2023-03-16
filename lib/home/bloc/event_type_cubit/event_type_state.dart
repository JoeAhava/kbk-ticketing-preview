part of 'event_type_cubit.dart';

class EventTypeState extends Equatable {
  EventTypeState({this.type = null});
  final EventType type;

  @override
  List<Object> get props => [type];
}
