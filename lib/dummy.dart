// var employees = [
//   ["1", "Donarun Das", "7569699928"],
//   ["2", "Aravind Tharunsri", "9003122231"],
//   ["3", "Rob Partridge", "9789270958"],
//   ["4", "Shaveer Patel", "9820107428"],
//   ["5", "Parthiban", "8428405051"],
//   ["6", "Jean Pierer", "9600243283"],
//   ["7", "Siddharth", "8329889224"],
//   ["8", "Santhosh", "8508854778"],
//   ["9", "Benjamine", "8148932039"],
//   ["10", "Anmol Kathuria", "9599181005"],
//   ["11", "Tamizhvanan ADY", "9894311548"],
//   ["12", "Devraj", "6385774026"],
//   ["13", "Tanvi", "9892840316"],
//   ["14", "Sachin", "7904096659"],
//   ["15", "Rajat Tomar", "9967212315"],
//   ["16", "Ajithkumar S", "8190875181"],
//   ["17", "Pushkar", "8197488616"],
//   ["18", "Azhar", "8098629070"],
//   ["19", "Sowkar Shariff", "9342215276"],
//   ["20", "Shakeel", "9994402232"],
//   ["21", "Mugunthan", "8682969403"],
//   ["22", "Raja Sekar", "9566467089"],
//   ["23", "Sambath", "8825428313"],
//   ["24", "Merline", "9791218240"],
//   ["25", "Chellappan", "8754657870"],
//   ["26", "Mary Rose", "8220317966"],
//   ["27", "Sundari Kannu", "9600765420"],
//   ["28", "Abhirami", ""],
//   ["29", "Jaquiline Marie", "6385340618"],
//   ["30", "Nirmala", "9791944804"],
//   ["31", "Lingam", "7449169160"],
//   ["32", "Raghima", "6385749075"],
//   ["33", "Arivashaki", "7397609765"],
//   ["34", "Bishnu", "8754899758"],
//   ["35", "Ravi", "9003752877"],
//   ["36", "Karthick", "9994313472"],
//   ["37", "Dessappan", "7708406926"],
//   ["38", "Veeran@Selvam", "9159028330"],
//   ["39", "Rajasekar", "9585658610"],
//   ["40", "Muthuvel", "9786324754"],
//   ["41", "Siva Selvam", "9585439665"],
//   ["42", "Vendhan", "9159028330"],
//   ["43", "Jakeer", "9715316954"]
// ];
//
//
//
// // DropdownButton(
// // underline: Container(height: 1, color: Colors.black45),
// // isExpanded: true,
// // value: (controller.discountOptionsTED.text.isNotEmpty)
// // ? controller.discountOptionsTED.text
// //     : null,
// // onChanged: (option) {
// // controller.discountOptionsTED.text = option;
// // controller.update();
// // logic.getPrice();
// // },
// // items: controller.discountOptions.map((newOption) {
// // return DropdownMenuItem(
// // child: new Text(newOption),
// // value: newOption,
// // );
// // }).toList(),
// // ),

import 'package:flutter/material.dart';

class EmployeeAccess extends StatelessWidget {
  final Widget child;
  final bool access;
  final bool showMessage;

  EmployeeAccess(
      {@required this.child, @required this.access, this.showMessage});

  @override
  Widget build(BuildContext context) {
    if ((access == null || !access) && showMessage != null && showMessage)
      return SizedBox(
        height: 300,
        child: Center(
          child: Text("You Don't have Access to this page"),
        ),
      );
    if (access != null && access) return child;
    return SizedBox();
  }

  static run({
    @required Function function,
    @required bool access,
  }) {
    if (access != null && access) function();
  }
}
