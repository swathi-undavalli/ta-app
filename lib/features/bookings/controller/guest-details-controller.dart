import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temple_adventures/core/services/file-uploader.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/models/customer-model.dart';

class GuestDetailsLogic {
  GuestDetailsController controller = Get.put(GuestDetailsController());

  ImagePicker imagePicker = ImagePicker();
  Function onImagePicked;

  init() {
    controller.bookingModel = Get.arguments;
  }

  browseImage(bool isFront, ImageSource source) async {
    print("==========started");
    XFile pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 50);
    print("==========ended");

    if (pickedFile != null) {
      if (isFront) controller.idProofFile = pickedFile;
      controller.idProofLink = null;
      controller.uploadedImageUrl = null;
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
    if (controller.firstNameTED.text.isNotEmpty &&
        controller.emailTED.text.isNotEmpty &&
        controller.phoneNumberTED.text.isNotEmpty &&
        controller.genderTED.text.isNotEmpty &&
        (controller.idProofFile != null || controller.idProofLink.isNotEmpty)) {
      controller.pageLoading = true;
      if (!controller.customerExist) {
        await createCustomer();
      }
      await addGuest();
      await updateCustomer();
      controller.pageLoading = false;
      Get.back();
      controller.reset();
    } else {
      Fluttertoast.showToast(msg: "Invalid details");
    }
  }

  Future<void> createCustomer() async {
    controller.uploadedImageUrl = await FileUploader.uploadCustomerID(
        file: File(controller.idProofFile.path));
    CustomerModel customer = CustomerModel(
      countryCode: controller.countryCodeTED.text,
      firstName: controller.firstNameTED.text,
      lastName: controller.lastNameTED.text,
      email: controller.emailTED.text,
      phoneNumber: controller.phoneNumberTED.text,
      gender: controller.genderTED.text,
      idProof: controller.uploadedImageUrl,
    );
    await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .set(customer.toMap());
  }

  addGuest() async {
    controller.bookingModel.pax.add({
      "email": controller.emailTED.text,
      "first-name": controller.firstNameTED.text,
      "last-name": controller.lastNameTED.text,
      "countryCode": controller.countryCodeTED.text,
      "phoneNumber": controller.phoneNumberTED.text,
      "isoCode": controller.countryISoCOde,
      "gender": controller.genderTED.text,
      "idProof": await getIDProofLink()
    });
    log(controller.bookingModel.pax.toString());
    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(controller.bookingModel.id)
        .set(controller.bookingModel.toMap());
  }

  Future<bool> isCustomerExists() async {
    var d = await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .get();
    Map<String, dynamic> data = d.data();
    if (data == null) return false;
    controller.customerModel = CustomerModel.fromMap(data);
    log(controller.customerModel.toMap().toString());
    controller.firstNameTED.text = controller.customerModel.firstName;
    controller.lastNameTED.text = controller.customerModel.lastName;
    controller.phoneNumberTED.text = controller.customerModel.phoneNumber;
    controller.genderTED.text = controller.customerModel.gender;
    controller.countryCodeTED.text = controller.customerModel.countryCode;
    controller.idProofLink = controller.customerModel.idProof;
    return true;
  }

  Future<void> getDetailsPressed() async {
    controller.showLoading = true;
    controller.customerExist = await isCustomerExists();
    controller.getDetailsPressed = true;
    controller.showLoading = false;
  }

  updateCustomer() async {
    if (controller.customerModel == null) {
      controller.customerModel = CustomerModel();
    }
    controller.customerModel.firstName = controller.firstNameTED.text;
    controller.customerModel.lastName = controller.lastNameTED.text;
    controller.customerModel.countryCode = controller.countryCodeTED.text;
    controller.customerModel.email = controller.emailTED.text;
    controller.customerModel.phoneNumber = controller.phoneNumberTED.text;
    controller.customerModel.gender = controller.genderTED.text;
    controller.customerModel.idProof = await getIDProofLink();
    await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .set(controller.customerModel.toMap());
  }

  Future<String> getIDProofLink() async {
    if (controller.customerExist) {
      if (controller.idProofFile != null) {
        if (controller.uploadedImageUrl == null)
          controller.uploadedImageUrl = await FileUploader.uploadCustomerID(
              file: File(controller.idProofFile.path));
        return controller.uploadedImageUrl;
      } else {
        return controller.idProofLink;
      }
    } else {
      if (controller.uploadedImageUrl == null)
        controller.uploadedImageUrl = await FileUploader.uploadCustomerID(
            file: File(controller.idProofFile.path));
      return controller.uploadedImageUrl;
    }
  }
}

class GuestDetailsController extends GetxController {
  TextEditingController firstNameTED = TextEditingController();
  TextEditingController lastNameTED = TextEditingController();
  TextEditingController emailTED = TextEditingController();
  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController genderTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode genderNode = FocusNode();
  XFile _idProofFile;

  CustomerModel customerModel = CustomerModel();

  String _idProofLink;
  BookingModel bookingModel;

  bool _getDetailsPressed = false;

  bool _showLoading = false;

  bool _pageLoading = false;

  bool customerExist = false;

  String uploadedImageUrl;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  bool get pageLoading => _pageLoading;

  set pageLoading(bool value) {
    _pageLoading = value;
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
    firstNameTED.text = "";
    lastNameTED.text = "";
    emailTED.text = "";
    genderTED.text = "";
    idProofFile = null;
    getDetailsPressed = false;
    showLoading = false;
    customerExist = false;
    idProofLink = null;
    customerModel = null;
  }

  String _countryISoCOde = "IN";

  List<String> gender = ['Male', 'Female'];

  String get countryISoCOde => _countryISoCOde;

  set countryISoCOde(String value) {
    _countryISoCOde = value;
    update();
  }
}
