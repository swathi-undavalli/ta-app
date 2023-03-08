import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/conditions-model.dart';

class ConditionsRepository {
  CollectionReference<Map<String, dynamic>> get conditionsCollection => FirebaseFirestore.instance.collection('conditions');

  Future<void> addLevel(Level level) async {
    await conditionsCollection.add({});
  }

  Future<void> updateConditions(Conditions conditions) async {
    await conditionsCollection.doc('id').set({}, SetOptions(merge: true));
  }

  Future<Conditions?> getConditions(DateTime date) async {
    await conditionsCollection.doc('id').get();
    // put in order.
    return Conditions(levels: []);
  }
}
