import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/purchase_tickets/repo/tickets_repo.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(this._repo, PaymentState initialState) : super(initialState);
  final TicketsRepo _repo;
  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is Pay) {
      try {
        yield PaymentProcessing();
        await _repo.bookTicket(
          event.amount,
          event_id: event.ticketEvent.id,
          order_id: event.order_id,
        );
        yield PaymentSuccessful(event.order_id);
      } on TimeoutException catch (e) {
        print('Timeout Error: $e');
        yield PaymentError('Payment Failed - Check your connection');
      } on SocketException catch (e) {
        print('Socket Error: ${e.message}');
        yield PaymentError('Payment Failed - Check your connection');
      } catch (error) {
        yield PaymentError(error?.message ?? 'Payment Failed');
      }
    }
  }
}
