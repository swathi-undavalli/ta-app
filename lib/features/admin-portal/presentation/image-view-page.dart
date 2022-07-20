import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:temple_adventures/features/admin-portal/models/adminPortal-model.dart';
import '../../../core/constants/constants.dart';
import '../../../core/widgets/back-navigation-icon.dart';

class ImageViewPage extends StatelessWidget {
  final AdminPortalModel adminPortalModel = Get.arguments;

  static const String id = "ImageViewPage";

  @override
  Widget build(BuildContext context) {
    final name = basename(adminPortalModel.filename);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(
          name,
          style: TextStyle(color: Colors.black),
        ),
        leading: BackNavigationIcon(),
        elevation: 0,
        backgroundColor: AppColors.background.white,
      ),
      body: SafeArea(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                image: adminPortalModel.path != null
                    ? DecorationImage(
                        image: NetworkImage(adminPortalModel.path),
                        // FileImage(File(image),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
