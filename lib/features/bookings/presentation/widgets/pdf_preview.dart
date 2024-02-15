import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfPath;

  const PDFViewerPage({Key? key, required this.pdfPath}) : super(key: key);

  static const String id = 'PDFViewerPage';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageSnap: true,
        pageFling: false,
        onRender: (pages) {
          print("Rendered $pages pages.");
        },
        onError: (error) {
          print(error.toString());
        },
      ),
    );
  }
}
