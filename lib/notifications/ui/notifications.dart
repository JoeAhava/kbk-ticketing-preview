import 'package:flutter/material.dart';
import 'package:ticketing/notifications/ui/notifications_item.dart';
import 'package:ticketing/utils.dart';

class Notifications extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => Notifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text($t(context, 'notification.appbar')),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return NotificationsItem();
        },
      ),
    );
  }
}
