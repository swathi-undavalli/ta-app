import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../boat/models/boats.dart';

class BoatSelectorBottomSheet extends StatefulWidget {
  final DateTime date;
  const BoatSelectorBottomSheet({
    super.key,
    required this.date,
  });

  static Future<void> show(
    BuildContext context,
    DateTime date,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return BoatSelectorBottomSheet(
          date: date,
        );
      },
    );
  }

  @override
  State<BoatSelectorBottomSheet> createState() => _BoatSelectorBottomSheetState();
}

class _BoatSelectorBottomSheetState extends State<BoatSelectorBottomSheet> {
  bool showLoading = true;

  @override
  void initState() {
    //Get today boats and show only those who has DSDs
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Screen.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetTitleBar(
            title: 'Select Boats',
            description: 'The Boats shown in the following list only has DSDs',
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('dailyBoats')
                  .doc(DateFormat('dd-MM-yyyy').format(widget.date))
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  BoatsModel? boatsModel = BoatsModel.fromMap(snapshot.data.data());

                  if ((boatsModel.boats?.length ?? 0) == 0) {
                    return const Text('No boats found');
                  }
                  return ListView.builder(
                    itemCount: boatsModel.boats!.length,
                    itemBuilder: (context, index) {
                      return Text(boatsModel.boats![index].name);
                    },
                  );
                }
                return const CircularProgressIndicator().center;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetTitleBar extends StatelessWidget {
  final String title;
  final String description;

  const BottomSheetTitleBar({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacing.h16,
        Row(
          children: [
            Spacing.w30,
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
            Spacing.w15,
          ],
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ).paddingOnly(left: 30),
        const Divider().paddingHorizontal(16),
      ],
    );
  }
}
