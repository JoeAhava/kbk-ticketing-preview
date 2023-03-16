import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketing/home/models/event.dart';

class EventsRepo {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<List<Event>> getMyEvents() async {
    String currentUserId = auth.currentUser.uid;
    QuerySnapshot snapshot =
        await db.collection("users/$currentUserId/events").get();
    return snapshot.docs
        .map((d) => Event.fromQueryDocumentSnapshot(d))
        .toList();
  }

  Future<List<Event>> getEventsByUser() async {
    String userId = auth.currentUser.uid;
    DocumentSnapshot snapshotUser =
        await db.collection('users').doc(userId).get();
    Map<String, dynamic> data = snapshotUser.data();
    List<String> eventIds = data['tickets'] ?? [];
    DocumentSnapshot eventSnapshot;
    List<Event> events;
    eventIds.map((e) async {
      eventSnapshot = await db.collection('events').doc('$e').get();
      events.add(Event.fromQueryDocumentSnapshot(eventSnapshot));
    }).toList();
    return events;
  }

  Future<void> publishEvent(String title,
      {String description,
      DateTime startDateTime,
      DateTime endDateTime,
      double price,
      File image = null}) async {
    // Save the event
    final String currentUserId = auth.currentUser.uid;
    if (currentUserId == null) throw Exception('Unauthenticated');

    // Get current user bio
    String bio;
    final userDetailsSnapshot = await db.doc("users/$currentUserId").get();
    if (userDetailsSnapshot.exists) {
      bio = userDetailsSnapshot.data()["bio"];
    }

    final organizer = {
      "name": auth.currentUser.displayName,
      "email": auth.currentUser.email,
    };
    if (auth.currentUser.phoneNumber != null)
      organizer["phone"] = auth.currentUser.phoneNumber;
    if (bio?.isNotEmpty ?? false) organizer["description"] = bio;

    db.collection("users/$currentUserId/events").add({
      "title": title,
      "description": description,
      "eventStartDateTime": startDateTime,
      "eventEndDateTime": endDateTime,
      "organizer": organizer,
      "price": price,
      "createdAt": FieldValue.serverTimestamp()
    });
    if (image != null) {
      // Attempt to upload image
    }
  }
}
