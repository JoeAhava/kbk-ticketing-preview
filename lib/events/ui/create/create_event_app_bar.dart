import 'package:flutter/material.dart';

final createEventAppBar = (context) => AppBar(
      shadowColor: Colors.transparent,
      title: Text('My Events'),
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
