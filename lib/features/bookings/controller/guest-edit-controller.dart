import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temple_adventures/core/services/file-uploader.dart';
import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/models/customer-model.dart';

class GuestsEditLogic {
  GuestsEditController controller = Get.put(GuestsEditController());

  ImagePicker imagePicker = ImagePicker();
  Function onImagePicked;

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
        controller.phoneTED.text.isNotEmpty &&
        controller.genderTED.text.isNotEmpty &&
        (controller.idProofFile != null || controller.idProofLink.isNotEmpty)) {
      controller.pageLoading = true;
      // await addGuest();
      await updatePassenger();
      log("heloooooooooooooooooo");
      await updateCoastGuardSlip();
      log("heloooooooooooooooooo");
      await updateCustomer();
      controller.pageLoading = false;
      Get.back();
      controller.reset();
    } else {
      Fluttertoast.showToast(msg: "Invalid details");
    }
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
    controller.phoneTED.text = controller.customerModel.phoneNumber;
    controller.genderTED.text = controller.customerModel.gender;
    controller.countryCodeTED.text = controller.customerModel.countryCode;
    controller.idProofLink = controller.customerModel.idProof;
    return true;
  }

  Future<String> getIDProofLink() async {
    if (controller.idProofFile != null) {
      controller.uploadedImageUrl = await FileUploader.uploadCustomerID(
          file: File(controller.idProofFile.path));
      return controller.uploadedImageUrl;
    } else {
      return controller.idProofLink;
    }
  }

  updateCustomer() async {
    if (controller.customerModel == null) {
      controller.customerModel = CustomerModel();
    }
    controller.customerModel.firstName = controller.firstNameTED.text;
    controller.customerModel.lastName = controller.lastNameTED.text;
    controller.customerModel.countryCode = controller.countryCodeTED.text;
    controller.customerModel.email = controller.emailTED.text;
    controller.customerModel.phoneNumber = controller.phoneTED.text;
    controller.customerModel.gender = controller.genderTED.text;
    controller.customerModel.idProof = await getIDProofLink();
    await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .set(controller.customerModel.toMap());
  }

  updatePassenger() async {
    int i = 1;

    for (i = 1; i < controller.bookingModel.pax.length; i++) {
      if (controller.bookingModel.pax[i]["email"] ==
          controller.customerModel.email) {
        break;
      }
    }
    controller.bookingModel.pax[i]["email"] = controller.emailTED.text;
    controller.bookingModel.pax[i]["first-name"] = controller.firstNameTED.text;
    controller.bookingModel.pax[i]["last-name"] = controller.lastNameTED.text;
    controller.bookingModel.pax[i]["phoneNumber"] = controller.phoneTED.text;
    controller.bookingModel.pax[i]["countryCode"] =
        controller.countryCodeTED.text;
    controller.bookingModel.pax[i]["gender"] = controller.genderTED.text;
    controller.bookingModel.pax[i]["idProof"] = await getIDProofLink();

    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(controller.bookingModel.id)
        .set(controller.bookingModel.toMap());
  }

  updateCoastGuardSlip() async {
    for (int i = 0; i < controller.bookingModel.diveDate.length; i++) {
      var diveDate = controller.bookingModel.diveDate[i];
      print(DateFormat("dd-MM-yyyy").format(diveDate));
      var data = await FirebaseFirestore.instance
          .collection("coastGuardSlip")
          .doc(DateFormat("dd-MM-yyyy").format(diveDate))
          .get();
      log("===============================");
      log(data.data().toString());
      Map<String, dynamic> d = data.data();

      if (d != null) {
        BoatPassengersModel boatPassengersModel =
            BoatPassengersModel.fromMap(d[diveDate.toIso8601String()]);
        for (i = 0; i < boatPassengersModel.passenger.length; i++) {
          if (boatPassengersModel.passenger[i].email ==
              controller.customerModel.email) {
            break;
          }
        }
        log(i.toString());
        log("========================================");
        boatPassengersModel.passenger[i].email = controller.emailTED.text;
        boatPassengersModel.passenger[i].name = controller.firstNameTED.text;
        boatPassengersModel.passenger[i].phone = controller.phoneTED.text;
        boatPassengersModel.passenger[i].gender = controller.genderTED.text;

        d[diveDate.toIso8601String()] = boatPassengersModel.toMap();
        await FirebaseFirestore.instance
            .collection("coastGuardSlip")
            .doc(DateFormat("dd-MM-yyyy").format(diveDate))
            .set(d);
      } else {
        break;
      }
    }

    print(controller.bookingModel.diveDate);
  }
}

class GuestsEditController extends GetxController {
  CustomerModel customerModel;
  BookingModel bookingModel;

  TextEditingController firstNameTED = TextEditingController();
  TextEditingController lastNameTED = TextEditingController();
  TextEditingController phoneTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController emailTED = TextEditingController();
  TextEditingController genderTED = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode genderNode = FocusNode();

  reset() {
    phoneTED.text = "";
    countryCodeTED.text = "";
    firstNameTED.text = "";
    lastNameTED.text = "";
    emailTED.text = "";
    genderTED.text = "";
    idProofFile = null;
    // getDetailsPressed = false;
    // showLoading = false;
    customerExist = false;
    idProofLink = null;
    customerModel = null;
  }

  XFile _idProofFile;
  bool customerExist = false;
  String _isoCode = "IN";
  String _idProofLink;
  String uploadedImageUrl;
  bool _pageLoading = false;

  List<String> gender = ['Male', 'Female'];

  String get isoCode => _isoCode;

  XFile get idProofFile => _idProofFile;

  String get idProofLink => _idProofLink;

  bool get pageLoading => _pageLoading;

  set pageLoading(bool value) {
    _pageLoading = value;
    update();
  }

  set idProofLink(String value) {
    _idProofLink = value;
    update();
  }

  set idProofFile(XFile value) {
    _idProofFile = value;
    update();
  }

  set isoCode(String value) {
    _isoCode = value;
    update();
  }
}
