import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';

import '../../../core/constants/constants.dart';

class PDFViewerPage extends StatelessWidget {
  final File file;

  PDFViewerPage({this.file});

  @override
  Widget build(BuildContext context) {
    final name = basename(file.path);

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
          child: PDFView(
        filePath: file.path,
      )),
    );
  }
}
