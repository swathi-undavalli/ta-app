import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/all_booking_expansion_panel.dart';

class AllBookingsScreen extends StatefulWidget {
  static const String id = 'AllBookingsScreen';
  const AllBookingsScreen({Key? key}) : super(key: key);

  @override
  _AllBookingsScreenState createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  late Stream<QuerySnapshot> _bookingsStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

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
          const SizedBox(height: 20),
          buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _bookingsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  );
                }

                final documents = snapshot.data!.docs.where((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

                  return data['PAX'][0]['first-name'].toLowerCase().contains(_searchText) ||
                      data['PAX'][0]['last-name'].toLowerCase().contains(_searchText) ||
                      data['PAX'][0]['phoneNumber'].toLowerCase().contains(_searchText) ||
                      data['PAX'][0]['email'].toLowerCase().contains(_searchText) ||
                      data['id'].toLowerCase().contains(_searchText);
                });

                if (documents.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = documents.elementAt(index);
                    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

                    try {
                      if (data != null) {
                        Booking booking = Booking.fromMap(data);
                        return AllBookingsExpansionPanel(booking: booking);
                      }
                    } catch (e) {
                      return const Text('error loading this booking');
                    }
                    return const SizedBox();
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
        margin: const EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.text.darkgrey),
            const SizedBox(width: 15),
            SizedBox(
              width: 240,
              child: TextField(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: FontSize.textSize, height: 1),),
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
