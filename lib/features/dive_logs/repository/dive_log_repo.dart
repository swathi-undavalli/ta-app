import 'package:cloud_firestore/cloud_firestore.dart';

import '../../bookings/models/dive_log_model.dart';

class DiveLogRepo {
  static Future<void> updateDiveLog(DiveLogModel diveLog, String? email) async {
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(email)
        .collection('diveLogs')
        .doc(diveLog.id)
        .set(diveLog.toMap());
  }

  static Future<void> deleteDiveLog(String id, String email) async {
    await FirebaseFirestore.instance.collection('customers').doc(email).collection('diveLogs').doc(id).delete();
  }
}
