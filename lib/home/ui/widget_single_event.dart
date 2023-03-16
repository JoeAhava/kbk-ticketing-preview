import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticketing/home/bloc/event_type_cubit/event_type_cubit.dart';
import 'package:ticketing/home/bloc/sub_category_bloc/sub_category_bloc.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/single_event_page.dart';

class SingleEventWidget extends StatelessWidget {
  final Event event;
  final EventType type;

  SingleEventWidget(this.event, {this.type});

  @override
  Widget build(BuildContext context) {
    print(event.amount);
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
                              child: (event.imageUrl != null &&
                                      (event.imageUrl?.length ?? 0) != 0)
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
                            Container(
                              width: 200,
                              child: Column(
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
                                    overflow: TextOverflow.ellipsis,
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    event.location.name ?? "Location Unknown",
                                    style: TextStyle(color: Color(0XFFc2c9d2)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                    color: !event.eventStartDateTime
                            .difference(new DateTime.now())
                            .inDays
                            .isNegative
                        ? Colors.lightBlue
                        : Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: !event.eventStartDateTime
                            .difference(new DateTime.now())
                            .inDays
                            .isNegative
                        ? Text(
                            "${event.eventStartDateTime.difference(new DateTime.now()).inDays} Days left",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "Date Passed",
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
            if (this.type == EventType.movies) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<SubCategoryBloc>(),
                    child: SingleEventPage(
                      status: EventStatus.JOINED,
                      event: event,
                      type: this.type,
                    ),
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SingleEventPage(
                    status: EventStatus.JOINED,
                    event: event,
                    type: this.type,
                  ),
                ),
              );
            }
          },
        ));
  }
}
