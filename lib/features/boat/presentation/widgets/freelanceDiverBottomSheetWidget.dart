import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import '../../../counter-model.dart';
import '../../../home/model/employee.dart';

class FreelanceDiverBottomSheet extends StatefulWidget {
  final List<Freelancer> selectedFreelancers;
  final List<Freelancer> commonFreelancers;
  final Function(Freelancer)? onFreelanceTapped;

  FreelanceDiverBottomSheet(
      {required this.selectedFreelancers,
      required this.commonFreelancers,
      this.onFreelanceTapped});

  @override
  State<FreelanceDiverBottomSheet> createState() =>
      _FreelanceDiverBottomSheetState();
}

class _FreelanceDiverBottomSheetState extends State<FreelanceDiverBottomSheet> {
  final TextEditingController searchTED = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 450,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Freelancers", style: TextStyle(fontSize: 17)),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.clear_rounded,
                        size: 21,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 25),
            buildSearchBar(),
            SizedBox(height: 10),
            buildAllFreelancers(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 50,
      child: TextField(
        cursorColor: AppColors.text.darkgrey,
        cursorHeight: 20,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_rounded,
                size: 18, color: Colors.black87.withOpacity(0.6)),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.3))),
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14, height: 1)),
        controller: searchTED,
        onChanged: (text) {
          setState(() {});
        },
      ),
    );
  }

  Widget buildAllFreelancers() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('freelance').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          return Column(
            children: snapshot.data!.docs.map((document) {
              Employee freelance = Employee.fromMap(document.data() as Map<String, dynamic>);
              log(freelance.toString());
              log(freelance.id.toString());
              if (searchTED.text.isNotEmpty) {
                if (freelance.id!.contains(searchTED.text) ||
                    freelance.name
                        .toLowerCase()
                        .contains(searchTED.text.toLowerCase().trim()))
                  return buildFreelance(e: freelance);
                return SizedBox();
              }
              return buildFreelance(
                e: freelance,
              );
            }).toList(),
          );
        });
  }

  Widget buildFreelance({required Employee e}) {
    return Container(
      child: Material(
        child: InkWell(
          onTap: () {
            setState(() {
              widget.onFreelanceTapped!(Freelancer(
                name: e.name,
                phone: e.phoneNumber,
                id: e.id,
                gender: e.gender,
              ));
            });
          },
          child: Container(
            height: 47,
            width: Get.width,
            child: Row(
              children: [
                Icon(Icons.account_circle, color: Colors.black38, size: 25),
                Text(
                  "   ${e.name}",
                  style: TextStyle(color: AppColors.text.black, fontSize: 14),
                ),
                Expanded(
                    child: Container(
                  color: Colors.transparent,
                )),
                if (widget.selectedFreelancers
                    .map((e) => e.name)
                    .toList()
                    .contains(e.name))
                  Icon(Icons.check, color: Colors.green, size: 25),
                if (!widget.selectedFreelancers
                        .map((e) => e.name)
                        .toList()
                        .contains(e.name) &&
                    widget.commonFreelancers
                        .map((e) => e.name)
                        .toList()
                        .contains(e.name))
                  Icon(Icons.check, color: Colors.orange, size: 25),
              ],
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
