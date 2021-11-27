import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/bookings/controller/customer-registration-controller.dart';
import 'package:temple_adventures/features/bookings/controller/paper-work-controller.dart';

class PaperWorkScreen extends StatelessWidget {
  static const String id = "PaperWorkScreen";

  final PaperWorkLogic logic = PaperWorkLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      floatingActionButton: buildFloatingActionButton(),
      backgroundColor: AppColors.background.lightBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildAppButton(),
              SizedBox(height: 10),
              buildStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppButton() {
    return GetBuilder<PaperWorkController>(builder: (controller) {
      return AppButton.flat(
        text: "Open",
        onTap: logic.showDocument,
        enable: controller.pdfDownloaded,
        textColor: AppColors.text.white,
        color: AppColors.background.black,
      );
    });
  }

  Widget buildStatus() {
    return GetBuilder<PaperWorkController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Status : ",
            style: TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (controller.pdfDownloaded)
            Text(
              "PDF downloaded",
              style: TextStyle(
                fontSize: FontSize.small,
                color: AppColors.text.green,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            Text(
              "PDF downloading..",
              style: TextStyle(
                fontSize: FontSize.small,
                color: AppColors.text.darkgrey,
              ),
            )
        ],
      );
    });
  }

  buildAppbar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        "Paper Work",
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildFloatingActionButton() {
    return GetBuilder<PaperWorkController>(builder: (controller) {
      if (controller.showFAB)
        return FloatingActionButton(
          onPressed: logic.onCheckFABPressed,
          elevation: 0,
          backgroundColor: AppColors.IconColor.black,
          child: Icon(
            Icons.check,
          ),
        );
      return SizedBox();
    });
  }
}

// class PaperWorkScreen extends StatelessWidget {
//   static const String id = "PaperWorkScreen";
//
//   final PaperWorkLogic logic = PaperWorkLogic();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppbar(),
//       floatingActionButton: buildFloatingActionButton(),
//       backgroundColor: AppColors.background.lightBlue,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               buildAppButton(),
//               SizedBox(height: 10),
//               buildStatus(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildAppButton() {
//     return GetBuilder<PaperWorkController>(builder: (controller) {
//       return AppButton.flat(
//         text: "Open",
//         onTap: logic.showDocument,
//         enable: controller.pdfDownloaded,
//         textColor: AppColors.text.white,
//         color: AppColors.background.black,
//       );
//     });
//   }
//
//   Widget buildStatus() {
//     return GetBuilder<PaperWorkController>(builder: (controller) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "Status : ",
//             style: TextStyle(
//               fontSize: FontSize.small,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           if (controller.pdfDownloaded)
//             Text(
//               "PDF downloaded",
//               style: TextStyle(
//                 fontSize: FontSize.small,
//                 color: AppColors.text.green,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           else
//             Text(
//               "PDF downloading..",
//               style: TextStyle(
//                 fontSize: FontSize.small,
//                 color: AppColors.text.darkgrey,
//               ),
//             )
//         ],
//       );
//     });
//   }
//
//   buildAppbar() {
//     return AppBar(
//       toolbarHeight: 70,
//       centerTitle: true,
//       title: Text(
//         "Paper Work",
//         style: TextStyle(
//           color: AppColors.text.black,
//           fontSize: 20,
//           fontFamily: AppFonts.nunito,
//           fontWeight: FontWeight.normal,
//           letterSpacing: 1.2,
//         ),
//       ),
//       leading: BackNavigationIcon(),
//       elevation: 0,
//       backgroundColor: AppColors.background.white,
//     );
//   }
//
//   Widget buildFloatingActionButton() {
//     return GetBuilder<PaperWorkController>(builder: (controller) {
//       if (controller.showFAB)
//         return FloatingActionButton(
//           onPressed: logic.onCheckFABPressed,
//           elevation: 0,
//           backgroundColor: AppColors.IconColor.black,
//           child: Icon(
//             Icons.check,
//           ),
//         );
//       return SizedBox();
//     });
//   }
// }
