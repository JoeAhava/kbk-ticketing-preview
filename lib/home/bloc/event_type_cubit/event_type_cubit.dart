import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_type_state.dart';

enum EventType { movies, sports, concerts }

class EventTypeCubit extends Cubit<EventTypeState> {
  EventTypeCubit() : super(EventTypeState());

  void changeType(EventType type) {
    emit(EventTypeState(type: type));
  }
}
