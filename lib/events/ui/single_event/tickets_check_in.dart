import 'package:flutter/material.dart';
import 'package:ticketing/events/ui/single_event/scan_qr.dart';
import 'package:ticketing/events/ui/single_event/tickets_check_in_item.dart';

class TicketCheckIn extends StatelessWidget{
  static Route route() {
    return MaterialPageRoute(builder: (_) => TicketCheckIn());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tickets Check In"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context,int index){
          return TicketsCheckInItem();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF5bb1f8),
        onPressed: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ScanQr()));
        },
        child: Icon(Icons.settings_overscan,color: Colors.white,),
      ),
    );
  }
}