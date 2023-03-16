import 'package:flutter/material.dart';
import 'package:ticketing/events/ui/single_event/cancelled_bookings.dart';
import 'package:ticketing/events/ui/single_event/event_status_circular.dart';
import 'package:ticketing/events/ui/single_event/event_status_linear.dart';
import 'package:ticketing/events/ui/single_event/ticket_summary.dart';
import 'package:ticketing/events/ui/single_event/tickets_check_in.dart';
import 'package:ticketing/events/ui/single_event/waiting_list.dart';

class TotalSales extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 5.0,
            child: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(child: Center(child: Text("Total Sales",style: TextStyle(fontSize: 16.0),))),
                    ],
                  ),
                  Container(height: 30,),
                  Row(
                    children: [
                      Expanded(child: Center(child: Text("1250 ETB",style: TextStyle(fontSize:40.0,fontWeight: FontWeight.bold),))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 5.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Expanded(child: InkWell(child: EventStatusLinear("Ticket Summary", 20, 100, "Tickets Sold"),onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => TicketSummary()));
                    },)),
                    Expanded(child: InkWell(child: EventStatusLinear("Total Check in", 20, 100, "Tickets Sold"),onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => TicketCheckIn()));
                    },)),
                  ],
                ),
                Container(height: 30,),
                Row(
                  children: [
                    Expanded(child: InkWell(child: EventStatusCircular("Waiting List",100, 100, "Are Waiting"),onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => WaitingList()));
                    },)),
                    Expanded(child: InkWell(child: EventStatusCircular("Cancelled Bookings",50, 100, "Refund Raised"),onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => CancelledBookings()));
                    },)),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}