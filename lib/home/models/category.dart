import 'package:cloud_firestore/cloud_firestore.dart'
    show Timestamp, QueryDocumentSnapshot;
import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final String id;
  final List<DateTime> movieStartTime;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const Schedule(
      {this.id, this.movieStartTime, this.createdAt, this.modifiedAt});

  @override
  List<Object> get props => [movieStartTime];

  static Schedule fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return Schedule(
      id: snapshot.id,
      movieStartTime: data['schedules'],
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp)?.toDate(),
    );
  }
}

class Ad extends Equatable {
  final String id;
  final String link;
  final DateTime expires;
  final int count;

  const Ad({this.id, this.link, this.expires, this.count});

  @override
  List<Object> get props => [link, count];

  static Ad fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return Ad(
      id: snapshot.id,
      link: data['link'] ?? null,
      count: data['count'] ?? 3,
      expires: (data['expires'] as Timestamp)?.toDate(),
    );
  }
}

class Service extends Equatable {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const Service(
      {this.id,
      this.name,
      this.imageUrl,
      this.price,
      this.createdAt,
      this.modifiedAt});

  @override
  List<Object> get props => [name, price, createdAt, modifiedAt];

  static Service fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    double price = 0;
    try {
      price = double.parse(data['price'].toString());
    } on Error {}
    return Service(
      id: snapshot.id,
      name: data['name'],
      price: price ?? 0,
      imageUrl: data['imageUrl'] ?? null,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp)?.toDate(),
    );
  }
}

class SubCategory extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final List<Service> services;
  final List<Schedule> schedule;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const SubCategory(
      {this.id,
      this.name,
      this.imageUrl,
      this.services,
      this.schedule,
      this.createdAt,
      this.modifiedAt});

  @override
  List<Object> get props => [name, imageUrl, services, createdAt, modifiedAt];

  // static SubCategory fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
  //   return SubCategory(
  //     id: snapshot.id,
  //     name: snapshot.data()['name'],
  //     imageUrl: snapshot.data()['imageUrl'],
  //     createdAt: (snapshot.data()['createdAt'] as Timestamp)?.toDate(),
  //     modifiedAt: (snapshot.data()['modifiedAt'] as Timestamp)?.toDate(),
  //   );
  // }
}

class Category extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final List<Ad> ad;
  final List<SubCategory> subCategories;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const Category(
      {this.id,
      this.title,
      this.ad,
      this.imageUrl,
      this.subCategories,
      this.createdAt,
      this.modifiedAt});

  @override
  List<Object> get props =>
      [title, imageUrl, subCategories, createdAt, modifiedAt, ad];

  void addSubCategory(SubCategory sub) {
    this.subCategories.add(sub);
  }

  static Category fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    return Category(
      id: snapshot.id,
      title: data['name'],
      subCategories: [],
      ad: [],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp)?.toDate(),
    );
  }
}
