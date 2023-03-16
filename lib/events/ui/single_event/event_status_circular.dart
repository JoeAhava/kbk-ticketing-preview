import 'package:flutter/material.dart';

class EventStatusCircular extends StatelessWidget{

  EventStatusCircular(this.title,this.usedValue, this.totalValue, this.statusMessage);

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
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                child: Stack(
                  children: [
                    Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${(usedValue/totalValue) * 100}%",style: TextStyle(fontWeight: FontWeight.bold),),
                    )),
                    Positioned(top:0.0,left:0.0,right:0.0,bottom:0.0,child: CircularProgressIndicator(value: usedValue/totalValue,)),

                  ],
                ),
              ),
              Container(width: 10,),
              Text("$usedValue ${statusMessage.replaceAll(" ", "\n")}"),

            ],
          )
        ],
      ),
    );
  }
}