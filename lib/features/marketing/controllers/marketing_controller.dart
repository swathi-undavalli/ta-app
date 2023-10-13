import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/marketing_model.dart';

class MarketingLogic {
  MarketingController controller = Get.put(MarketingController());

  onDeletePressed(int index) async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('marketing').doc('marketing').get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Marketing marketing = Marketing.fromJson(data);
    marketing.marketingGallery?.removeAt(index);
    await FirebaseFirestore.instance.collection('marketing').doc('marketing').set(marketing.toJson());
  }
}

class MarketingController extends GetxController {}
