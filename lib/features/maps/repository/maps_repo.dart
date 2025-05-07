import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../dive_sites/models/dive_site.model.dart';

class MapsRepository {
  final _diveSitesCollection =
      FirebaseFirestore.instance.collection('dive_sites');

  Future<void> addDiveSite(DiveSiteModel site) async {
    try {
      final docRef = _diveSitesCollection.doc();
      final diveSiteWithId = site.copyWith(id: docRef.id);

      await docRef.set(diveSiteWithId.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error adding dive site: $e');
      }
      log('Error adding dive site: $e');
    }
  }

  Future<void> editDiveSite(DiveSiteModel site) async {
    try {
      await _diveSitesCollection.doc(site.id).update(site.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error adding dive site: $e');
      }
      log('Error adding dive site: $e');
    }
  }

  Future<void> deleteDiveSite(String id) async {
    try {
      await _diveSitesCollection.doc(id).delete();
      if (kDebugMode) {
        print('Dive site deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting dive site: $e');
      }
      log('Error deleting dive site: $e');
    }
  }

  /// Fetch all dive sites
  Future<List<DiveSiteModel>> getAllDiveSites() async {
    try {
      final querySnapshot = await _diveSitesCollection.get();

      final diveSites = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return DiveSiteModel.fromMap(data);
      }).toList();

      return diveSites;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching dive sites: $e');
      }
      return [];
    }
  }
}
