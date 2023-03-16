import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/purchase_tickets/payment_bloc/payment_bloc.dart';
import 'package:ticketing/purchase_tickets/repo/tickets_repo.dart';
import 'package:ticketing/purchase_tickets/ui/paypal_payment.dart';
import 'package:ticketing/purchase_tickets/ui/ticket_summary.dart';
import 'package:ticketing/purchase_tickets/ui/yenepay_payment.dart';

class PaymentPlatform extends StatefulWidget {
  final Event event;

  PaymentPlatform({this.event});

  @override
  _PaymentPlatformState createState() => _PaymentPlatformState();
}

class _PaymentPlatformState extends State<PaymentPlatform> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> extras = [];

  @override
  Widget build(BuildContext context) {
    if (this.extras.length <= 0) {
      context.read<TicketCubit>().state.additionalCharge.forEach(
            (extra) => extra.entries.forEach(
              (entry) {
                this.setState(
                  () {
                    extras.add(
                      Map.from(
                        {
                          "itemId": entry?.key?.id ?? "",
                          "itemName": entry?.key?.name ?? "",
                          "unitPrice": entry?.key?.price ?? "",
                          "quantity": entry.value ?? "",
                        },
                      ),
                    );
                    print("Extras");
                    print(extras);
                  },
                );
              },
            ),
          );
    }
    return BlocProvider<PaymentBloc>(
      create: (_) => PaymentBloc(TicketsRepo(), PaymentInitial()),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // duration: Duration(seconds: 2),
                content: Text(
                  'Payment was successful!',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.lightGreen,
                padding: EdgeInsets.all(12.0),
              ),
            );
            print('PAYMENT - DONE ! ${state.order_id}');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext ctx) => BlocProvider.value(
                      value: context.read<TicketCubit>(),
                      child: TicketSummary(
                          event: widget.event, order_id: state.order_id),
                    )));
            /* .pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext ctx) => BlocProvider.value(
                        value: context.read<TicketCubit>(),
                        child: TicketSummary(
                            event: event, order_id: state.order_id),
                      )),
              (Route<dynamic> route) => route is TicketSummary,
            );*/
          }
        },
        builder: (context, state) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Payment Method"),
          ),
          body: SafeArea(
            child: state is PaymentProcessing
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            print(context.read<TicketCubit>().state.amount);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext ctx) {
                                  return BlocProvider.value(
                                    value: context.read<TicketCubit>(),
                                    child: PaypalPayment(
                                      event: widget.event,
                                      amount: context
                                          .read<TicketCubit>()
                                          .state
                                          .amount,
                                      extras_raw: context
                                              .read<TicketCubit>()
                                              .state
                                              .additionalCharge ??
                                          [],
                                      onFinish: (number, {error}) async {
                                        if (number != null) {
                                          if ((widget.event?.amount ?? 0) >
                                              BlocProvider.of<TicketCubit>(
                                                context,
                                                listen: false,
                                              ).state.amount) {
                                            context.read<PaymentBloc>().add(
                                                  Pay(
                                                    order_id: number,
                                                    ticketEvent: widget.event,
                                                    amount: context
                                                        .read<TicketCubit>()
                                                        .state
                                                        .amount,
                                                  ),
                                                );
                                          } else {
                                            showDialog(
                                              context:
                                                  _scaffoldKey.currentContext,
                                              builder: (_) => AlertDialog(
                                                title: Text(
                                                    'Requested more tickets !'),
                                                content: Text(
                                                  'The requested ticket amount is more than the available !\nRequested : ${context.read<TicketCubit>().state.amount} tickets\nLeft : ${widget.event?.amount ?? 0} tickets\n\nWould you like to book ${context.read<TicketCubit>().state.amount - (widget.event?.amount ?? 0)} tickets for waiting ?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        _onPressedAction(
                                                            context),
                                                    child: Text('Continue'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Payment Failed! \n${error ?? ''} ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red[500],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/paypal.png",
                                        width: 70,
                                        height: 70,
                                      ),
                                      Container(
                                        width: 20,
                                      ),
                                      Text(
                                        "PayPal",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.navigate_next),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext ctx) {
                                  print(
                                      "Extras Paymen Platform length - ${this.extras.length}");
                                  print(this.extras);
                                  return BlocProvider.value(
                                    value: context.read<TicketCubit>(),
                                    child: YenePayPayment(
                                      event: widget.event,
                                      amount: context
                                          .read<TicketCubit>()
                                          .state
                                          .amount,
                                      extras: this.extras ?? [],
                                      onFinish: (number, {error}) async {
                                        if (number != null) {
                                          if ((widget.event?.amount ?? 0) >
                                              context
                                                  .read<TicketCubit>()
                                                  .state
                                                  .amount) {
                                            context.read<PaymentBloc>().add(
                                                  Pay(
                                                    order_id: number,
                                                    ticketEvent: widget.event,
                                                    amount: context
                                                        .read<TicketCubit>()
                                                        .state
                                                        .amount,
                                                  ),
                                                );
                                          } else {
                                            showDialog(
                                              context:
                                                  _scaffoldKey.currentContext,
                                              builder: (_) => AlertDialog(
                                                title: Text(
                                                    'Requested more tickets !'),
                                                content: Text(
                                                  'The requested ticket amount is more than the available !\nRequested : ${context.read<TicketCubit>().state.amount} tickets\nLeft : ${widget.event?.amount ?? 0} tickets\n\nWould you like to book ${context.read<TicketCubit>().state.amount - (widget.event?.amount ?? 0)} tickets for waiting ?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        _onPressedAction(
                                                            context),
                                                    child: Text('Continue'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          // payment done
                                          // print('order id: ' + number);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Payment Failed! \n${error ?? ''} ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red[500],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/yenepay_logo.png",
                                        width: 70,
                                        height: 70,
                                      ),
                                      Container(
                                        width: 20,
                                      ),
                                      Text(
                                        "YenePay",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.navigate_next),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Card(
                      //     elevation: 5.0,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Row(
                      //             children: [
                      //               Image.asset(
                      //                 "assets/hellocash.png",
                      //                 width: 70,
                      //                 height: 70,
                      //               ),
                      //               Container(
                      //                 width: 20,
                      //               ),
                      //               Text(
                      //                 "HelloCash",
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               )
                      //             ],
                      //           ),
                      //           Icon(Icons.navigate_next),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _onPressedAction(BuildContext context) {
    int amountForWaiting = BlocProvider.of<TicketCubit>(
          context,
          listen: true,
        ).state.amount -
        (widget.event?.amount ?? 0);
    if ((widget.event?.amount ?? 0) >= 1) {
      context.read<TicketCubit>().changeAmount(widget.event.amount);
      context.read<TicketCubit>().bookTicket();
    }
    context.read<TicketCubit>().changeAmount(amountForWaiting.abs());
    context.read<TicketCubit>().bookWaitingTicket();
    if (context.watch<TicketCubit>().state.networkStatus !=
        TicketNetworkStatus.created) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment was successful!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightGreen,
        ),
      );
    }
  }
}
