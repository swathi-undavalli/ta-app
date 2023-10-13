import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget(
      {Key? key,
      required this.onChanged,
      this.label,
      required this.initialValue,})
      : super(key: key);

  final Function(int count) onChanged;
  final String? label;
  final int initialValue;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue.toString());
    counter = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return buildCounter(widget.label);
  }

  Widget buildCounter(String? e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (e != null)
          SizedBox(
            width: 40,
            child: Center(
                child: Text(e,
                    style:
                        const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),),
          ),
        const SizedBox(width: 15),
        buildIncrementDecrement(
            onTap: () {
              if (counter > 0) counter -= 1;
              controller.text = counter.toString();
              widget.onChanged(counter);
              setState(() {});
            },
            icon: Icons.remove,),
        Spacing.w15,
        SizedBox(
          width: 35,
          height: 20,
          child: TextField(
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Only allow digits
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,2}$')),
            ],
            onChanged: (value) {
              if (value.isNotEmpty && (int.tryParse(value))! < 100) {
                counter = int.parse(value);
              } else {
                counter = 0;
              }
              widget.onChanged(counter);
              setState(() {});
            },
            decoration: const InputDecoration(
              labelText: '',
            ),
          ),
        ),
        Spacing.w15,
        buildIncrementDecrement(
            onTap: () {
              if (counter < 99) {
                counter += 1;
                controller.text = counter.toString();
                widget.onChanged(counter);
                setState(() {});
              }
            },
            icon: Icons.add,),
      ],
    ).paddingOnly(bottom: 10);
  }

  Widget buildIncrementDecrement(
      {required Function onTap, required IconData icon,}) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: AppColors.text.skyBlue.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(
            icon,
            size: 14,
          ),
        ),);
  }
}
