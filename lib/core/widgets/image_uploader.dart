import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/widgets/ta_image.dart';
import '../../features/certifications/presentation/widgets/pick_photos_widget.dart';

class ImageUploader extends StatefulWidget {
  const ImageUploader({super.key, required this.onImageUploaded, this.initialImage});

  final Function(String imageUrl) onImageUploaded;
  final String? initialImage;

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  Uint8List? selectedImage;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showImageSourceBottomSheet(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          image: _getDecorationImage,
        ),
        height: 80,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showLoading)
              CircularProgressIndicator(
                color: selectedImage == null ? Colors.black : Colors.white,
                strokeWidth: 2,
              ).size(15, 15)
            else if (selectedImage == null) ...[
              const Icon(Icons.add),
              const Text('Add'),
            ],
          ],
        ),
      ),
    );
  }

  DecorationImage? get _getDecorationImage {
    if (selectedImage == null && widget.initialImage == null) return null;
    if (selectedImage != null) {
      return DecorationImage(
        image: MemoryImage(
          selectedImage!,
        ),
        fit: BoxFit.cover,
      );
    }
    return DecorationImage(
      image: CachedNetworkImageProvider(
        widget.initialImage!,
      ),
      fit: BoxFit.cover,
    );
  }

  Future<void> _showImageSourceBottomSheet() async {
    setState(() {
      showLoading = true;
    });
    var source = await _ImageSourceSelector.show(context);
    await _pickImage(source);
    setState(() {
      showLoading = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (PermissionStatus.granted.isGranted) {
      final result = await ImagePicker().pickImage(source: source, imageQuality: 30);

      if (result != null) {
        final selectedFile = File(result.path);
        selectedImage = await result.readAsBytes();
        final url = await uploadImage(selectedFile, 'Images');
        widget.onImageUploaded(url);
      }
    }
  }
}

class _ImageSourceSelector extends StatelessWidget {
  static Future<ImageSource> show(BuildContext context) async {
    var data = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => const _ImageSourceSelector(),
    );
    return data as ImageSource;
  }

  const _ImageSourceSelector();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          ListTile(
            leading: TAImage(
              AppImages.icons.camera,
            ),
            title: const Text(
              'Camera',
            ),
            onTap: () async {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          ListTile(
            leading: TAImage(
              AppImages.icons.gallery,
            ),
            title: const Text(
              'Gallery',
            ),
            onTap: () async {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
