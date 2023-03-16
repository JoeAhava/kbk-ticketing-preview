import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ScheduleState extends Equatable{

  ScheduleState({@required this.selected});

  final DateTime selected;

  @override
  List<Object> get props => [selected];

}