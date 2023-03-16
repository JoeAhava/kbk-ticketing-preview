import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/bloc/schedule_cubit/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleState(selected: null));

  void pickDate(DateTime picked) {
    emit(ScheduleState(selected: picked));
  }
}
