import 'package:flutter/material.dart';
import 'package:ticketing/events/ui/create/create_event_title.dart';
import 'package:ticketing/events/ui/single_event/single_event_details.dart';
import 'package:ticketing/events/ui/single_event/total_sales.dart';
import 'package:ticketing/home/models/event.dart';

class SingleEvent extends StatelessWidget{

  static Route route(Event event) {
    return MaterialPageRoute(builder: (_) => SingleEvent(event));
  }

  final Event event;

  SingleEvent(this.event);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child:Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(child: Text("Total Sales"),),
                Tab(child: Text("Event Details"),),
              ],
            ),
            title: Text("Lorem Ipsum Event"),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              TotalSales(),
              SingleEventDetails(event: event,),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor:Colors.blue,
                child: Icon(Icons.edit,color: Colors.white,),
                heroTag: null,
                onPressed: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => CreateEventTitle()));
                },
              ),
              Container(height: 10,),
              FloatingActionButton(
                backgroundColor:Colors.red,
                child: Icon(Icons.delete,color: Colors.white,),
                heroTag: null,
                onPressed: (){},
              ),

            ],
          ),
        ),
    );
  }
}