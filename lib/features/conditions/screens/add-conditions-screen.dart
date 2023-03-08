import 'package:flutter/material.dart';

import '../controller/add-conditions-controller.dart';
import '../widgets/depth-expansion-panel-widget.dart';

class AddConditionsPage extends StatelessWidget {
  final AddConditionsLogic logic = AddConditionsLogic();
  static const String id = "AddConditionsPage";
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: DepthExpansionPanelWidget()),
    );
  }
}
