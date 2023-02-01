import 'package:flutter/material.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/all-boats-expansionPanelWidget.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/all-booking-expansionPanel.dart';
import 'package:temple_adventures/features/counter-model.dart';

class AllBoatsPage extends StatelessWidget {
  static const String id = "AllBoatsPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
            child: Column(
              children: [
                ...List.generate(
                        counterModel!.boat!,
                        (index) =>
                            AllBoatsExpansionPanelWidget(boatID: index + 1))
                    .toList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: BackNavigationIcon(),
        elevation: 0,
        backgroundColor: Colors.white);
  }

  Widget buildTitle() {
    return Text(
      'All Boats',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.0,
      ),
    );
  }
}
