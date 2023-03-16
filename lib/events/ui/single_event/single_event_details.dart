import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleEventDetails extends StatelessWidget {
  static Route route(Event event) {
    return MaterialPageRoute(builder: (_) => SingleEventDetails(event: event));
  }

  SingleEventDetails({@required this.event});

  final Event event;

  // 'Thursday, Apr 12, 2019 @ 7:00 PM'
  final DateFormat formatter = DateFormat('EEEE, LLL dd, y @ HH:mm');

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Container(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 150),
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                  Row(children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.share_rounded,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue,
                      ),
                    ),
                  ])
                ],
              ),
              SizedBox(height: 10),
              Text(event?.organizer?.name ?? '',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('${event.price} ETB',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                event.description,
                style: TextStyle(
                  height: 1.3,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(FontAwesomeIcons.calendar),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Starts',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(formatter.format(event.eventStartDateTime),
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(height: 10),
                      Text(
                        'Event Ends',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(formatter.format(event.eventEndDateTime),
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(height: 10),
                      Text(
                        'Event Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text('Movie',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(width: 10),
                  /*FlatButton(
                      child: Text('Add',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor)),
                      padding: EdgeInsets.zero,
                      onPressed: () {}),*/
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      Text(
                        event.location.name,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        FontAwesomeIcons.paperPlane,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Organizer Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    child: Image.network(
                        'https://www.shareicon.net/data/512x512/2016/08/05/806962_user_512x512.png'),
                  ),
                  SizedBox(width: 10),
                  Text(event.organizer?.name,
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(height: 20),
              Text(
                event.organizer?.description?.substring(
                    0, min(event.organizer?.description?.length ?? 0, 200)),
                style: TextStyle(
                  height: 1.3,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Connect With',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w700)),
                  Row(
                    children: [
                      _SocialIcon(FontAwesomeIcons.facebookF,
                          event.organizer?.facebook),
                      SizedBox(width: 10),
                      _SocialIcon(
                          FontAwesomeIcons.twitter, event.organizer?.twitter),
                      SizedBox(width: 10),
                      _SocialIcon(FontAwesomeIcons.solidEnvelope,
                          event.organizer?.email),
                      SizedBox(width: 10),
                      _SocialIcon(FontAwesomeIcons.phoneAlt,
                          "tel://${event.organizer?.phone}"),
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData iconData;
  final String url;

  _SocialIcon(this.iconData, this.url);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(iconData, size: 15, color: Colors.grey),
        onPressed: () {
          _goToUrl(url);
        });
  }

  void _goToUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
    // else unable to launch url
  }
}
