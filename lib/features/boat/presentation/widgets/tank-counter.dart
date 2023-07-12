import 'package:flutter/material.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class TankCounter extends StatefulWidget {
  const TankCounter({
    Key? key,
    required this.onChanged,
    required this.nitrox,
    required this.air,
    this.titleColor,
  }) : super(key: key);

  final Function(int nitrox, int air) onChanged;
  final int nitrox;
  final Color? titleColor;
  final int air;

  @override
  State<TankCounter> createState() => _TankCounterState();
}

class _TankCounterState extends State<TankCounter> {
  int air = 0, nitrox = 0;

  @override
  void initState() {
    air = widget.air;
    nitrox = widget.nitrox;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildAirNitrox(title: "Nitrox", isNitrox: true),
        buildAirNitrox(title: "Air", isNitrox: false),
      ],
    );
  }

  Widget buildIncrementDecrement(
      {required Function onTap, required IconData icon}) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 35,
          width: 35,
          child: Icon(
            icon,
            size: 14,
            // color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: AppColors.text.skyBlue.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        ));
  }

  Widget buildAirNitrox({required String title, required bool isNitrox}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: widget.titleColor ?? Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            buildIncrementDecrement(
                onTap: () {
                  if (isNitrox && nitrox > 0) {
                    nitrox -= 1;
                  } else if (air > 0) {
                    air -= 1;
                  }
                  widget.onChanged(nitrox, air);
                  setState(() {});
                },
                icon: Icons.remove),
            SizedBox(width: 15),
            Text((isNitrox) ? nitrox.toString() : air.toString()),
            SizedBox(width: 15),
            buildIncrementDecrement(
                onTap: () {
                  if (isNitrox) {
                    nitrox += 1;
                  } else {
                    air += 1;
                  }
                  widget.onChanged(nitrox, air);
                  setState(() {});
                },
                icon: Icons.add),
          ],
        ),
      ],
    );
  }
}
