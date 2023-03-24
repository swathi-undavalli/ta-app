import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/all-bookings/controller/all-bookings-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/all-booking-expansionPanel.dart';

// class AllBookingsScreen extends StatelessWidget {
//   static const String id = "AllBookingsScreen";
//   AllBookingsLogic logic = AllBookingsLogic();
//
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         WillPopScope(
//           onWillPop: () async {
//             logic.controller.searchTED.text = "";
//             return true;
//           },
//           child: Scaffold(
//               appBar: AppBar(
//                 toolbarHeight: 70,
//                 centerTitle: true,
//                 title: buildTitle(),
//                 leading: TextButton(
//                   onPressed: () {
//                     logic.controller.searchTED.text = "";
//                     Get.back();
//                   },
//                   child: Icon(
//                     Icons.arrow_back_ios,
//                     color: AppColors.text.black,
//                     size: 17,
//                   ),
//                 ),
//                 elevation: 0,
//                 backgroundColor: AppColors.background.white,
//               ),
//               body: SafeArea(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20),
//                     buildSearchBar(),
//                     SizedBox(height: 10),
//                     buildCheckFirebase(),
//                   ],
//                 ),
//               )),
//         ),
//       ],
//     );
//   }
//
//   Widget buildCheckFirebase() {
//     return Expanded(
//       child: GetBuilder<AllBookingsController>(builder: (controller) {
//         return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//           stream: FirebaseFirestore.instance.collection("bookings").snapshots(),
//           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.black,
//                   strokeWidth: 3,
//                 ),
//               );
//             }
//             return ListView.builder(
//               itemBuilder: (BuildContext context, int index) {
//                 try {
//                   BookingModel booking =
//                       BookingModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
//                   log(booking.id.toString());
//                   if (controller.searchTED.text.isNotEmpty) {
//                     if (booking.id!.contains(controller.searchTED.text) || (booking.pax![0]['first-name'] as String)
//                             .toLowerCase()
//                             .contains(controller.searchTED.text.toLowerCase().trim()))
//                       return AllBookingsExpansionPanel(booking: booking);
//                   }
//                   return AllBookingsExpansionPanel(booking: booking);
//                 } catch (e) {
//                   log(e.toString());
//                   return Text("Error loading boking $e");
//                 }
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
//
//   Widget buildSearchBar() {
//     return Container(
//       width: 328,
//       height: 47,
//       decoration: BoxDecoration(color: AppColors.background.white, borderRadius: BorderRadius.circular(5)),
//       child: Container(
//         margin: EdgeInsets.only(left: 15, right: 15),
//         alignment: Alignment.centerLeft,
//         child: Row(
//           children: [
//             Icon(Icons.search, color: AppColors.text.darkgrey),
//             SizedBox(width: 15),
//             Container(
//               width: 240,
//               child: TextField(
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
//                     disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
//                     hintText: 'Search...',
//                     hintStyle: TextStyle(fontSize: FontSize.textSize, height: 1)),
//                 controller: logic.controller.searchTED,
//                 onChanged: (text) {
//                   logic.controller.update();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildShowLoading() {
//     return GetBuilder<AllBookingsController>(builder: (controller) {
//       if (controller.showLoading)
//         return Container(
//           color: Colors.white,
//           height: Get.height,
//           width: Get.width,
//           child: Center(
//               child: CircularProgressIndicator(
//             color: Colors.black,
//           )),
//         );
//       else
//         return SizedBox();
//     });
//   }
//
//   Widget buildTitle() {
//     return Text(
//       'All Bookings',
//       style: TextStyle(
//         color: AppColors.text.black,
//         fontSize: 20,
//         fontFamily: AppFonts.nunito,
//         fontWeight: FontWeight.normal,
//         letterSpacing: 1.0,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllBookingsScreen extends StatefulWidget {
  static const String id = "AllBookingsScreen";

  @override
  _AllBookingsScreenState createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  late Stream<QuerySnapshot> _bookingsStream;
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _bookingsStream = FirebaseFirestore.instance.collection('bookings').snapshots();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 20),
          buildSearchBar(),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _bookingsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  );
                }

                final documents = snapshot.data!.docs.where((doc) {
                  Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

                  if (data != null) {
                    return data['PAX'][0]['first-name'].toLowerCase().contains(_searchText) ||
                        data['PAX'][0]['phoneNumber'].toLowerCase().contains(_searchText) ||
                        data['id'].toLowerCase().contains(_searchText);
                  }
                  return false;
                });

                if (documents.isEmpty) {
                  return Center(child: Text('No bookings found.'));
                }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = documents.elementAt(index);
                    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                    try {
                      if (data != null) {
                        BookingModel booking = BookingModel.fromMap(data);
                        return AllBookingsExpansionPanel(booking: booking);
                      }
                    } catch (e) {
                      return Text("error loading this booking");
                    }
                    return SizedBox();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      width: 328,
      height: 47,
      decoration: BoxDecoration(color: AppColors.background.white, borderRadius: BorderRadius.circular(5)),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.text.darkgrey),
            SizedBox(width: 15),
            Container(
              width: 240,
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: FontSize.textSize, height: 1)),
                controller: _searchController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'All Bookings',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.0,
        ),
      ),
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.text.black,
          size: 17,
        ),
      ),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
