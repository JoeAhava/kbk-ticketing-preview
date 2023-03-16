import 'package:flutter/material.dart';

class Paid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: ((BuildContext context, int index) {
          return Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                              "assets/avatar.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer ID",
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 5,),
                          Text("Date/Time",style: TextStyle(color: Color(0XFFc2c9d2)),),
                          SizedBox(height: 5,),
                          Text(
                            "Transaction Id",
                            style: TextStyle(color: Color(0XFF5bb1f8)),
                          )
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "- 250 ETB",
                    style: TextStyle(color: Color(0XFFf92b61),fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
