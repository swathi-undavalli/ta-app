import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temple_adventures/core/services/file-uploader.dart';
import 'package:temple_adventures/features/bookings/models/customer-model.dart';

class GuestDetailsLogic {
  GuestDetailsController controller = Get.put(GuestDetailsController());

  ImagePicker imagePicker = ImagePicker();
  Function onImagePicked;

  browseImage(bool isFront, ImageSource source) async {
    print("==========started");
    XFile pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 50);
    print("==========ended");

    if (pickedFile != null) {
      if (isFront) controller.idProofFile = pickedFile;
    }
  }

  void showBottomSheet(bool isFront) {
    Get.bottomSheet(
      Container(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Photo Library'),
              tileColor: Colors.white,
              onTap: () async {
                Get.back();
                browseImage(isFront, ImageSource.gallery);
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              tileColor: Colors.white,
              onTap: () async {
                Get.back();
                browseImage(isFront, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  Future<void> onSubmitPressed() async {
    if (controller.nameTED.text.isNotEmpty &&
        controller.emailTED.text.isNotEmpty &&
        controller.phoneNumberTED.text.isNotEmpty &&
        controller.genderTED.text.isNotEmpty &&
        controller.idProofFile != null) {
      if (!controller.customerExist) {
        await createCustomer();
        Get.back();
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid details");
    }
  }

  Future<void> createCustomer() async {
    String imgLink = await FileUploader.uploadCustomerID(
        file: File(controller.idProofFile.path));
    CustomerModel customer = CustomerModel(
      name: controller.nameTED.text,
      email: controller.emailTED.text,
      phoneNumber: controller.phoneNumberTED.text,
      gender: controller.genderTED.text,
      idProof: imgLink,
    );
    await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .set(customer.toMap());
  }

  Future<bool> isCustomerExists() async {
    var d = await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .get();
    Map<String, dynamic> data = d.data();
    if (data == null) return false;
    CustomerModel customer = CustomerModel.fromMap(data);
    log(customer.toMap().toString());
    controller.nameTED.text = customer.name;
    controller.phoneNumberTED.text = customer.phoneNumber;
    controller.genderTED.text = customer.gender;
    controller.countryCodeTED.text = customer.countryCode;
    controller.idProofLink = customer.idProof;
    return true;
  }

  Future<void> getDetailsPressed() async {
    controller.showLoading = true;
    controller.customerExist = await isCustomerExists();
    controller.getDetailsPressed = true;
    controller.showLoading = false;
  }
}

class GuestDetailsController extends GetxController {
  TextEditingController nameTED = TextEditingController();
  TextEditingController emailTED = TextEditingController();
  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController genderTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode genderNode = FocusNode();
  XFile _idProofFile;

  String _idProofLink;

  bool _getDetailsPressed = false;

  bool _showLoading = false;

  bool customerExist = false;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  bool get getDetailsPressed => _getDetailsPressed;

  set getDetailsPressed(bool value) {
    _getDetailsPressed = value;
    update();
  }

  String get idProofLink => _idProofLink;

  set idProofLink(String value) {
    _idProofLink = value;
    update();
  }

  XFile get idProofFile => _idProofFile;

  set idProofFile(XFile value) {
    _idProofFile = value;
    update();
  }

  reset() {
    phoneNumberTED.text = "";
    countryCodeTED.text = "";
    nameTED.text = "";
    emailTED.text = "";
    genderTED.text = "";
    idProofFile = null;
    _getDetailsPressed = false;
    _showLoading = false;
    customerExist = false;
  }

  String _countryISoCOde = "IN";

  List<String> gender = ['Male', 'Female'];

  String get countryISoCOde => _countryISoCOde;

  set countryISoCOde(String value) {
    _countryISoCOde = value;
    update();
  }
}
