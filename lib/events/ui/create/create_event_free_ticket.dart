import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_image.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';

class CrateEventFreeTicket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: Stack(fit: StackFit.expand, children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Enter detail and create a free ticket',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text('Ticket Name',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Lorem Ipsum',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.2)))),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.withOpacity(0.5)),
              ),
              SizedBox(height: 20),
              Text('Quantity Available',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: '100',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.2)))),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.withOpacity(0.5)),
              ),
              SizedBox(height: 20),
              Text('Prize', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'Free',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.2)))),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.withOpacity(0.5)),
              ),
              SizedBox(height: 20),
              Text('Ticket Start Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _DateTimePicker(),
              SizedBox(height: 20),
              Text('Ticket End Date',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _DateTimePicker(),
              SizedBox(height: 20),
              Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: '110',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.2)))),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.withOpacity(0.5)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.info, color: Theme.of(context).primaryColor),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                        'Is this different from the total quantity of your tickets',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Tickets a user can buy',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Min',
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.6)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.2)))),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.withOpacity(0.5)),
                  )),
                  SizedBox(width: 20),
                  Expanded(
                      child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Max',
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.6)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.2)))),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.withOpacity(0.5)),
                  ))
                ],
              )
            ],
          ),
        ),
        createEventPositionedNextButton(context, _navigateToCreateEventImage),
      ]),
    );
  }

  void _navigateToCreateEventImage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreateEventImage()));
  }
}

class _DateTimePicker extends StatelessWidget {
  final border =
      Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 1));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Date',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.withOpacity(0.5))),
              decoration: BoxDecoration(border: border),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () {
              showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Time',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.withOpacity(0.5))),
              decoration: BoxDecoration(border: border),
            ),
          ),
        )
      ],
    );
  }
}
