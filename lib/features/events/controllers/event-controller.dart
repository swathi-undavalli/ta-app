import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/events/models/event-model.dart';


class EventLogic {
  EventController controller = Get.put(EventController());

  onDeletePressed(int index) async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('events').doc('events').get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Event event = Event.fromJson(data);
    event.eventElement?.removeAt(index);
    await FirebaseFirestore.instance.collection('events').doc('events').set(event.toJson());
  }
}

class EventController extends GetxController {}
