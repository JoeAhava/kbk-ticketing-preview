part of 'ticket_cubit.dart';

enum TicketNetworkStatus { loading, created, error }
enum TicketType { waiting, joined, paid, cancelled, none }

class TicketState extends Equatable {
  final int amount;
  final List<Map<Service, int>> additionalCharge;
  final String event_id;
  final TicketNetworkStatus networkStatus;
  final TicketType type;

  TicketState({
    this.amount,
    this.event_id,
    this.additionalCharge = const [],
    this.networkStatus,
    this.type,
  });

  @override
  List<Object> get props => [
        event_id,
        amount,
        additionalCharge,
        networkStatus,
        type,
      ];
}
