import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show basename;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:temple_ui_tools/utils/utils.dart';

import '../../models/booking_model.dart';

class ShareBookingDetails {
  static Future<File> generatePdf(Booking booking) async {
    final pdf = pw.Document();
    final imageByteData = await rootBundle.load('images/AppLogoPondy.png');
    final imageUint8List = imageByteData.buffer.asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

    final image = pw.MemoryImage(imageUint8List);
    const pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => <pw.Widget>[
          pw.Row(
            children: [
              pw.Image(image, height: 60, width: 60),
              pw.Spacer(),
              pw.FittedBox(
                child: pw.Text(
                  'ODESSY WATERSPORTS PVT LTD,\n#6A, Gandhi st., Colas Nagar,\nOpposite to Indira Gandhi Stadium \nPondicherry, India \nContact : +91 9940219449 / 6385686600',
                  style: const pw.TextStyle(
                    color: PdfColor.fromInt(0xff263238),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 25),
          pw.Container(
            height: 1,
            width: Screen.width * 2,
            color: const PdfColor.fromInt(0xffD9D9D9),
          ),
          pw.SizedBox(height: 25),
          pw.Center(
            child: pw.Text(
              "${"${booking.details!.firstName} ${booking.details!.lastName}"}'s".capitalizeFirst!,
              style: const pw.TextStyle(
                fontSize: 20,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Center(
            child: pw.Text(
              booking.activity![0]!.name!,
              style: const pw.TextStyle(
                fontSize: 16,
                color: PdfColor.fromInt(0xff737373),
              ),
            ),
          ),
          pw.SizedBox(height: 25),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildSectionTitle(title: 'Booking Details'),
              pw.SizedBox(height: 6),
              buildBookingDetails(title: 'Booking ID', text: booking.id),
              buildBookingDetails(
                title: 'Name',
                text: '${booking.details!.firstName} ${booking.details!.lastName}',
              ),
              buildBookingDetails(
                title: 'Pax',
                text: booking.noOfPersons.toString(),
              ),
              buildBookingDetails(
                title: 'Email ID',
                text: booking.details!.email,
              ),
              buildBookingDetails(
                title: 'Activity',
                text: booking.activity![0]!.name,
              ),
              buildDates(title: 'Dive Dates', dates: booking.diveDate!, showTime: false),
              buildDates(title: 'Theory Dates', dates: booking.theoryDate!, showTime: true),
              buildDates(title: 'Pool Dates', dates: booking.poolDate!, showTime: true),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.SizedBox(
            child: pw.Text(
              'Note : Thank you for considering Temple Adventures for your scuba diving experience. We are pleased to offer a variety of dive plans to accommodate your needs and preferences. Our team is dedicated to providing a safe and enjoyable diving experience, and sometimes we have to negotiate the time of your dive based on the availability of our boats.We understand that flexibility is important, and we strive to accommodate your schedule to the best of our ability. Please let us know if you have any specific requests, and we will do our best to accommodate them.',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColor.fromInt(0xff575757),
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildSectionTitle(title: 'Payment Details'),
              pw.SizedBox(height: 6),
              buildBookingDetails(
                title: 'Total Amount',
                text: '${booking.totalCost.toStringAsFixed(0)} /-',
              ),
              buildBookingDetails(
                title: 'Deposit',
                text: '${booking.paid!.toStringAsFixed(0)} /-',
              ),
              buildBookingDetails(
                title: 'Balance',
                text: '${(booking.totalCost - booking.paid!).toStringAsFixed(0)} /-',
              ),
              buildBookingDetails(
                title: 'Receipt No',
                text: booking.receiptNo ?? '-',
              ),
              buildBookingDetails(
                title: 'Payment Mode',
                text: booking.paymentMode ?? '-',
              ),
              buildBookingDetails(
                title: 'Transaction ID',
                text: (booking.paymentTransactionId != '' || booking.paymentTransactionId != null)
                    ? booking.paymentTransactionId
                    : '-',
              ),
              pw.SizedBox(height: 10),
              buildAllTransactions(booking),
            ],
          ),
          pw.SizedBox(height: 30),
          pw.Text(
            'For any queries,',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColor.fromInt(0xff979797),
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'Contact : ${booking.employeeName}',
            style: const pw.TextStyle(
              fontSize: 10,
              // fontWeight: pw.FontWeight.w600,
              color: PdfColor.fromInt(0xff505050),
            ),
          ),
        ],
      ),
    );
    return saveDocument(name: 'ID: ${booking.id} BookingDetails.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String? name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    // final url = file.path;
    // await OpenFile.open(url);
  }

  static Future<File> loadNetwork(String url) async {
    final pdfUrl = Uri.parse(url);

    final response = await http.get(pdfUrl);
    final bytes = response.bodyBytes;

    return storeFile(url, bytes);
  }

  static Future<File> storeFile(String url, List<int> bytes) async {
    final fileName = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    log(file.path);
    return file;
  }

  static pw.Widget buildSectionTitle({required String title}) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 16,
        color: PdfColors.black,
      ),
    );
  }

  static pw.Widget buildAllTransactions(Booking booking) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          buildSectionTitle(title: 'All Transactions'),
          pw.SizedBox(height: 6),
          buildListOfPayments(
            payments: [
              PaymentModel(
                amount: booking.paid!.roundToDouble(),
                collectedBy: booking.employeeName,
                reciptNo: booking.receiptNo,
                referenceNo: booking.paymentTransactionId,
                remarks: '',
                paymentMode: booking.paymentMode,
                time: booking.createdAt,
              ),
              ...booking.payments!,
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildListOfPayments({required List<PaymentModel> payments}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        ...List.generate(
          payments.length,
          (index) {
            return buildTransaction(payment: payments[index]);
          },
        ),
      ],
    );
  }

  static pw.Widget buildTransaction({required PaymentModel payment}) {
    DateTime now = DateTime.now();
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Payment ${payment.amount!.round()} by ${payment.paymentMode ?? "-"} collected by ${payment.collectedBy}",
            style: const pw.TextStyle(
              fontSize: 12,
              // fontWeight: pw.FontWeight.w600,
              wordSpacing: 2,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 2),
          if (payment.time != null &&
              now.day == payment.time!.day &&
              now.month == payment.time!.month &&
              now.year == payment.time!.year)
            pw.Text(
              "Today - ${DateFormat("hh:mm a").format(payment.time!)}",
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
            )
          else if (payment.time != null)
            pw.Text(
              DateFormat('EEE dd MMM yy - hh:mm a').format(payment.time!),
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey,
              ),
            )
          else
            pw.Text(
              'Initial Deposit',
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey,
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget buildBookingDetails({required String title, String? text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              title,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
          pw.Container(
            width: 200,
            child: pw.Text(
              (text != null && text.isNotEmpty) ? text : '-',
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColor.fromInt(0xff575757),
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildDates({
    required bool showTime,
    required List<DateTime?> dates,
    required String title,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              title,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
                // fontWeight: FontWeight.w500,
              ),
            ),
          ),
          pw.Column(
            children: [
              if (dates.isNotEmpty)
                ...dates.map(
                  (e) {
                    String date = (showTime == false)
                        ? DateFormat('dd-MM-yyyy').format(e!)
                        : DateFormat('dd-MM-yyyy @ hh:mm a').format(e!);
                    log(date.toString());
                    return pw.Container(
                      width: 200,
                      child: pw.Text(
                        date,
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColor.fromInt(0xff575757),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                )
              else
                pw.Container(
                  width: 200,
                  child: pw.Text(
                    '-',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColor.fromInt(0xff575757),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
