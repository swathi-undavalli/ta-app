import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QRImage extends StatefulWidget {
  QRImage({this.height, this.width, this.data, Key? key}) : super(key: key);

  double? height;
  double? width;
  String? data;

  @override
  State<QRImage> createState() => _QRImageState();
}

class _QRImageState extends State<QRImage> {
  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      barcode: Barcode.qrCode(
        errorCorrectLevel: BarcodeQRCorrectionLevel.high,
      ),
      data: widget.data!,
      height: widget.height ?? 260,
      width: widget.width ?? 260,
    );
  }
}
