import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/ta_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

class ViewPhotosBottomSheet extends StatefulWidget {
  final List<String>? images;
  final String offerTitle;

  const ViewPhotosBottomSheet({
    Key? key,
    required this.images,
    required this.offerTitle,
  }) : super(key: key);

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
                  width: Get.width,
                  fit: BoxFit.contain,
                  borderRadius: 5,
                ),
                Spacing.h10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        saveImageToGallery(e);
                      },
                      icon: const Icon(
                        Icons.arrow_circle_down_rounded,
                        size: 28,
                      ),
                    ),
                    Spacing.w10,
                    IconButton(
                        onPressed: () {
                          shareImage(e);
                        },
                        icon: const Icon(Icons.share)),
                  ],
                )
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

        await Share.shareFiles([imageFile.path],
            text: 'Check out the new ${widget.offerTitle}!',
            subject: 'Offer',
            mimeTypes: ['image/png'],
            sharePositionOrigin: Rect.fromCenter(center: Offset(0, 0), width: 0, height: 0));
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

      await ImageGallerySaver.saveImage(Uint8List.fromList(response.bodyBytes));
    } catch (error) {
      log('Error downloading or saving image: $error');
    }
  }
}
