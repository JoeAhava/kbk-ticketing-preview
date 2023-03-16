import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';

class HomeRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<HomeData> getData() async {
    QuerySnapshot snapshot = await _fireStore.collection('categories').get();
    var categories = snapshot.docs.map(
      (category) {
        Category cat = Category.fromQueryDocumentSnapshot(category);
        category.reference
            .collection('ads')
            .where('expires', isGreaterThanOrEqualTo: DateTime.now())
            .get()
            .then(
          (ads) {
            ads.docs.forEach(
              (e) {
                cat.ad.add(Ad.fromQueryDocumentSnapshot(e));
              },
            );
          },
        );
        category.reference.collection('providers').get().then((cinema) {
          cinema.docs.forEach((cinema) {
            SubCategory sub = SubCategory(
              id: cinema.id,
              name: cinema.data()['name'],
              schedule: [],
              services: [],
            );
            cinema.reference.collection('events').get().then((movie) {
              if (movie.docs.isNotEmpty) {
                movie.docs.forEach((m) {
                  Schedule sch = Schedule(id: m.id, movieStartTime: []);
                  List<dynamic> times = m.data()['schedules'];
                  times?.forEach((t) {
                    sch.movieStartTime.add((t as Timestamp)?.toDate());
                  });
                  sub.schedule.add(sch);
                });
              } else {
                return cat;
              }
            });
            cinema.reference.collection('services').get().then((movie) {
              if (movie.docs.isNotEmpty) {
                movie.docs.forEach((m) {
                  Service sch = Service.fromQueryDocumentSnapshot(m);
                  sub.services.add(sch);
                });
              } else {
                return cat;
              }
            });
            cat.addSubCategory(sub);
          });
        });
        return cat;
      },
    ).toList();
    snapshot = await _fireStore
        .collection('events')
        .where('featured', isEqualTo: true)
        .where('eventStartDateTime', isGreaterThanOrEqualTo: new DateTime.now())
        .get();
    var events = snapshot.docs
        .map(
          (d) => Event.fromQueryDocumentSnapshot(d),
        )
        .toList();
    return HomeData(categories: categories, events: events);
  }

  Future<List<Event>> getEventsByCategoryName(String categoryName) async {
    QuerySnapshot snapshot = await _fireStore
        .collection('events')
        .where('categories', arrayContains: categoryName)
        .where('eventStartDateTime', isGreaterThanOrEqualTo: new DateTime.now())
        .orderBy('eventStartDateTime', descending: true)
        .get();
    return snapshot.docs
        .map((d) => Event.fromQueryDocumentSnapshot(d))
        .toList();
  }

  Future<List<Event>> getEventsByCategoryId(String categoryId) async {
    QuerySnapshot snapshot = await _fireStore
        .collection('events')
        .where('category', isEqualTo: categoryId)
        .where('eventStartDateTime', isGreaterThanOrEqualTo: new DateTime.now())
        .orderBy('eventStartDateTime', descending: true)
        .get();
    return snapshot.docs
        .map((d) => Event.fromQueryDocumentSnapshot(d))
        .toList();
  }

  Future<List<Event>> getEventsByDateFromCategory(
      {DateTime date, String subCategoryName, Category category}) async {
    String subId = category.subCategories
        .firstWhere((element) => element.name == subCategoryName)
        .id;
    QuerySnapshot snapshot = await _fireStore
        .collection('categories')
        .doc(category.id)
        .collection('providers')
        .doc(subId)
        .collection('events')
        .where('schedules', arrayContains: date)
        .get();
    if ((snapshot.docs?.length ?? 0) > 0) {
      List<Event> events = [];
      var futures = snapshot.docs.map((e) =>
          _fireStore.collection('events').doc(e.id).get().then((eventSnapshot) {
            if (eventSnapshot.exists)
              return events.add(Event.fromDocumentSnapshot(eventSnapshot));
          }));
      return Future.wait(futures).then((_) => events);
    } else {
      return [];
    }
  }

  Future<List<Event>> getEventsByUser() async {
    String userId = auth.currentUser.uid;
    QuerySnapshot snapshotUser = await _fireStore
        .collection('users')
        .doc(userId)
        .collection('tickets')
        .get();
    if (snapshotUser.docs.isNotEmpty) {
      List<Event> events = [];
      var futures = snapshotUser.docs.map((e) =>
          _fireStore.collection('events').doc(e.id).get().then((eventSnapshot) {
            if (eventSnapshot.exists)
              return events.add(Event.fromDocumentSnapshot(eventSnapshot));
          }));
      return Future.wait(futures).then((_) => events);
    } else
      return [];
  }

  Future<List<Event>> getWaitingEventsByUser() async {
    String userId = auth.currentUser.uid;
    QuerySnapshot snapshotUser = await _fireStore
        .collection('users')
        .doc(userId)
        .collection('waiting')
        .get();
    if (snapshotUser.docs.isNotEmpty) {
      List<Event> events = [];
      var futures = snapshotUser.docs.map((e) =>
          _fireStore.collection('events').doc(e.id).get().then((eventSnapshot) {
            if (eventSnapshot.exists)
              return events.add(Event.fromDocumentSnapshot(eventSnapshot));
          }));
      return Future.wait(futures).then((_) => events);
    } else
      return [];
  }

  Future<List<Event>> getFavEventsByUser() async {
    String userId = auth.currentUser.uid;
    QuerySnapshot snapshotUser = await _fireStore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    if (snapshotUser.docs.isNotEmpty) {
      List<Event> events = [];
      var futures = snapshotUser.docs.map((e) => _fireStore
              .collection('events')
              .doc(e.id)
              .get()
              .then((eventSnapshot) {
            if (eventSnapshot.exists) {
              return events.add(Event.fromDocumentSnapshot(eventSnapshot));
            }
          }).onError(
                  (error, stackTrace) => throw new Exception("No Fav Found")));
      return Future.wait(futures).then((_) {
        return events;
      });
    } else
      return [];
  }

  Future<List<Event>> getCancelledEventsByUser() async {
    String userId = auth.currentUser.uid;
    QuerySnapshot snapshotUser = await _fireStore
        .collection('users')
        .doc(userId)
        .collection('cancelled')
        .get();
    if (snapshotUser.docs.isNotEmpty) {
      List<Event> events = [];
      var futures = snapshotUser.docs.map((e) =>
          _fireStore.collection('events').doc(e.id).get().then((eventSnapshot) {
            if (eventSnapshot.exists)
              return events.add(Event.fromDocumentSnapshot(eventSnapshot));
          }));
      return Future.wait(futures).then((_) => events);
    } else
      return [];
  }

  Future<bool> checkFavorite(String event_id) async {
    String userId = auth.currentUser.uid;
    bool response = false;
    var futures = [
      _fireStore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(event_id)
          .get()
          .then((docSnapshot) {
        docSnapshot.data() != null ? response = true : response = false;
      }).catchError((err) => throw err)
    ];
    return Future.wait(futures).then((_) => response);
  }

  Future<Event> getEvent(String event_id) async {
    var res = await _fireStore.collection('events').doc(event_id).get();

    return Event.fromDocumentSnapshot(res);
  }

  Future<Map> checkOrder(String event_id) async {
    String userId = auth.currentUser.uid;
    var response = {};
    var futures = [
      _fireStore
          .collection('users')
          .doc(userId)
          .collection('tickets')
          .doc(event_id)
          .get()
          .then((docSnapshot) {
        docSnapshot.data() != null
            ? response['order_id'] = docSnapshot.data()['order_id']
            : response = null;
        docSnapshot.data() != null
            ? response['amount'] = docSnapshot.data()['amount']
            : response = null;
      })
    ];
    return Future.wait(futures).then((_) => response);
  }

  Future<bool> toggleFav(String event_id, bool status) async {
    String userId = auth.currentUser.uid;
    bool response = false;
    var futures = [
      status
          ? _fireStore
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .doc(event_id)
              .set({'fav': true})
              .then((docSnapshot) => response = true)
              .catchError((_) => response = false)
          : _fireStore
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .doc(event_id)
              .delete()
              .then((docSnapshot) => response = true)
              .catchError((_) => response = false)
    ];
    return Future.wait(futures).then((_) => response);
  }

  Future<TicketType> checkStatus(String event_id) async {
    String userId = auth.currentUser.uid;
    TicketType response = TicketType.none;
    var futures = [
      // _fireStore
      //     .collection('users')
      //     .doc(userId)
      //     .collection('cancelled')
      //     .doc(event_id)
      //     .get()
      //     .then((docSnapshot) => docSnapshot.data() != null
      //         ? response = TicketType.cancelled
      //         : TicketType.none),
      _fireStore
          .collection('users')
          .doc(userId)
          .collection('tickets')
          .doc(event_id)
          .get()
          .then((docSnapshot) => docSnapshot.data() != null
              ? response = TicketType.joined
              : TicketType.none),
      _fireStore
          .collection('users')
          .doc(userId)
          .collection('waiting')
          .doc(event_id)
          .get()
          .then((docSnapshot) => docSnapshot.data() != null
              ? response = TicketType.waiting
              : TicketType.none),
    ];
    return Future.wait(futures).then((_) => response);
  }
}

class HomeData {
  const HomeData({this.categories = const [], this.events = const []});

  final List<Category> categories;
  final List<Event> events;
}
