import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/conditions_model.dart';

class ConditionsRepository {
  CollectionReference<Map<String, dynamic>> get conditionsCollection =>
      FirebaseFirestore.instance.collection('conditions');

  Future<void> updateConditions(Conditions conditions) async {
    try {
      await conditionsCollection.doc(conditions.id).set(conditions.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<Conditions?> getConditions(DateTime date) async {
    try {
      var data = await conditionsCollection.doc(getID(date)).get();
      if (data.data() != null) {
        return Conditions.fromMap(data.data()!);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  String getID(DateTime date) => DateFormat('dd-M-yyyy').format(date);
}
