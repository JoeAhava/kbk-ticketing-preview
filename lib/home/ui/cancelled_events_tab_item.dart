import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/single_event_page.dart';

class CancelledEventsTabItem extends StatelessWidget {
  final Event event;
  CancelledEventsTabItem(this.event);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.transparent,
                                ),
                                child: event.imageUrl != null
                                    ? Image.network(
                                        event.imageUrl,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/avatar.png",
                                        width: 90,
                                        height: 90,
                                      ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title ?? "Fiker Yashenfa",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '${event.organizer.name}' ??
                                        "Teddy Afro | 11:00",
                                    style: TextStyle(color: Color(0XFFc2c9d2)),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    '${event.eventStartDateTime.hour < 12 ? event.eventStartDateTime.hour : (event.eventStartDateTime.hour / 2).round()}:${event.eventStartDateTime.minute} , ${DateFormat.yMMMd().format(event.eventStartDateTime).toString()} ' ??
                                        "",
                                    style: TextStyle(
                                      color: Color(0XFFc2c9d2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    event.location.name ?? "Location Unknown",
                                    style: TextStyle(color: Color(0XFFc2c9d2)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(10)),
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: Text(
                      'Cancelled',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleEventPage(
                  status: EventStatus.WAITING,
                  event: event,
                ),
              ),
            );
          },
        ));
  }
}
