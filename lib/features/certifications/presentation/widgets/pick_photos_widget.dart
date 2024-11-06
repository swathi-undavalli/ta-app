import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/ta_image.dart';

class PickPhotosWidget extends StatefulWidget {
  const PickPhotosWidget({super.key, this.pickedImage, required this.onChanged});
  final String? pickedImage;
  final Function(File image) onChanged;

  @override
  State<PickPhotosWidget> createState() => _PickPhotosWidgetState();
}

class _PickPhotosWidgetState extends State<PickPhotosWidget> {
  File? selectedImage;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppButton.miniFlat(
          onTap: () {
            _showImageSourceBottomSheet();
          },
          text: (widget.pickedImage != null || selectedImage != null) ? 'Change Photo' : 'Add Photo',
        ),
        Spacing.w20,
        if (selectedImage != null)
          SizedBox(
            height: 40,
            width: 40,
            child: Image.file(
              selectedImage!,
              height: Screen.width * 4 / 3,
              width: Screen.width,
              fit: BoxFit.cover,
            ),
          )
        else if (widget.pickedImage != null)
          SizedBox(
            height: 40,
            width: 40,
            child: Image.network(
              widget.pickedImage!,
              height: Screen.width * 4 / 3,
              width: Screen.width,
              fit: BoxFit.cover,
            ),
          ),
        if (showLoading)
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
      ],
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                  Navigator.pop(context);
                  await pickImage(ImageSource.camera);
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
                  Navigator.pop(context);
                  await pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    if (PermissionStatus.granted.isGranted) {
      final result = await ImagePicker().pickImage(source: source, imageQuality: 30);

      if (result != null) {
        selectedImage = File(result.path);
        widget.onChanged(selectedImage!);
      }
    }
  }
}

Future<String> uploadImage(File? selectedImage, String storagePath) async {
  String downloadURL = '';

  if (selectedImage != null) {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}';

      Reference storageReference = FirebaseStorage.instance.ref().child('$storagePath/$fileName.jpg');

      await storageReference.putFile(selectedImage);

      downloadURL = await storageReference.getDownloadURL();
    } catch (error) {
      log('Error uploading image : $error');
    }
  }

  return downloadURL;
}
