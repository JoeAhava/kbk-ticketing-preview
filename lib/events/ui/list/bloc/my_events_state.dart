import 'package:equatable/equatable.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/vo/resource.dart';

class MyEventsState extends Equatable {
  final Resource<List<Event>> eventsResource;

  MyEventsState({this.eventsResource});

  @override
  List<Object> get props => [eventsResource];
}
