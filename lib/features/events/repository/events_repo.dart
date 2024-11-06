import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

class EventsRepo {
  static Future<void> deleteEvent(String id) async {
    await FirebaseFirestore.instance.collection('templeEvents').doc(id).delete();
  }

  static Future<void> updateEvent(Event event) async {
    await FirebaseFirestore.instance.collection('templeEvents').doc(event.id).set(event.toJson());
  }
}
