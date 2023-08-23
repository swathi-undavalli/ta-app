import 'package:get/get.dart';

class DiveChecklistLogic {
  DiveChecklistController controller = Get.put(DiveChecklistController());
}

class DiveChecklistController extends GetxController {
  List<String> recreationalStudentDiveCheckList = [
    "BCD",
    "Regulator",
    "Mask",
    "Fins",
    "Boots",
    "Wetsuit",
    "Cargo Shorts",
    "Sharkskin",
    "Computer",
    "SMBs",
    "Reels",
    "Cutting Device",
    "Compass",
    "Torch",
    "Medical Kit",
    "Tool kit",
    "Student Computer",
    "Student Equipment",
    "Student Snorkel",
    "Student Wetsuit",
    "Student Weights",
  ];
  List<String> recreationalDiveCheckList = [
    "BCD",
    "Regulator",
    "Mask",
    "Fins",
    "Boots",
    "Wetsuit",
    "Cargo Shorts",
    "Sharkskin",
    "Computer",
    "SMBs",
    "Reels",
    "Cutting Device",
    "Compass",
    "Torch",
    "Medical Kit",
    "Tool kit",
  ];
}
