import 'package:equatable/equatable.dart';
import 'package:ticketing/vo/user.dart';

import 'event.dart';

class Ticket extends Equatable {
  final String id;
  final User user;
  final Event event;
  final int amount;

  Ticket({
    this.id,
    this.event,
    this.amount,
    this.user,
  });

  @override
  List<Object> get props => [id, amount];
}
