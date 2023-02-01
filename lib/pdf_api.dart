import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class PdfAPi {
  static Future<File> generateImage(BookingModel booking) async {
    final pdf = pw.Document();
    List<String?> netImage = [];
    for (int i = 1; i < booking.pax!.length; i++) {
      print(booking.pax![i]["idProof"]);
      netImage.add(booking.pax![i]["idProof"]);
    }

    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
    );

    List<pw.Widget> list = [];
    for (int i = 0; i < netImage.length; i++) {
      var im = await networkImage(netImage[i]!);
      var img = pw.Padding(
        padding: const pw.EdgeInsets.only(left: 20, right: 20, top: 10),
        child: pw.Container(
          constraints: pw.BoxConstraints(
              minHeight: 300, maxHeight: 300, maxWidth: 300, minWidth: 300),
          child: pw.Image(im),
        ),
      );
      list.add(img);
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) {
          return [
            pw.GridView(
              crossAxisCount: 2,
              childAspectRatio: 1,
              children: [
                ...list,
              ],
            ),
          ];
        },
      ),
    );

    return saveDocument(name: 'ID:${booking.id} IdProofs.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({String? name, required pw.Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
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
}
