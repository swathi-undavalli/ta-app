// import 'dart:developer';
// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/features/boat/models/boat-model.dart';
// import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
// import 'package:temple_adventures/features/counter-model.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as sync;
//
// class BoatLogic {
//   BoatLogic() {
//     // init();
//   }
//
//   BoatController controller = Get.put(BoatController());
//
//   init() async {
//     await getData();
//     controller.showLoading = false;
//   }
//
//   getSlip({BoatPassengersModel? boatPassengersModel, DateTime? time}) {
//     List boatData = [];
//
//     for (int i = 1; i <= counterModel!.boat!; i++) {
//       log(i.toString());
//       var boat = {
//         "passengers": [],
//         "employees": [],
//         "freelancers": [],
//       };
//
//       boatPassengersModel!.passenger!.forEach((element) {
//         if (element.boatID == i.toString()) {
//           log(element.name!);
//           boat["passengers"]!.add(element);
//         }
//       });
//       boatPassengersModel.employees!.forEach((element) {
//         if (element.boatID == i.toString()) {
//           log(element.name!);
//           boat["employees"]!.add(element);
//         }
//       });
//       boatPassengersModel.freelancer!.forEach((element) {
//         if (element.boatID == i.toString()) {
//           log(element.name!);
//           boat["freelancers"]!.add(element);
//         }
//       });
//       boatData.add(boat);
//       log("============");
//     }
//
//     log(boatData.toList().toString());
//
//     generateCSV(boatPassengersModel: boatPassengersModel, time: time);
//   }
//
//   void generateCSV(
//       {BoatPassengersModel? boatPassengersModel, DateTime? time}) async {
//     final sync.Workbook workbook = sync.Workbook();
//     final sync.Worksheet sheet = workbook.worksheets[0];
//
//     sheet.getRangeByName('A1:K1').merge();
//     sheet.getRangeByName('A1').setText("Temple Adventures");
//     sheet.getRangeByName('A1').cellStyle.fontSize = 16;
//     sheet.getRangeByName('A1').cellStyle.fontName = AppFonts.nunito;
//     sheet.getRangeByName('A1').cellStyle.hAlign = sync.HAlignType.center;
//     sheet.getRangeByName('A1').cellStyle.vAlign = sync.VAlignType.center;
//     sheet.getRangeByName('A1').rowHeight = 25;
//
//     sheet.getRangeByName('A2').setText("Date");
//     sheet.getRangeByName('B2').setDateTime(controller.selectedDate);
//     sheet.getRangeByName('B2').numberFormat = '[\$-x-sysdate]ddd  mm dd, yyyy';
//     sheet.getRangeByName('B2')..autoFitColumns();
//     sheet.getRangeByName('A2:B2').cellStyle.fontSize = 10;
//     sheet.getRangeByName('A2:B2').cellStyle.fontName = AppFonts.nunito;
//     sheet.getRangeByName('A2:B2').rowHeight = 21;
//     sheet.getRangeByName('A2:B2').cellStyle.hAlign = sync.HAlignType.center;
//     sheet.getRangeByName('A2:B2').cellStyle.vAlign = sync.VAlignType.center;
//
//     sheet.getRangeByName('A4').text = 'S.No';
//     sheet.getRangeByName('A4:K4').cellStyle.hAlign = sync.HAlignType.center;
//     sheet.getRangeByName('B4').text = 'Diver Names';
//     sheet.getRangeByName('C4').text = 'Gender';
//     sheet.getRangeByName('D4').text = 'Category';
//     sheet.getRangeByName('E4').text = 'Country';
//     sheet.getRangeByName('F4').text = 'Boat';
//     sheet.getRangeByName('A4:K4')..autoFitColumns();
//     sheet.getRangeByName('A4:K4').cellStyle.fontSize = 10;
//     sheet.getRangeByName('A4:k4').cellStyle.bold = true;
//     sheet.getRangeByName('A4:K4').cellStyle.fontName = AppFonts.nunito;
//     sheet.getRangeByName('A4:K4').cellStyle.vAlign = sync.VAlignType.center;
//     sheet.getRangeByName('C4:K4').cellStyle.hAlign = sync.HAlignType.center;
//
//     int currentLine = 6;
//     int sno = 1;
//     var totals = [0, 0, 0, 0, 0, 0];
//
//     for (int i = 1; i <= counterModel!.boat!; i++) {
//       log(i.toString());
//       var boat = {
//         "passengers": [],
//         "employees": [],
//         "freelancers": [],
//       };
//
//       boatPassengersModel!.passenger!.forEach((element) {
//         if (element.boatID == i.toString()) {
//           log(element.name!);
//           log(element.gender!);
//           totals[i - 1]++;
//
//           sheet.getRangeByName('A$currentLine').text = sno.toString();
//           sheet.getRangeByName('B$currentLine').text = element.name;
//           sheet.getRangeByName('C$currentLine').text = element.gender;
//           sheet.getRangeByName('D$currentLine').text = "Diver";
//           sheet.getRangeByName('E$currentLine').text = "India";
//           // sheet.getRangeByName('F$currentLine').text =
//           //     boatName[int.parse(element.boatID) - 1];
//           sheet.getRangeByName('F$currentLine').text =
//               controller.boatsList[int.parse(element.boatID!) - 1].boatName;
//
//           sheet
//               .getRangeByName('A$currentLine:K$currentLine')
//               .cellStyle
//               .fontSize = 10;
//           sheet
//               .getRangeByName('A$currentLine:K$currentLine')
//               .cellStyle
//               .fontName = AppFonts.nunito;
//           sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.vAlign =
//               sync.VAlignType.center;
//           sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.hAlign =
//               sync.HAlignType.center;
//           currentLine++;
//           sno++;
//           boat["passengers"]!.add(element);
//         }
//       });
//       boatPassengersModel.employees!.forEach((element) {
//         if (element.boatID == i.toString()) {
//           log(element.name!);
//           totals[i - 1]++;
//
//           sheet.getRangeByName('A$currentLine').text = sno.toString();
//           sheet.getRangeByName('B$currentLine').text = element.name;
//           sheet.getRangeByName('C$currentLine').text = element.gender;
//           sheet.getRangeByName('D$currentLine').text = "Staff";
//           sheet.getRangeByName('E$currentLine').text = "India";
//           sheet.getRangeByName('F$currentLine').text =
//               controller.boatsList[int.parse(element.boatID!) - 1].boatName;
//
//           sheet
//               .getRangeByName('A$currentLine:K$currentLine')
//               .cellStyle
//               .fontSize = 10;
//           sheet
//               .getRangeByName('A$currentLine:K$currentLine')
//               .cellStyle
//               .fontName = AppFonts.nunito;
//           sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.vAlign =
//               sync.VAlignType.center;
//           sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.hAlign =
//               sync.HAlignType.center;
//           currentLine++;
//           sno++;
//           boat["employees"]!.add(element);
//         }
//       });
//       boatPassengersModel.freelancer!.forEach((element) {
//         if (element.boatID == i.toString()) {
//           log(element.name!);
//           totals[i - 1]++;
//           sheet.getRangeByName('A$currentLine').text = sno.toString();
//           sheet.getRangeByName('B$currentLine').text = element.name;
//           sheet.getRangeByName('C$currentLine').text = element.gender;
//           sheet.getRangeByName('D$currentLine').text = "Freelance";
//           sheet.getRangeByName('E$currentLine').text = "India";
//           sheet.getRangeByName('F$currentLine').text =
//               controller.boatsList[int.parse(element.boatID!) - 1].boatName;
//
//           sheet
//               .getRangeByName('A$currentLine:K$currentLine')
//               .cellStyle
//               .fontSize = 10;
//           sheet
//               .getRangeByName('A$currentLine:K$currentLine')
//               .cellStyle
//               .fontName = AppFonts.nunito;
//           sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.vAlign =
//               sync.VAlignType.center;
//           sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.hAlign =
//               sync.HAlignType.center;
//           currentLine++;
//           sno++;
//           boat["freelancers"]!.add(element);
//         }
//       });
//
//       if (totals[i - 1] != 0) currentLine++;
//     }
//
//     sheet.getRangeByName('A$currentLine').text = 'S.No';
//     sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.hAlign =
//         sync.HAlignType.center;
//     sheet.getRangeByName('B$currentLine').text = 'Boat Name';
//     sheet.getRangeByName('C$currentLine').text = 'Captain Name';
//     sheet.getRangeByName('D$currentLine').text = 'Contact';
//     sheet.getRangeByName('E$currentLine').text = 'Time-In';
//     sheet.getRangeByName('F$currentLine').text = 'Time-Out';
//     sheet.getRangeByName('A$currentLine:K$currentLine')..autoFitColumns();
//     sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.fontSize = 10;
//     sheet.getRangeByName('A$currentLine:k$currentLine').cellStyle.bold = true;
//     sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.fontName =
//         AppFonts.nunito;
//     sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.vAlign =
//         sync.VAlignType.center;
//     sheet.getRangeByName('C$currentLine:K$currentLine').cellStyle.hAlign =
//         sync.HAlignType.center;
//     currentLine += 2;
//
//     int boatNo = 0;
//
//     for (int i = 0; i < counterModel!.boat!; i++) {
//       if (totals[i] != 0) {
//         boatNo++;
//         sheet.getRangeByName('A$currentLine').text = boatNo.toString();
//         sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.hAlign =
//             sync.HAlignType.center;
//         sheet.getRangeByName('B$currentLine').text =
//             controller.boatsList[i].boatName;
//         sheet.getRangeByName('C$currentLine').text =
//             controller.boatsList[i].captainName;
//         sheet.getRangeByName('D$currentLine').text =
//             controller.boatsList[i].phoneNumber;
//         sheet.getRangeByName('E$currentLine').text =
//             DateFormat('hh : mm').format(time!);
//         sheet.getRangeByName('F$currentLine').text =
//             DateFormat('hh : mm').format(time.add(Duration(hours: 4)));
//         sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.fontSize =
//             10;
//         sheet.getRangeByName('D$currentLine').cellStyle.fontSize = 8;
//         sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.fontName =
//             AppFonts.nunito;
//         sheet.getRangeByName('A$currentLine:K$currentLine').cellStyle.vAlign =
//             sync.VAlignType.center;
//         sheet.getRangeByName('C$currentLine:K$currentLine').cellStyle.hAlign =
//             sync.HAlignType.center;
//         currentLine++;
//       }
//     }
//
//     final List<int> bytes = workbook.saveAsStream();
//
//     workbook.dispose();
//     final String path = (await getApplicationSupportDirectory()).path;
//     final String fileName = '$path/Output.xlsx';
//     final File file = File(fileName);
//     await file.writeAsBytes(bytes, flush: true);
//     // OpenFile.open(fileName);
//   }
//
//   getData() async {
//     log("getting data");
//     controller.boatsList = [];
//
//     var boatsData = await FirebaseFirestore.instance.collection("boats").get();
//
//     boatsData.docs.forEach((element) {
//       BoatsModel boat = BoatsModel.fromMap(element.data());
//       controller.boatsList.add(boat);
//       controller.update();
//     });
//
//     var d = await FirebaseFirestore.instance
//         .collection("coastGuardSlip")
//         // .doc("05-05-2022")
//         .doc(DateFormat('dd-MM-yyyy').format(controller.selectedDate))
//         .get();
//
//     Map<String, dynamic>? passengerData = d.data();
//     if (passengerData == null) {
//       log("no data found");
//       controller.noDataFound = true;
//     } else {
//       log(passengerData.toString());
//
//       controller.noDataFound = false;
//       controller.timeList = [];
//       controller.bookedPassengers = [];
//
//       passengerData.keys.toList().forEach((p) {
//         controller.timeList.add(DateTime.parse(p));
//       });
//
//       passengerData.values.toList().forEach((p) {
//         controller.bookedPassengers.add(BoatPassengersModel.fromMap(p));
//       });
//     }
//     log("data found");
//   }
// }
//
// class BoatController extends GetxController {
//   List<BoatsModel> boatsList = [];
//   List<DateTime> timeList = [];
//   List<BoatPassengersModel> bookedPassengers = [];
//   List<Employees> employees = [];
//   List<Passenger> passengers = [];
//   List<Freelancer> freelancers = [];
//   int bookedSeats = 0;
//
//   bool _showLoading = true;
//   bool _noDataFound = true;
//
//   bool get noDataFound => _noDataFound;
//
//   set noDataFound(bool value) {
//     _noDataFound = value;
//     update();
//   }
//
//   bool get showLoading => _showLoading;
//
//   set showLoading(bool value) {
//     _showLoading = value;
//     update();
//   }
//
//   DateTime _selectedDate = DateTime.now();
//   // DateTime _selectedDate = DateTime(
//   //   2022,
//   //   5,
//   //   5,
//   // );
//   DateTime get selectedDate => _selectedDate;
//   set selectedDate(DateTime value) {
//     _selectedDate = value;
//     update();
//   }
// }
