import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/bookings/models/dive_log_model.dart';
import '../../features/events/models/event_model.dart';
import '../../features/offers/models/offer.dart';

API firebaseApi = API();

class API {
  String templeEvents = 'templeEvents';
  String templeOffers = 'templeOffers';

  Future<void> deleteEvent(String id) async {
    await FirebaseFirestore.instance.collection(templeEvents).doc(id).delete();
  }

  Future<void> updateEvent(Event event) async {
    await FirebaseFirestore.instance
        .collection(templeEvents)
        .doc(event.id)
        .set(event.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get getAllEvents =>
      FirebaseFirestore.instance.collection(templeEvents).snapshots();

  Future<void> deleteOffer(String id) async {
    await FirebaseFirestore.instance.collection(templeOffers).doc(id).delete();
  }

  Future<void> updateOffer(Offer offer) async {
    await FirebaseFirestore.instance
        .collection(templeOffers)
        .doc(offer.id)
        .set(offer.toJson());
  }

  Future<void> updateDiveLog(DiveLogModel diveLog, String? email) async {
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(email)
        .collection('diveLogs')
        .doc(diveLog.id)
        .set(diveLog.toMap());
  }

  Future<void> deleteDiveLog(String id, String email) async {
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(email)
        .collection('diveLogs')
        .doc(id)
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> get getAllOffers {
    return FirebaseFirestore.instance.collection(templeOffers).snapshots();
  }
}
