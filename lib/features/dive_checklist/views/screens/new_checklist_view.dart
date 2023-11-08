import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/app_measurements.dart';
import '../../../../core/util/spacing_widgets.dart';

class NewChecklistView extends StatefulWidget {
  static const String id = 'NewChecklistView';

  const NewChecklistView({Key? key}) : super(key: key);

  @override
  State<NewChecklistView> createState() => _NewChecklistViewState();
}

class _NewChecklistViewState extends State<NewChecklistView> {
  List<String> checkListItems = [
    ' Baboye',
    'ammpye',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildSelectedTF(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDescription(),
              Spacing.h20,
              _buildCheckList(),
            ],
          ).paddingSymmetric(horizontal: 20, vertical: 30).scrollable,
        ),
      ),
    );
  }

  Container _buildSelectedTF() {
    return Container(
      height: 60,
      color: Colors.red,
    );
  }

  Widget _buildCheckList() {
    return Column(
      children: [
        ...checkListItems.map(
          (e) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.background.skyBlue.withOpacity(0.2),
                border: Border.all(),
              ),
              width: AppMeasures.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e).paddingSymmetric(vertical: 10, horizontal: 10).left,
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).paddingOnly(bottom: 10);
          },
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 80,
      leading: Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          ),
        ),
      ),
      title: Text(
        'Custom checklist',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 18,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ).center,
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Keep adding items and use the cross icon to delete or tap on item to edit',
      style: TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontFamily: AppFonts.nunito,
        height: 1.5,
      ),
    );
  }
}
