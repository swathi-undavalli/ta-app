import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/customer_model.dart';
import '../../models/dive-log-model.dart';
import 'share_booking_details_widget.dart';

class CustomerLogs {
  static Future<File> generatePdf(CustomerModel customer, List<DiveLogModel> logs) async {
    final pdf = pw.Document();
    final imageByteData = await rootBundle.load('images/AppLogoPondy.png');
    final imageUint8List = imageByteData.buffer.asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

    final image = pw.MemoryImage(imageUint8List);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4.landscape,
        ),
        build: (context) => <pw.Widget>[
          pw.Row(
            children: [
              pw.SizedBox(width: 30),
              pw.Image(image, height: 70, width: 70),
              pw.Spacer(),
              pw.Text(
                'Temple Adventures',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(0xff263238),
                  fontSize: 30,
                  wordSpacing: 2,
                  fontBold: pw.Font.courierBold(),
                ),
              ),
              pw.Spacer(),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    customer.name,
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColor.fromInt(0xff575757),
                      // fontWeight: FontWeight.w500,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    customer.email ?? '-',
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColor.fromInt(0xff575757),
                      // fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildSubTitle(
                    title: 'Total Dives :',
                    text: logs.length.toString(),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 25),
          pw.Container(
            height: 1,
            width: Get.width * 2,
            color: const PdfColor.fromInt(0xffD9D9D9),
          ),
          pw.SizedBox(height: 20),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildSectionTitle(title: 'Dive Logs'),
              pw.SizedBox(height: 6),
              buildLogTitle(),
              for (var log in logs) buildLog(log),
            ],
          ),
        ],
      ),
    );
    return ShareBookingDetails.saveDocument(name: '${customer.name}.pdf', pdf: pdf);
  }

  static pw.Widget buildSectionTitle({required String title}) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 20,
        color: PdfColors.black,
      ),
    );
  }

  static pw.Widget buildLogTitle() {
    pw.Widget buildText(String text) => pw.Text(
          text,
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
          ),
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 10),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: buildText('Date'),
          ),
          pw.SizedBox(
            width: 100,
            child: buildText('Instructor'),
          ),
          pw.SizedBox(
            width: 80,
            child: buildText('Course'),
          ),
          pw.SizedBox(
            width: 80,
            child: buildText('Site'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('Tank No'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('Bottom Time\n (mins)'),
          ),
          pw.SizedBox(width: 10),
          pw.SizedBox(
            width: 70,
            child: buildText('Max Depth\n (m)'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('Time in'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('Rental equipment'),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildLog(DiveLogModel log, [bool isTitle = false]) {
    pw.Widget buildText(String text) => pw.Text(
          text,
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColor.fromInt(0xff575757),
          ),
        );

    String getInitials(String text) {
      String t = '';
      text.split(' ').forEach((e) {
        if (e.isNotEmpty) {
          t = t + (e[0].capitalize).toString();
        }
      });

      return t;
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: buildText(
              DateFormat('dd/MM/yyyy').format(log.timeIn.toDate()),
            ),
          ),
          pw.SizedBox(
            width: 100,
            child: buildText(log.instructor.name),
          ),
          pw.SizedBox(
            width: 80,
            child: buildText(getInitials(log.course)),
          ),
          pw.SizedBox(
            width: 80,
            child: buildText(log.diveSite),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('${log.tankType ?? ''} ${log.tankNo.toString()}'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText('${log.bottomTime}'),
          ),
          pw.SizedBox(width: 10),
          pw.SizedBox(
            width: 70,
            child: buildText('${log.maxDepth}'),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText(
              DateFormat('hh:mm a').format(log.timeIn.toDate()),
            ),
          ),
          pw.SizedBox(
            width: 70,
            child: buildText((log.rentalEquipment != null) ? log.rentalEquipment! : '-'),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildSubTitle({required String title, String? text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.Container(
            width: 100,
            child: pw.Text(
              title,
              style: const pw.TextStyle(
                fontSize: 14,
                color: PdfColor.fromInt(0xff575757),
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
          pw.Container(
            width: 50,
            child: pw.Text(
              (text != null && text.isNotEmpty) ? text : '-',
              style: const pw.TextStyle(
                fontSize: 14,
                color: PdfColors.black,
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
