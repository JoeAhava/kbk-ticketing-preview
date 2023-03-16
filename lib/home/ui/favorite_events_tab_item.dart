import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticketing/home/bloc/favorite_event_bloc/fav_list_bloc.dart';
import 'package:ticketing/home/bloc/single_event_bloc/single_event_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/single_event_page.dart';

class FavoriteEventsTabItem extends StatelessWidget {
  final Event event;
  FavoriteEventsTabItem(this.event);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SingleEventBloc(HomeRepository(), event),
      child: _Item(event: event,),
    );
  }
}


class _Item extends StatelessWidget{
  final Event event;
  _Item({this.event});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
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
                                    '${event.organizer?.name ?? ''}' ??
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
                                    event.location?.name ?? "Location Unknown",
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
                right: 8,
                bottom: 8,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: InkWell(
                      onTap: () {
                        print('NOT FAV');
                        context.read<SingleEventBloc>().add(ToggleFav(false));
                        context.read<FavListBloc>().add(LoadFavEventList());
                      },
                      child: Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.white,
                        size: 15.0,
                      ),
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
                  status: EventStatus.JOINED,
                  event: event,
                ),
              ),
            );
          },
        ),
      );
  }
}