// // // https://zuzubusylabs.s3.ap-south-1.amazonaws.com/pictures/vocabulary/activities/dolch-sight/activityTile/this-one.svg
// // //
// // //
// // //     {
// // // "left": ["soft","happy","hot"],
// // // "right": ["cold","hard","sad"],
// // // "answers": {"soft":"hard","hot":"cold","happy":"sad"},
// // // }
// // //
// // // {
// // // "left": ["young","tall","dirty"],
// // // "right": ["clean","old","short"],
// // // "answers": {"young":"old","dirty":"clean","tall":"short"},
// // // }
// // //
// // // {
// // // "left": ["Day","Weak","First"],
// // // "right": ["Last","Strong","Night"],
// // // "answers": {"Day":"Night","Weak":"Strong","First":"Last"},
// // // }
// // //
// // // {
// // // "left": ["Fast","Big","Heavy"],
// // // "right": ["Slow","Light","Small"],
// // // "answers": {"Fast":"Slow","Big":"Small","Heavy":"Light"},
// // // }
// // //
// // // {
// // // "left": ["Open","Rich","Full"],
// // // "right": ["Empty","Close","Poor"],
// // // "answers": {"Open":"Close","Rich":"Poor","Full":"Empty"},
// // // }
// //
// // //
// //
// // // void main() {
// // //   var arr = [1, 2, 3, 4, 3, 2];
// // //   var res = 0;
// // //   for (int i = 0; i < arr.length; i++) {
// // //     res = res + arr[i];
// // //   }
// // //
// // //   //print(res);
// // // }
// //
// // // void main() {
// // //   var n = 5025;
// // //   var value = convertFive(n);
// // //   //print(value);
// // // }
// // //
// // // int convertFive(int n) {
// // //   var newNum = 0;
// // //   var result = 0;
// // //   while (n != 0) {
// // //     var r = n % 10;
// // //     if (r == 0) {
// // //       r = 5;
// // //       newNum = newNum * 10 + r;
// // //     } else {
// // //       newNum = newNum * 10 + r;
// // //     }
// // //     n = (n / 10).floor();
// // //   }
// // //   while (newNum != 0) {
// // //     result = result * 10 + (newNum % 10);
// // //     newNum = (newNum / 10).floor();
// // //   }
// // //   return result;
// // // }
// //
// // //
// //
// // // class Solution {
// // //
// // //   String hii;
// // //
// // //   printHelloWorld() {
// // //     //print("Hello World");
// // //   }
// // // }
// // //
// // // void main() {
// // //   Solution solution = Solution();
// // //   solution.printHelloWorld();
// // //   solution.hii = "Sahitha";
// // //   //print(solution.hii);
// // // }
// //
// // // void main() {
// // //   var arr = [1, 2, 4, 11, 8, 10];
// // //
// // //   int x = 9;
// // //
// // //   var count = countOfElements(arr, x);
// // //
// // //   //print(count);
// // // }
// // //
// // // int countOfElements(List<int> arr, int x) {
// // //   var newArr = [];
// // //
// // //   for (int i = 0; i < arr.length; i++) {
// // //     if (arr[i] < x) {
// // //       newArr.add(arr[i]);
// // //     }
// // //   }
// // //
// // //   return newArr.length;
// // // }
// // //
// //
// // // void main(){
// // //
// // //   int n = 3;
// // //
// // //   var sum = seriesNum(n);
// // //
// // //   //print(sum);
// // //
// // // }
// // //
// // // int seriesNum(int n) {
// // //
// // //   var sum = 0;
// // //
// // //   for(int i = 1 ; i <= n ; i++){
// // //
// // //     sum = sum + i;
// // //
// // //   }
// // //
// // //   return sum;
// // // }
// //
// // // import 'dart:io';
// // //
// // // void main() {
// // //   var arr = [1, 2, 3, 4, 5];
// // //
// // //   for (int i = 0; i < arr.length; i++) {
// // //     stdout.write("${arr[i]} ");
// // //   }
// // // }
// //
// // // void main(){
// // //
// // //   var names = ["Geek", "Geeks", "Geeksfor",
// // //     "GeeksforGeeksfor", "GeeksforGeekforGeek"];
// // //
// // //       var big = names[0];
// // //
// // //       for(int i = 0 ; i < names.length ; i++){
// // //
// // //         if(big.length <= names[i].length){
// // //
// // //           big = names[i];
// // //
// // //         }
// // //     }
// // //
// // //       //print(big);
// // //
// // // }
// //
// // // void main(){
// // //
// // //   var str = "ABCddE";
// // //
// // //   //print(str.toLowerCase());
// // //
// // // }
// //
// // // void main() {
// // //   int a = 3;
// // //   int b = 3;
// // //
// // //   var product = multiplication(a, b);
// // //
// // //   //print(product);
// // // }
// // //
// // // int multiplication(int a, int b) {
// // //   int c = a * b;
// // //
// // //   return c;
// // // }
// //
// // // void main() {
// // //   var arr = [5, 3, 6, 1, 2];
// // //   var k = 2;
// // //
// // //   var start = arr[k - 1];
// // //
// // //   var end = arr.last - (k - 1);
// // //
// // //   //print(start);
// // //   //print(end);
// // // }
// //
// // // void main() {
// // //   var n = 153;
// // //
// // //   var res = armstrongNumber(n);
// // //
// // //   //print(res);
// // // }
// // //
// // // String armstrongNumber(int n) {
// // //   var sum = 0;
// // //   var temp = n;
// // //   while (n != 0) {
// // //     var r = n % 10;
// // //
// // //     sum = sum + (r * r * r);
// // //
// // //     n = (n / 10).floor();
// // //   }
// // //   if (sum == temp) {
// // //     return "true";
// // //   } else
// // //     return "false";
// // // }
// //
// // // void main() {
// // //   var l1 = [
// // //     [1, 2, 3],
// // //     [4, 5, 6]
// // //   ];
// // //   var l2 = [
// // //     [7, 8],
// // //     [9, 10],
// // //     [11, 12]
// // //   ];
// // //
// // //   var r = [[0,0,0],[0,0,0]];
// // //
// // //   for(int i = 0 ; i < l1.length ; i++){
// // //
// // //     for(int j = 0 ; j < l2[0].length ; j++){
// // //
// // //       for(int k = 0 ; k < l2.length ; k++){
// // //
// // //           r[i][j] += l1[i][k] * l2[k][j];
// // //
// // //       }
// // //       //print(r);
// // //
// // //     }
// // //   }
// // //
// // // }
// //
// // // import 'dart:io';
// // //
// // // void main() {
// // //   var s = "sahithaKamesh";
// // //
// // //   for(int i = s.length - 1 ; i >= 0 ; i--){
// // //
// // //     stdout.write(s[i]);
// // //
// // //   }
// // //
// // // }
// // // void main(){
// // //
// // //   var n = 6;
// // //
// // //
// // //
// // // }
// //
// // import 'package:flutter/material.dart';
// //
// // class W1 extends StatefulWidget {
// //   // static const String id = "W1";
// //   @override
// //   _W1State createState() => _W1State();
// // }
// //
// // class _W1State extends State<W1> {
// //   bool d = true;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           d = !d;
// //         });
// //       },
// //       child: Padding(
// //         padding: const EdgeInsets.only(bottom: 20.0),
// //         child: Container(
// //           height: 100,
// //           width: 100,
// //           color: d ? Colors.red : Colors.green,
// //         ),
// //       ),
// //     );
// //   }
// // }
// // To parse this JSON data, do
// //
// //     final boatPassengersModel = boatPassengersModelFromMap(jsonString);
//
// // import 'dart:convert';
// //
// // BoatPassengersModel boatPassengersModelFromMap(String str) => BoatPassengersModel.fromMap(json.decode(str));
// //
// // String boatPassengersModelToMap(BoatPassengersModel data) => json.encode(data.toMap());
// //
// // class BoatPassengersModel {
// //   BoatPassengersModel({
// //     this.employees,
// //   });
// //
// //   List<Employee> employees;
// //
// //   factory BoatPassengersModel.fromMap(Map<String, dynamic> json) => BoatPassengersModel(
// //     employees: List<Employee>.from(json["employees"].map((x) => Employee.fromMap(x))),
// //   );
// //
// //   Map<String, dynamic> toMap() => {
// //     "employees": List<dynamic>.from(employees.map((x) => x.toMap())),
// //   };
// // }
// //
// // class Employee {
// //   Employee({
// //     this.id,
// //     this.name,
// //     this.gender,
// //     this.phone,
// //   });
// //
// //   String id;
// //   String name;
// //   String gender;
// //   String phone;
// //
// //   factory Employee.fromMap(Map<String, dynamic> json) => Employee(
// //     id: json["id"],
// //     name: json["name"],
// //     gender: json["gender"],
// //     phone: json["phone"],
// //   );
// //
// //   Map<String, dynamic> toMap() => {
// //     "id": id,
// //     "name": name,
// //     "gender": gender,
// //     "phone": phone,
// //   };
// // }
//
// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class D1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//         FutureBuilder(
//         future: FirebaseFirestore.instance
//             .collection("employees")
//             .doc(id)
//             .collection("employeeFullInformation")
//             .doc("employeeData")
//             .get(),
//           builder: (BuildContext context, snapshot) {
//             try {
//               if (!snapshot.hasData) {
//                 return Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Container(
//                     height: 30,
//                     width: Get.width,
//                     child: Shimmer.fromColors(
//                       child: Container(
//                         height: 20,
//                         width: Get.width,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Colors.grey),
//                       ),
//                       baseColor: Colors.grey[300],
//                       highlightColor: Colors.grey[100],
//                     ),
//                   ),
//                 );
//               }
//               Map<String, dynamic> employeeData = snapshot.data.data();
//               var e = Employee.fromMap(employeeData);
//               allEmployeesList.add(e);
//               //print(e.id);
//               // //print("=============${logic.controller.allEmployeesList.length}");
//               // //print(e);
//               return buildEmployeeNames(e);
//             } catch (e) {
//               return SizedBox();
//             }
//           });          ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/core/widgets/app-expansion-panel.dart';
// import 'package:temple_adventures/features/counter-model.dart';
//
// import 'features/home/model/employee.dart';
//
// class D1 extends StatelessWidget {
//   static const String id = "D1";
//   TextEditingController searchTED = TextEditingController();
//
//   D1Logic logic = D1Logic();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   buildSearchBar(),
//                   SizedBox(height: 10),
//                   ...List.generate(counterModel.employee, (index) {
//                     return buildAllEmployees((index + 1).toString());
//                   }),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchBar() {
//     return Container(
//       height: 50,
//       child: TextField(
//         cursorColor: AppColors.text.darkgrey,
//         cursorHeight: 20,
//         decoration: InputDecoration(
//             prefixIcon: Icon(Icons.search_rounded,
//                 size: 18, color: Colors.black87.withOpacity(0.6)),
//             border: OutlineInputBorder(),
//             focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.black.withOpacity(0.3))),
//             hintText: 'Search...',
//             hintStyle: TextStyle(fontSize: 14, height: 1)),
//         controller: searchTED,
//         onChanged: (text) {
//           logic.controller.update();
//         },
//       ),
//     );
//   }
//
//   Widget buildAllEmployees(String employeeID) {
//     return GetBuilder<D1Controller>(builder: (controller) {
//       return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//           stream: FirebaseFirestore.instance
//               .collection("employees")
//               .doc(employeeID)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               Employee employee = Employee.fromMap(snapshot.data.data());
//               if (searchTED.text.isNotEmpty) {
//                 if (employee.id.contains(searchTED.text) ||
//                     employee.name
//                         .toLowerCase()
//                         .contains(searchTED.text.toLowerCase().trim()))
//                   return buildEmployeeNames(e: employee);
//                 return SizedBox();
//               }
//               return buildEmployeeNames(e: employee);
//             }
//             return Container();
//           });
//     });
//   }
//
//   Widget buildEmployeeNames({Employee e}) {
//     return Container(
//       child: Material(
//         child: InkWell(
//           onTap: () {
//             // selectedEmployees.add(e);
//           },
//           child: Container(
//             height: 47,
//             width: Get.width,
//             child: Row(
//               children: [
//                 Icon(Icons.account_circle, color: Colors.black38, size: 25),
//                 Text(
//                   "   ${e.name}",
//                   style: TextStyle(color: AppColors.text.black, fontSize: 14),
//                 ),
//                 Expanded(
//                     child: Container(
//                   color: Colors.transparent,
//                 )),
//               ],
//             ),
//           ),
//         ),
//         color: Colors.transparent,
//       ),
//     );
//   }

// Future<void> moveEmployee(String empId) async {
//   var data = await FirebaseFirestore.instance
//       .collection("employees")
//       .doc(empId)
//       .collection("employeeFullInformation")
//       .doc("employeeData")
//       .get();
//   //print(data.data());
//   Map<String, dynamic> employeeData = data.data();
//   FirebaseFirestore.instance
//       .collection("employees")
//       .doc(empId)
//       .set(employeeData);
// }
// }
//
// class D1Logic {
//   D1Controller controller = Get.put(D1Controller());
// }
//
// class D1Controller extends GetxController {
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/util/ta-image.dart';

class Dummy extends StatefulWidget {
  static const String id = "Dummy";
  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  double width = 0;
  List<Map<String, dynamic>> storyItems = [
    {
      "id": "iiiii",
      "createdAt": "2 min Ago",
      "img":
          "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-HD-images-8.jpg",
      "description": "hello",
    },
    {
      "id": "iiiii",
      "createdAt": "2 min Ago",
      "img":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Chinmayi_Sripada.JPG/220px-Chinmayi_Sripada.JPG",
      "description": "hello",
    },
    {
      "id": "iiiii",
      "createdAt": "2 min Ago",
      "img":
          "https://akm-img-a-in.tosshub.com/indiatoday/images/story/201812/Chinmaya.jpeg?AIJrvPVxJOa3.mFBRvk8ZjhkVbITEF.O&size=770:433",
      "description": "hello",
    },
    {
      "id": "iiiii",
      "createdAt": "2 min Ago",
      "img":
          "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-HD-images-8.jpg",
      "description": "hello",
    },
    {
      "id": "iiiii",
      "createdAt": "2 min Ago",
      "img":
          "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-3-1.jpg",
      "description": "hello",
    },
    {
      "id": "iiiii",
      "createdAt": "2 min Ago",
      "img":
          "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-HD-images-2.jpg",
      "description": "hello",
    },
  ];

  // Map<String, dynamic> storyItems = {
  //   "postedBy": "sai",
  //   "profilePicture": AppImages.background.emilia,
  //   "content": [
  //     {
  //       "id": "iiiii",
  //       "createdAt": "2 min Ago",
  //       "img": "https://fluttergems.dev/media/logo.png",
  //       "description": "hello",
  //     },
  //     {
  //       "id": "iiiii",
  //       "createdAt": "2 min Ago",
  //       "img": "https://fluttergems.dev/media/logo.png",
  //       "description": "hello",
  //     },
  //     {
  //       "id": "iiiii",
  //       "createdAt": "2 min Ago",
  //       "img": "https://fluttergems.dev/media/logo.png",
  //       "description": "hello",
  //     },
  //   ]
  // };
  bool isCompleted = true;
  int position = 0;
  Duration duration = Duration(seconds: 0);
  Timer _timer;
  @override
  void initState() {
    super.initState();
    storyTapped();
  }

  onStoryTapped() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (position != storyItems.length - 1) {
        setState(() {
          position = (position + 1) % storyItems.length;
          // isCompleted = false;
        });
      }
    });
    if (position != storyItems.length - 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        setState(() {
          isCompleted = true;
          width = Get.width;
          duration = const Duration(seconds: 5);
        });
        // setState(() {
        //   width = 0;
        // });
        Future.delayed(const Duration(seconds: 5)).whenComplete(() {
          setState(() {
            width = 0;
            duration = const Duration(seconds: 0);
          });
        });
      });
    } else {
      _timer.cancel();
      //print(_timer.isActive);
    }
  }

  storyTapped() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      buildStatus();
    });

    // else {
    //   setState(() {
    //     position = storyItems.length - 1;
    //     isCompleted = true;
    //     width = Get.width;
    //     duration = const Duration(seconds: 0);
    //   });
    // }
  }

  void buildStatus() {
    if (position != storyItems.length - 1) {
      setState(() {
        isCompleted = true;
        position = position + 1;
        width = Get.width;
        duration = const Duration(seconds: 5);
      });

      Future.delayed(const Duration(seconds: 5)).whenComplete(() {
        setState(() {
          width = 0;
          duration = const Duration(seconds: 0);
          isCompleted = false;
        });
      });
    }
  }

  storyBack() {
    if (position == 0) {
      setState(() {
        position = 0;
        width = 0;
        duration = const Duration(seconds: 0);
      });
    } else {
      setState(() {
        position = position - 1;
        width = 0;
        duration = const Duration(seconds: 0);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          TAImage(
            storyItems[position]["img"],
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 100,
            child: buildStory(isCompleted),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      storyTapped();
                    },
                    child: Text("Front")),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    storyBack();
                  },
                  child: Text("Back"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildStory(isCompleted) {
    return Stack(
      children: [
        Container(
          height: 4,
          width: Get.width,
          decoration: BoxDecoration(
            color: const Color(0x49ffffff),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        AnimatedContainer(
          duration: duration,
          height: 4,
          // width: DDMeasures.screenWidth,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
