import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/category.dart';
import '../models/offer.dart';
import '../presentation/views/add_offers_view.dart';

class OffersLogic {
  OfferController controller = Get.put(OfferController());

  Future<void> fetchDataFromFirestore() async {
    controller.showLoading = true;
    controller.update();
    try {
      QuerySnapshot<Map<String, dynamic>> categories =
          await FirebaseFirestore.instance.collection('offerCategories').get();
      controller.categories = [];
      for (int i = 0; i < categories.docs.length; i++) {
        Categories category = Categories.fromMap(categories.docs[i].data());
        controller.categories.add(category);
      }
    } catch (error) {
      log('Error fetching data from Firestore: $error');
    }
    controller.showLoading = false;
    controller.update();
  }

  onDeletePressed(int index) async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('allOffers').doc('offers').get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Offer offer = Offer.fromJson(data);
    offer.offerElement?.removeAt(index);
    await FirebaseFirestore.instance.collection('allOffers').doc('offers').set(offer.toJson());
  }

  onEditPressed(int? index, OfferElement? offerElement) {
    Get.toNamed(AddOffersView.id, arguments: [index, offerElement]);
  }
}

class OfferController extends GetxController {
  bool showLoading = false;
  bool isDownloading = false;
  List<Categories> categories = [];
  int currentIndex = 0;
}
