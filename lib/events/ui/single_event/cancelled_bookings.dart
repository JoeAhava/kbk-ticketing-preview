import 'package:flutter/material.dart';
import 'package:ticketing/events/ui/single_event/cancelled_bookings_item.dart';

class CancelledBookings extends StatelessWidget{
  static Route route() {
    return MaterialPageRoute(builder: (_) => CancelledBookings());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancelled Bookings"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context,int index){
          return CancelledBookingsItem(index);
        },
      ),
    );
  }
}