import 'package:flutter/material.dart';

class EventStatusLinear extends StatelessWidget{

  EventStatusLinear(this.title, this.usedValue, this.totalValue, this.statusMessage);

  final String title;
  final int usedValue;
  final int totalValue;
  final String statusMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
          Container(height: 10,),
          RichText(
            text: TextSpan(
              text: "$usedValue/$totalValue ",
              style: TextStyle(color: Colors.lightBlueAccent),
              children: [
                TextSpan(
                  text: statusMessage
                )
              ]
            ),
          ),
          Container(height: 5,),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: usedValue/totalValue,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
            ),
          )
        ],
      ),
    );
  }
}