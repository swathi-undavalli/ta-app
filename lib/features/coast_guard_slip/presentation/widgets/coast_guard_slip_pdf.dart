import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../bookings/presentation/widgets/share_booking_details_widget.dart';

class CoastGuardSlip {
  static Future<File> generatePdf({required DateTime selectedDate}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a3.landscape,
        ),
        build: (context) => <pw.Widget>[
          pw.Row(
            children: [
              pw.Spacer(),
              pw.Spacer(),
              pw.Text(
                'Temple Adventures',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 50,
                  wordSpacing: 2,
                  font: pw.Font.timesBold(),
                ),
              ),
              pw.Spacer(),
              pw.Text(
                DateFormat('EEEE, MMMM dd, yyyy').format(selectedDate),
                style: pw.TextStyle(
                  fontSize: 23,
                  color: PdfColors.black,
                  font: pw.Font.timesBold(),
                ),
              ),
              pw.Spacer(),
            ],
          ),
          pw.SizedBox(height: 25),
          buildLine(),
          pw.SizedBox(height: 25),
          buildBoatDetails(),
          buildLine(),
          buildTitles(),
          buildLine(),
          pw.SizedBox(height: 25),
          ...List.generate(
            5,
            (index) => buildCustomerDetails(),
          ),
          pw.SizedBox(height: 20),
          buildLine(),
        ],
      ),
    );
    return ShareBookingDetails.saveDocument(name: 'coatGuardSlip.pdf', pdf: pdf);
  }

  static pw.Widget buildLine() {
    return pw.Container(
      height: 1,
      width: Get.width * 4,
      color: const PdfColor.fromInt(0xffD9D9D9),
    );
  }

  static pw.Widget buildBoatDetails() {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 25, bottom: 25),
      child: pw.Row(
        children: [
          pw.Text(
            'BATMAN',
            style: pw.TextStyle(
              fontSize: 40,
              color: PdfColors.black,
              font: pw.Font.timesBold(),
            ),
          ),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              buildText('Boat No    : PY234'),
              buildText('Captain    : Venthan ( 9876543210 )'),
              buildText('Captain No : 9876543210'),
              buildText('Instructor : Donarun Das ( 9876543210 )'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildTitles() {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 25, bottom: 25),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: buildText('SI.No.'),
          ),
          pw.SizedBox(
            width: 230,
            child: buildText('Diver Names'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Gender'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Dive Category'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Country'),
          ),
          pw.SizedBox(
            width: 200,
            child: buildText('Boat-Time'),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildCustomerDetails() {
    pw.Widget buildText(String text) => pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.black,
            font: pw.Font.timesBold(),
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: buildText('1'),
          ),
          pw.SizedBox(
            width: 230,
            child: buildText('Sahitha Undavalli'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Female'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('Customer'),
          ),
          pw.SizedBox(
            width: 170,
            child: buildText('India'),
          ),
          pw.SizedBox(
            width: 200,
            child: buildText('BATMAN-11:00AM'),
          ),
        ],
      ),
    );
  }
}
