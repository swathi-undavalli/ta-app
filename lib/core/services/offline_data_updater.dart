import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

List<DataModel> updateQueue = [];
bool isConnected = true;

init() {
  var listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
    switch (status) {
      case InternetStatus.connected:
        whenConnectedToInternet();
        break;
      case InternetStatus.disconnected:
        whenDisConnectedToInternet();
        break;
    }
  });
}

whenConnectedToInternet() async {
  isConnected = true;
  log('Connection Status : Connected to internet');
  for (int i = 0; i < updateQueue.length; i++) {
    if (!isConnected) break;
    DataModel data = updateQueue[i];
    try {
      if (data.updatedAt == null) {
        DocumentReference firebaseRef = FirebaseFirestore.instance.doc(data.firebasePath);
        await firebaseRef.set(data.data);
        data = data.copyWith(updatedAt: DateTime.now());
        updateQueue[i] = data;
        log('Updated data in firebase');
      }
    } catch (e) {
      log('Error in offline updater[isConnected: $isConnected], Trying again ...');
      i--;
    }
  }
}

bool isSyncPending() {
  for (int i = 0; i < updateQueue.length; i++) {
    DataModel data = updateQueue[i];
    if (data.updatedAt == null) return true;
  }
  return false;
}

whenDisConnectedToInternet() {
  isConnected = false;
  log('Connection Status : Connected to internet');
}

updateData(DataModel data) async {
  log('isConnected: $isConnected');
  if (isConnected) {
    DocumentReference firebaseRef = FirebaseFirestore.instance.doc(data.firebasePath);
    await firebaseRef.set(data.data);
    log('Data updated in firebase');
  } else {
    updateQueue.add(data);
    log('Data added to updateQueue');
  }
}

class DataModel {
  final dynamic data;
  final DateTime? updatedAt;
  final DateTime createdAt;
  final String firebasePath;

  DataModel({
    required this.data,
    required this.updatedAt,
    required this.firebasePath,
    required this.createdAt,
  });

  DataModel copyWith({DateTime? updatedAt}) {
    return DataModel(
      data: data,
      updatedAt: updatedAt ?? this.updatedAt,
      firebasePath: firebasePath,
      createdAt: createdAt,
    );
  }
}
