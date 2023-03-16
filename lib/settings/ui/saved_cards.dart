import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/utils.dart';

class SavedCards extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SavedCards());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text($t(context, 'account.saved_cards')),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 16),
          Text(
            $t(context, 'account.saved_cards'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 16),
          _SingleCard(),
          _SingleCard(),
        ],
      ),
    );
  }
}

class _SingleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.credit_card,
                      color: Theme.of(context).primaryColor),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Names',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '****1234',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  SizedBox(width: 10),
                  Icon(Icons.delete, color: Theme.of(context).primaryColor),
                ],
              )
            ],
          )),
    );
  }
}
