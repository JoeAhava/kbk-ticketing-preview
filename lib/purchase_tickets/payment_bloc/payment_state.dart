part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentProcessing extends PaymentState {}

class PaymentSuccessful extends PaymentState {
  final String order_id;
  PaymentSuccessful(this.order_id);
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message) : super();
}
