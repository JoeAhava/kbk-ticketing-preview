import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/utils.dart';

class PaymentOptions extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => PaymentOptions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text($t(context, 'account.payment_options')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _SingleCard('Card Payment',
              leading:
                  Image(width: 50, image: AssetImage('assets/credit.png'))),
          _SingleCard('Paypal',
              leading:
                  Image(width: 50, image: AssetImage('assets/paypal.png'))),
          _SingleCard('Mobile Birr',
              leading: Image(width: 50, image: AssetImage('assets/mbirr.png'))),
          _SingleCard('Hello Cash',
              leading:
                  Image(width: 50, image: AssetImage('assets/hellocash.png'))),
        ],
      ),
    );
  }
}

class _SingleCard extends StatelessWidget {
  final Widget leading;
  final String title;

  _SingleCard(this.title, {this.leading});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21, vertical: 21),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                leading != null ? leading : SizedBox(width: 10, height: 10),
                SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
              Icon(Icons.chevron_right)
            ],
          )),
    );
  }
}
