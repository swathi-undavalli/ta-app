import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../employees/model/employee.dart';
import '../models/category.dart';
import '../models/offer.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'offers_controller.dart';

class AddOffersLogic {
  AddOffersController controller = Get.put(AddOffersController());
  final FirebaseStorage _storage = FirebaseStorage.instance;
  OffersLogic offersLogic = OffersLogic();

  Future<void> init(OfferElement offerElement) async {
    controller.showLoading = true;
    controller.update();

    for (Categories cat in offersLogic.controller.categories) {
      if (cat.id == offerElement.categoryId) {
        controller.selectedCategory = cat;
      }
    }

    controller.nameTED.text = offerElement.name ;
    controller.descriptionTED.text = offerElement.description ?? '';
    if (offerElement.validDates != [] && offerElement.validDates?.length == 2) {
      controller.startDate = offerElement.validDates?.first.toDate();
      controller.endDate = offerElement.validDates?.last.toDate();
      controller.validDates = offerElement.validDates ?? [];
    }
    for (String link in offerElement.photos ?? []) {
      controller.pickedMediaFiles.add(await getImageFileFromURL(link));
      controller.update();
    }
    controller.showLoading = false;
    controller.update();
  }

  Future<File> getImageFileFromURL(String image) async {
    final response = await http.get(Uri.parse(image));

    final documentDirectory = await getTemporaryDirectory();

    final file = File(path.join(documentDirectory.path, '${DateTime.now().microsecondsSinceEpoch}.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  Future<void> pickImage(ImageSource source) async {
    if (PermissionStatus.granted.isGranted) {
      // ignore: invalid_use_of_visible_for_testing_member
      final result = await ImagePicker.platform.getImage(source: source);

      if (result != null) {
        controller.pickedImage = File(result.path);
        controller.pickedMediaFiles.add(controller.pickedImage!);
        controller.update();
      }
    }
  }

  Future<void> onImageHolderTap(selectedIndex) async {
    controller.selectedImageIndex = selectedIndex;
    controller.update();
  }

  Future<void> onImageDeleteTap() async {
    log(controller.selectedImageIndex.toString());
    log(controller.pickedMediaFiles.length.toString());
    log(controller.pickedMediaFiles.toString());

    if (controller.pickedMediaFiles.length == 1) {
      controller.selectedImageIndex = 0;
      controller.pickedMediaFiles = [];
      controller.update();

      return;
    }
    if (controller.selectedImageIndex + 1 == controller.pickedMediaFiles.length) {
      controller.selectedImageIndex = controller.selectedImageIndex - 1;
      controller.pickedMediaFiles.removeLast();
      log(controller.selectedImageIndex.toString());
    } else {
      controller.pickedMediaFiles.removeAt(controller.selectedImageIndex);
      log(controller.selectedImageIndex.toString());
    }
    controller.update();
  }

  Future<List<String>> uploadImages() async {
    List<String> downloadURLs = [];

    for (int i = 0; i < controller.pickedMediaFiles.length; i++) {
      File imageFile = controller.pickedMediaFiles[i];

      try {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i';

        Reference storageReference = _storage.ref().child('offers/$fileName.jpg');

        await storageReference.putFile(imageFile);

        String downloadURL = await storageReference.getDownloadURL();
        downloadURLs.add(downloadURL);

        log('Image $i uploaded. Download URL: $downloadURL');
      } catch (error) {
        log('Error uploading image $i: $error');
      }
    }

    return downloadURLs;
  }

  Future<void> onAddPressed() async {
    controller.showLoading = true;
    controller.update();
    List<String> downloadURLs = await uploadImages();
    log('images uploaded');
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('allOffers').doc('offers').get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Offer offer = Offer.fromJson(data);

    OfferElement offerElement = OfferElement(
      categoryId: controller.selectedCategory?.id,
      name: controller.nameTED.text,
      validDates: controller.validDates,
      description: controller.descriptionTED.text,
      photos: downloadURLs,
      createdBy: currentEmployee?.name ?? '',
    );

    if (controller.index != null) {
      offer.offerElement?[controller.index!] = offerElement;
    } else {
      offer.offerElement?.add(offerElement);
    }
    await FirebaseFirestore.instance.collection('allOffers').doc('offers').set(offer.toJson());
    controller.showLoading = false;
    controller.update();
    controller.clear();
    Get.back();
  }
}

class AddOffersController extends GetxController {
  Categories? selectedCategory;
  TextEditingController nameTED = TextEditingController();
  TextEditingController descriptionTED = TextEditingController();
  DateTimeRange? dateRange;
  DateTime? startDate;
  DateTime? endDate;
  List<Timestamp> validDates = [];
  List<File> pickedMediaFiles = [];
  File? pickedImage;
  int selectedImageIndex = 0;
  bool showLoading = false;
  int? index;

  clear() {
    nameTED.text = '';
    descriptionTED.text = '';
    validDates = [];
    pickedMediaFiles = [];
    selectedCategory = null;
    startDate = null;
    endDate = null;
    selectedImageIndex = 0;
    pickedImage = null;
    index = null;
  }
}
