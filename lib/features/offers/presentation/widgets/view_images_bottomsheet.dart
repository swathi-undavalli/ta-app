import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/widgets/ta_image.dart';

class ViewPhotosBottomSheet extends StatefulWidget {
  final List<String>? images;
  final String offerTitle;

  const ViewPhotosBottomSheet({
    super.key,
    required this.images,
    required this.offerTitle,
  });

  static Future<void> getImages(
    BuildContext context, {
    required List<String>? allImages,
    required String offer,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return ViewPhotosBottomSheet(
          images: allImages,
          offerTitle: offer,
        );
      },
    );
  }

  @override
  State<ViewPhotosBottomSheet> createState() => _ViewPhotosBottomSheetState();
}

class _ViewPhotosBottomSheetState extends State<ViewPhotosBottomSheet> {
  bool isDownloading = false;
  bool isSharing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Spacing.h10,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30,
              ),
              const Text(
                'All Images',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ).paddingOnly(top: 8),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              Spacing.w30,
            ],
          ),
          ...(widget.images ?? []).map(
            (e) => Column(
              children: [
                TAImage(
                  e,
                  width: Screen.width,
                  fit: BoxFit.contain,
                  borderRadius: 5,
                ),
                Spacing.h10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (isDownloading)
                        ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 3).size(20, 20)
                        : IconButton(
                            onPressed: () async {
                              setState(() {
                                isDownloading = true;
                              });
                              await saveImageToGallery(e);
                              setState(() {
                                isDownloading = false;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_circle_down_rounded,
                              size: 28,
                            ),
                          ),
                    Spacing.w10,
                    (isSharing)
                        ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 3).size(20, 20)
                        : IconButton(
                            onPressed: () async {
                              setState(() {
                                isSharing = true;
                              });
                              await shareImage(e);
                              setState(() {
                                isSharing = false;
                              });
                            },
                            icon: const Icon(Icons.share),
                          ),
                  ],
                ),
              ],
            ).paddingSymmetric(vertical: 20, horizontal: 20),
          ),
          Spacing.h10,
        ],
      ).scrollable,
    );
  }

  Future<void> shareImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();

        File imageFile = File('${tempDir.path}/image.png');

        await imageFile.writeAsBytes(response.bodyBytes);

        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: 'Check out the new ${widget.offerTitle}!',
          subject: 'Offer',
          sharePositionOrigin: Rect.fromCenter(center: const Offset(0, 0), width: 0, height: 0),
        );
      } else {
        throw Exception('Failed to load image');
      }
    }
    // Share.share('Sharing image: $response');
  }

  Future<void> saveImageToGallery(String imageUrl) async {
    await _downloadAndSaveImage(imageUrl);

    Fluttertoast.showToast(msg: 'Images are downloaded successfully');
  }

  Future<void> _downloadAndSaveImage(String imageUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));

      await ImageGallerySaverPlus.saveImage(Uint8List.fromList(response.bodyBytes));
    } catch (error) {
      log('Error downloading or saving image: $error');
    }
  }
}
