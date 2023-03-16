import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketsRepo {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<void> bookTicket(
    int amount, {
    String event_id,
    String order_id,
  }) async {
    // Save the event
    final String currentUserId = auth.currentUser.uid;
    if (currentUserId == null) throw Exception('Unauthenticated');

    // final DocumentSnapshot ticket =
    //     await db.collection("users/$currentUserId/tickets").doc(event_id).get();
    // print('ORDER - ID: ' + order_id);
    // !ticket.exists
    //     ?
    db.collection("users/$currentUserId/tickets").doc(event_id).set({
      "amount": FieldValue.increment(amount.abs()),
      "order_id": order_id,
      "createdAt": FieldValue.serverTimestamp()
    }, SetOptions(merge: true)).then((_) => db
            .collection('events')
            .doc(event_id)
            .update({'amount': FieldValue.increment((-1) * amount.abs())}).then(
                (_) {
          db.collection('events').doc(event_id).get().then((event) {
            if (event.data() != null) {
              if (event.data()['price'] != null || event.data()['price'] != 0) {
                db.collection('events').doc(event.id).update({
                  'totalSales': FieldValue.increment(
                      double.parse(event.data()['price'].toString()) *
                          amount.abs())
                });
              }
            }
          });
        }));
    // : db.collection("users/$currentUserId/tickets").doc(event_id).update({
    //     "amount": FieldValue.increment(amount.abs()),
    //     "order_id": order_id,
    //     "createdAt": FieldValue.serverTimestamp()
    //   }).then((_) => db.collection('events').doc(event_id).update({
    //       'amount': FieldValue.increment((-1) * amount.abs())
    //     }).then((_) {
    //       db.collection('events').doc(event_id).get().then((event) {
    //         if (event.data() != null) {
    //           if (double.parse(event.data()['price'].toString()) != null ||
    //               double.parse(event.data()['price'].toString()) != 0) {
    //             db.collection('events').doc(event.id).update({
    //               'totalSales': FieldValue.increment(
    //                   double.parse(event.data()['price'].toString()) *
    //                       amount.abs())
    //             });
    //           }
    //         }
    //       });
    //     }));
  }

  Future<void> bookWaitingTicket(
    int amount, {
    String event_id,
  }) async {
    // Save the event
    final String currentUserId = auth.currentUser.uid;
    if (currentUserId == null) throw Exception('Unauthenticated');
    DocumentSnapshot cancelledDoc = await db
        .collection("users/$currentUserId/cancelled")
        .doc(event_id)
        .get();
    db.collection("users/$currentUserId/waiting").doc(event_id).set(
      {"amount": amount, "createdAt": FieldValue.serverTimestamp()},
    ).then((_) {
      var futures = [
        if (cancelledDoc.exists)
          db
              .collection("users/$currentUserId/cancelled")
              .doc(event_id)
              .delete(),
        db
            .collection('events')
            .doc(event_id)
            .update({"waiting": FieldValue.increment(amount.abs())})
      ];
      return Future.wait(futures).then((value) => value);
    });
  }

  Future<void> cancelWaitingTicket(String event_id) async {
    // Save the event
    final String currentUserId = auth.currentUser.uid;
    if (currentUserId == null) throw Exception('Unauthenticated');
    print(event_id);
    DocumentSnapshot deletedEventSnapshot =
        await db.collection("users/$currentUserId/waiting").doc(event_id).get();
    var deletedEvent = await deletedEventSnapshot.data();
    print(deletedEventSnapshot.id);
    await db
        .collection("users/$currentUserId/cancelled")
        .doc(event_id)
        .set(deletedEvent, SetOptions(merge: true));
    await db.collection("users/$currentUserId/waiting").doc(event_id).delete();
  }
}
