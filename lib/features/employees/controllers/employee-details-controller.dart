import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailsLogic{
  EmployeeDetailsController controller = Get.put(EmployeeDetailsController());


  makingPhoneCall() async {
    const url = 'tel:9876543210';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class EmployeeDetailsController extends GetxController {
}

///TODO:: Check please
// class EmployeeDetailsLogic{
//   EmployeeDetailsController controller = Get.put(EmployeeDetailsController());
//
//
//   makingPhoneCall() async {
//     const url = 'tel:9876543210';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
//
// class EmployeeDetailsController extends GetxController{}


