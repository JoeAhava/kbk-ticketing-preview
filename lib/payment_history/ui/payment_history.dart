import 'package:flutter/material.dart';
import 'package:ticketing/payment_history/ui/paid.dart';
import 'package:ticketing/payment_history/ui/received.dart';
import 'package:ticketing/utils.dart';

class PaymentHistory extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => PaymentHistory(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text($t(context, 'payment.paid')),
                ),
                Tab(
                  child: Text($t(context, 'payment.received')),
                ),
              ],
            ),
            title: Text($t(context, 'payment.history')),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              Paid(),
              Received(),
            ],
          ),
        ));
  }
}
