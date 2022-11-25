import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/Freelancers/presentation/screens/all-freelancers-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import '../../../../core/authentication/firebase-authentication.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/add_employee_widget/add_employee_widget.dart';
import '../../../../core/widgets/attendance_report_widget/attendance_report_widget.dart';
import '../../../../core/widgets/attendance_widget/attandence_widget_controller.dart';
import '../../../../core/widgets/attendance_widget/attendence_widget.dart';
import '../../../login/presentation/screens/login-page.dart';
import '../../controller/home-page-controller.dart';

class HomePage extends StatelessWidget {
  final HomePageLogic logic = HomePageLogic();
  final now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        var futures = <Future>[];

        AttendanceWidgetLogic attendanceWidgetLogic = AttendanceWidgetLogic();
        AttendanceReportWidgetLogic attendanceReportWidgetLogic = AttendanceReportWidgetLogic();

        futures.add(attendanceWidgetLogic.reloadData());
        futures.add(attendanceReportWidgetLogic.reloadData());

        await Future.wait(futures);
      },
      child: Scaffold(
        backgroundColor: AppColors.background.lightBlue,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0, top: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        dashboardDrawerKey.currentState.openDrawer();
                      },
                      icon: Icon(Icons.menu_rounded),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //      margin: EdgeInsets.only(left: 0, top: 10),
                  //      width: 200,
                  //       alignment: Alignment.centerLeft,
                  //       child: IconButton(
                  //         onPressed: () {
                  //           dashboardDrawerKey.currentState.openDrawer();
                  //         },
                  //         icon: Icon(Icons.menu_rounded),
                  //       ),
                  //     ),
                  //     Container(
                  //      // margin: EdgeInsets.only(right: 10, top: 10),
                  //      // width: 200,
                  //       //alignment: Alignment.centerRight,
                  //       child: IconButton(
                  //         onPressed: () {
                  //           FirebaseAuthentication.logout();
                  //           Get.offAndToNamed(LoginScreen.id);
                  //         },
                  //         icon: Icon(Icons.logout),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 10),

                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text("Do"),
                  // ),
                  AttendanceWidget(),
                  SizedBox(height: 20),
                  AddEmployeeWidget(
                    text: "Add Employees",
                    subText: "Only admins can modify",
                    onTap: () {
                      Get.toNamed(AllEmployeesScreen.id);
                    },
                  ),
                  SizedBox(height: 20),
                  AddEmployeeWidget(
                    text: "Add Freelancers",
                    subText: "Only admins can modify",
                    onTap: () {
                      Get.toNamed(AllFreelancersScreen.id);
                    },
                  ),
                  SizedBox(height: 20),
                  AttendanceReportWidget(),
                  SizedBox(height: 100),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future sendEmail() async{
  //   final email = 'sahithaundavalli2000@gmail.com';
  //
  //   final smtpServer = gmailSaslXoauth2(email,token);
  //
  //   final message = Message()
  //   ..from = Address(email,'Sahitha')
  //   ..recipients = ['swathi.undavalli2003@gmail.com']
  //   ..subject = 'Hello Sahitha'
  //   ..text = 'This is a test email!';
  //   try{
  //     await send(message, smtpServer);
  //     showToast("Email Sent Successfully");
  //   }catch(e){
  //
  //     print(e);
  //
  //   }
  // }

  getFirstName(String d) {
    d = d.trim();
    return d.split(" ").first.trim();
  }

  getLastName(String d) {
    d = d.trim();

    return d.replaceAll(getFirstName(d), "").trim();
  }

  // Future<void> createPDF() async {
  //   PdfDocument document = PdfDocument();
  //   final page = document.pages.add();
  //
  //   for (int i = 0; i < 2; i++) {
  //     final image = document.pages[i];
  //     print(i);
  //     image.graphics.drawImage(
  //         PdfBitmap(await readImages('images/AppLogoPondy.png')),
  //         Rect.fromLTWH(0, 0, Get.width, Get.height));
  //   }
  //
  //   List<int> bytes = document.save();
  //   document.dispose();
  //
  //   saveLaunchFile(bytes, 'Output.pdf');
  // }
  //
  // Future<void> saveLaunchFile(List<int> bytes, String fileName) async {
  //   final path = (await getExternalStorageDirectory()).path;
  //   final file = File('$path/$fileName');
  //   await file.writeAsBytes(bytes, flush: true);
  //   OpenFile.open('$path/$fileName');
  // }
  //
  // Future<Uint8List> readImages(String image) async {
  //   final data = await rootBundle.load('images/AppLogoPondy.png');
  //   return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  // }

}

getString(List<String> sublist) {
  if (sublist.length != 0) {
    return sublist[0];
  }
  return "";
}

// Future<String> getPDFlink({
//   @required String email,
//   @required List<String> activity,
//   @required String location,
//   @required String fName,
//   @required String lName,
//   @required String bday,
//   @required String ad1,
//   @required String ad2,
//   @required String con,
//   @required String state,
//   @required String city,
//   @required String pin,
//   @required String phone,
//   @required String gen,
// }) async {
//   String api = "https://templeadventures.com/api/v1/generatePdf/";
//   var body = {
//     "email": email,
//     "Activity": activity,
//     "Location": location,
//     "first-name": fName,
//     "last-name": lName,
//     "Birthday": bday,
//     "Address-1": ad1,
//     "Address-2": ad2,
//     "Country": con,
//     "State": state,
//     "City": city,
//     "Pin-Code": pin,
//     "Phone": phone,
//     "Gender": gen,
//   };
//
//   var dio = Dio();
//   try {
//     //print("started");
//     FormData formData = new FormData.fromMap(body);
//     var response = await dio.post(api, data: formData);
//     var data = jsonDecode(response.data);
//     //print(response.data);
//     //print(data[0]);
//     return data[0];
//     //print("ended");
//   } catch (e) {
//     //print(e);
//   }
//   return "no data found";
// }
//
// Future<File> showPDFh() async {
//   //print("getting url");
//   String link = await getPDFlink(
//     email: "kamesh.wb@gmail.com",
//     activity: ["Open Water"],
//     location: "Puducherry",
//     fName: "Siddharth",
//     lName: "Jha",
//     bday: "1993-07-26",
//     ad1: "TEST",
//     ad2: "TEST",
//     con: "India",
//     state: "Maharashtra",
//     city: "Mumbai",
//     pin: "411015",
//     phone: "8329889224",
//     gen: "Male",
//   );
//   var response = await http.get(Uri.parse(link));
//
//   var documentDirectory = await getTemporaryDirectory();
//
//   var file = File(join(
//       documentDirectory.path, '${DateTime.now().micr
//   osecondsSinceEpoch}.pdf'));
//
//   //print(1);
//   file.writeAsBytesSync(response.bodyBytes);
//   //print(2);
//   await Pspdfkit.present(file.path);
//   return file;
// }

// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromMap(jsonString);
