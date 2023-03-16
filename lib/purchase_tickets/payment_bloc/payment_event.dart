part of 'payment_bloc.dart';

class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Pay extends PaymentEvent {
  final Event ticketEvent;
  final int amount;
  final int additionalCharge;
  final String order_id;
  Pay({this.ticketEvent, this.amount, this.order_id, this.additionalCharge = 0}) : super();
}
