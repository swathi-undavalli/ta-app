import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/controller/boat-controller.dart';

class BoatPage extends StatelessWidget {
  final BoatLogic logic = BoatLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Under Construction"),
        ),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GetBuilder<BoatController>(builder: (controller) {
                return ExpansionPanelList(
                  animationDuration: Duration(seconds: 200),
                  dividerColor: Colors.grey,
                  elevation: 0,
                  expandedHeaderPadding: EdgeInsets.all(8),
                  children: controller.boats.map((boatName) {
                    int index = controller.boats.indexOf(boatName);
                    print(index);
                    return ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return ListTile(
                          title: Text(boatName),
                        );
                      },
                      body: ListTile(
                        title: Text("Is open now!"),
                        subtitle: const Text(
                            'To delete this panel, tap the trash can icon'),
                        trailing: const Icon(Icons.delete),
                      ),
                      isExpanded: controller.isOpen[index],
                    );
                  }).toList(),
                  expansionCallback: (i, isOpen) {
                    controller.isOpen[i] = !controller.isOpen[i];
                    controller.update();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
