import 'package:flutter/material.dart';
import 'package:ticketing/events/ui/single_event/ticket_summary_item.dart';

class TicketSummary extends StatelessWidget{
  static Route route() {
    return MaterialPageRoute(builder: (_) => TicketSummary());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets Summary"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context,int index){
          return TicketSummaryItem();
        },
      ),
    );
  }
}