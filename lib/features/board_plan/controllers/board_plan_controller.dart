import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../boat/models/boats.dart';
import '../../bookings/models/booking_model.dart';
import '../presentation/widgets/customer_details.dart';

class BoardPlanLogic {
  BoardPlanController controller = Get.put(BoardPlanController());

  Future<void> init(DateTime date) async {
    controller.showLoading = true;
    await getAllBoats(date);
    controller.showLoading = false;
  }

  Future<void> getAllBoats(DateTime date) async {
    controller.boats = [];
    controller.selectedBoat = null;
    controller.isGeneralInfoSelected = false;

    var data =
        await FirebaseFirestore.instance.collection('dailyBoats').doc(DateFormat('dd-MM-yyyy').format(date)).get();

    BoatsModel boatsModel = BoatsModel.fromMap(data.data());
    controller.boats.addAll(boatsModel.boats as Iterable<Boat>);
    if (controller.boats.isNotEmpty) {
      controller.selectedBoat = controller.boats[0];
    } else {
      controller.isGeneralInfoSelected = true;
    }
  }

  Future<void> onDateChanged(DateTime date) async {
    selectedDate = date;
    controller.showLoading = true;
    await init(selectedDate);
    controller.showLoading = false;
  }
}

class BoardPlanController extends GetxController {
  bool _showLoading = true;
  bool _isGeneralInfoSelected = false;
  Boat? selectedBoat;

  List<Boat> boats = [];

  List<Booking> bookings = [];

  bool get showLoading => _showLoading;

  bool get isGeneralInfoSelected => _isGeneralInfoSelected;

  set isGeneralInfoSelected(bool value) {
    _isGeneralInfoSelected = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}
