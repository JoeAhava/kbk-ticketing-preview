import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, QueryDocumentSnapshot, Timestamp;
import 'package:equatable/equatable.dart';

enum EventStatus { JOINED, CANCELLED, WAITING, NONE }

class EventLocation extends Equatable {
  final String name;
  final double lat;
  final double lng;

  const EventLocation({this.name, this.lat, this.lng});

  @override
  List<Object> get props => [name];
}

class EventOrganizer extends Equatable {
  final String name;
  final String description;
  final String email;
  final String facebook;
  final String twitter;
  final String phone;

  const EventOrganizer(
      {this.name,
      this.description,
      this.email,
      this.facebook,
      this.twitter,
      this.phone});

  @override
  List<Object> get props =>
      [name, description, email, facebook, twitter, phone];
}

class Event extends Equatable {
  final String id;
  final String title;
  final double price;
  final int amount;
  final List<String> categories;
  final String description;
  final String imageUrl;
  final String trailer;
  final EventLocation location;
  final EventOrganizer organizer;
  final DateTime eventStartDateTime;
  final DateTime eventEndDateTime;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const Event({
    this.id,
    this.title,
    this.price,
    this.categories,
    this.description,
    this.imageUrl,
    this.trailer,
    this.location,
    this.organizer,
    this.eventStartDateTime,
    this.eventEndDateTime,
    this.createdAt,
    this.modifiedAt,
    this.amount,
  });

  @override
  List<Object> get props => [id];

  Event copyWith({
    String id,
    String title,
    double price,
    int amount,
    List<String> categories,
    String description,
    String imageUrl,
    String trailer,
    EventLocation location,
    EventOrganizer organizer,
    DateTime eventStartDateTime,
    DateTime eventEndDateTime,
    DateTime createdAt,
    DateTime modifiedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      trailer: imageUrl ?? this.trailer,
      location: location ?? this.location,
      organizer: organizer ?? this.organizer,
      eventStartDateTime: eventStartDateTime ?? this.eventStartDateTime,
      eventEndDateTime: eventEndDateTime ?? this.eventEndDateTime,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      amount: amount ?? this.amount,
    );
  }

  static Event fromQueryDocumentSnapshot(QueryDocumentSnapshot d) {
    Map<String, dynamic> data = d.data();

    var loc = (data ?? const {})['location'] ?? const {};
    var location =
        EventLocation(name: loc['name'], lat: loc['lat'], lng: loc['lng']);

    var org = (data ?? const {})['organizer'] ?? const {};
    var organizer = EventOrganizer(
        name: org['name'],
        description: org['description'],
        email: org['email'],
        facebook: org['facebook'],
        twitter: org['twitter'],
        phone: org['phone']);

    double price = 0;
    int amount = 0;
    try {
      price = double.parse(data['price'].toString());
      amount = int.parse(data['amount'].toString());
    } on Error {}

    List<String> categories = List<String>.from(data['categories'] ?? []);

    return Event(
      id: d.id,
      title: data['title'],
      amount: amount,
      price: price,
      description: data['description'],
      imageUrl: data['imageUrl'] ?? null,
      trailer: data['trailer'] ?? null,
      categories: categories,
      location: location,
      organizer: organizer,
      eventStartDateTime: (data['eventStartDateTime'] as Timestamp)?.toDate(),
      eventEndDateTime: (data['eventEndDateTime'] as Timestamp)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp)?.toDate(),
    );
  }

  static Event fromDocumentSnapshot(DocumentSnapshot d) {
    Map<String, dynamic> data = d.data();

    var loc = (data ?? const {})['location'] ?? const {};
    var location =
        EventLocation(name: loc['name'], lat: loc['lat'], lng: loc['lng']);

    var org = (data ?? const {})['organizer'] ?? const {};
    var organizer = EventOrganizer(
        name: org['name'],
        description: org['description'],
        email: org['email'],
        facebook: org['facebook'],
        twitter: org['twitter'],
        phone: org['phone']);

    double price = 0;
    int amount = 0;
    try {
      price = double.parse(data['price'].toString());
      amount = int.parse(data['amount'].toString());
    } catch (err) {
      throw err;
    }

    List<String> categories = List<String>.from(data['categories'] ?? []);

    return Event(
      id: d.id,
      title: data['title'],
      amount: amount,
      price: price,
      description: data['description'],
      imageUrl: data['imageUrl'] ?? null,
      trailer: data['trailer'] ?? null,
      categories: categories,
      location: location,
      organizer: organizer,
      eventStartDateTime: (data['eventStartDateTime'] as Timestamp)?.toDate(),
      eventEndDateTime: (data['eventEndDateTime'] as Timestamp)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp)?.toDate(),
    );
  }
}
