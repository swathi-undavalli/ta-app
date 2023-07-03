import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class CounterWidget extends StatefulWidget {
  CounterWidget(
      {Key? key, required this.onChanged, this.size, required this.countValue})
      : super(key: key);

  final Function(int count) onChanged;
  final String? size;
  final int countValue;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.countValue.toString());
    counter = widget.countValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildCounter(widget.size ?? "");
  }

  Widget buildCounter(String e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Center(
              child: Text(e,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        ),
        SizedBox(width: 15),
        buildIncrementDecrement(
            onTap: () {
              if (counter > 0) counter -= 1;
              controller.text = counter.toString();
              widget.onChanged(counter);
              setState(() {});
            },
            icon: Icons.remove),
        SizedBox(width: 15),
        SizedBox(
          width: 35,
          height: 20,
          child: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                counter = int.parse(value);
              } else {
                counter = 0;
              }
              widget.onChanged(counter);
            },
            decoration: InputDecoration(
              labelText: '',
            ),
          ),
        ),
        SizedBox(width: 15),
        buildIncrementDecrement(
            onTap: () {
              counter += 1;
              controller.text = counter.toString();
              widget.onChanged(counter);
              setState(() {});
            },
            icon: Icons.add),
      ],
    ).paddingOnly(bottom: 10);
  }

  Widget buildIncrementDecrement(
      {required Function onTap, required IconData icon}) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 30,
          width: 30,
          child: Icon(
            icon,
            size: 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.text.skyBlue.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        ));
  }
}