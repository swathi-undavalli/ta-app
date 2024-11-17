// Mapper to handle Firestore Timestamp encoding/decoding
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

class TimestampMapper extends SimpleMapper<Timestamp> {
  @override
  dynamic encode(Timestamp self) => self; // Save as Timestamp directly

  @override
  Timestamp decode(dynamic value) {
    if (value is Timestamp) {
      return value; // If it's already a Timestamp, return it
    } else {
      throw Exception('Cannot decode $value to Timestamp');
    }
  }
}
