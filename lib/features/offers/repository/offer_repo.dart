import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/offer.dart';

class OfferRepo {
  static Future<void> deleteOffer(String id) async {
    await FirebaseFirestore.instance.collection('templeOffers').doc(id).delete();
  }

  static Future<void> updateOffer(Offer offer) async {
    await FirebaseFirestore.instance.collection('templeOffers').doc(offer.id).set(offer.toJson());
  }
}
