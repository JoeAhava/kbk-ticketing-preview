import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          elevation: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10.0),
                        color: Colors.lightBlue,
                      ),
                      child: Image.asset("assets/avatar.png", width: 85, height: 70,),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fiker Yashenfa",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 3,),
                        Text("Teddy Afro | 11:00",style: TextStyle(color: Color(0XFFc2c9d2)),),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(10) ),
                  color: Colors.lightBlue,
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 18.0),
                  child: Text(
                    "11 Hours ago",
                    style: TextStyle(color: Colors.white,fontSize:12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
