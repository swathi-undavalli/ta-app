// import 'dart:convert';
// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../schemas/data_model.dart';
//
// List<DataModel> updateQueue = [];
// bool isConnected = true;
// late Isar isar;
//
// ///Used to prevent multiple open instances of same db in one life cycle.
// bool isInitiated = false;
//
// ///should be called at the beginning of the app.
// Future<void> init([List<CollectionSchema<dynamic>>? schemes]) async {
//   if (!isInitiated) {
//     final dir = await getApplicationDocumentsDirectory();
//
//     //opening instance LogScheme. so we can use in the entire app cycle.
//     isar = await Isar.open(
//       [DataModelSchema, ...(schemes ?? [])],
//       directory: dir.path,
//     );
//     isInitiated = true;
//   }
// }
//
// checkInternetConnection() {
//   var listener = InternetConnection().onStatusChange.listen((InternetStatus status) {
//     switch (status) {
//       case InternetStatus.connected:
//         whenConnectedToInternet();
//
//         break;
//       case InternetStatus.disconnected:
//         whenDisConnectedToInternet();
//         break;
//     }
//   });
// }
//
// whenConnectedToInternet() async {
//   isConnected = true;
//   log('Connection Status : Connected to internet');
//   for (int i = 0; i < updateQueue.length; i++) {
//     if (!isConnected) break;
//     DataModel data = updateQueue[i];
//     try {
//       if (data.updatedAt == null) {
//         DocumentReference firebaseRef = FirebaseFirestore.instance.doc(data.firebasePath);
//         await firebaseRef.set(data.data);
//         data = data.copyWith(updatedAt: DateTime.now());
//         updateQueue[i] = data;
//         log('Updated data in firebase');
//       }
//     } catch (e) {
//       log('Error in offline updater[isConnected: $isConnected], Trying again ...');
//       i--;
//     }
//   }
// }
//
// // update all the docs from server.
// Future<List<DataModel>> getServerData() async {
//   if (isConnected) {
//     List<DataModel> dataList = [];
//     var d = await FirebaseFirestore.instance.collection('offlineTestCollection').get();
//     List<QueryDocumentSnapshot<Map<String, dynamic>>>? data = d.docs;
//     for (int i = 0; i < data.length; i++) {
//       Map<String, dynamic> sample = data[i].data();
//       DataModel model = DataModel(
//         data: jsonEncode(sample),
//         updatedAt: DateTime.now(),
//         firebasePath: '/offlineTestCollection/${data[i].id}',
//         createdAt: DateTime.now(),
//       );
//       dataList.add(model);
//     }
//     return dataList;
//   } else {
//     // TODO: Send data from persistence.
//     return [];
//   }
// }
//
// // update server / local based on internet availability.
// Future syncServer() async {}
//
// Future<void> addLog(DataModel data) async {
//   // log("Adding new log ${newLog.toString()}");
//   await isar.writeTxn(() async {
//     await isar.dataModels.put(data); // insert & update
//   });
// }
//
// bool isSyncPending() {
//   for (int i = 0; i < updateQueue.length; i++) {
//     DataModel data = updateQueue[i];
//     if (data.updatedAt == null) return true;
//   }
//   return false;
// }
//
// whenDisConnectedToInternet() {
//   isConnected = false;
//   log('Connection Status : Connected to internet');
// }
//
// updateData(DataModel data) async {
//   log('isConnected: $isConnected');
//   if (isConnected) {
//     DocumentReference firebaseRef = FirebaseFirestore.instance.doc(data.firebasePath);
//     await firebaseRef.set(data.data);
//     log('Data updated in firebase');
//   } else {
//     updateQueue.add(data);
//     log('Data added to updateQueue');
//   }
// }
