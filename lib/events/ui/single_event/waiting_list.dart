import 'package:flutter/material.dart';
import 'package:ticketing/events/ui/single_event/waiting_list_item.dart';

class WaitingList extends StatelessWidget{
  static Route route() {
    return MaterialPageRoute(builder: (_) => WaitingList());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Waiting List"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context,int index){
          return WaitingListItem();
        },
      ),
    );
  }
}