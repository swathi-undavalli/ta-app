import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class Seat extends StatefulWidget {
  Seat(
      {Key key,
      @required this.selected,
      @required this.enabled,
      this.isFixed = false,
      @required this.onSelected})
      : super(key: key);

  bool selected;
  bool enabled;
  bool isFixed;
  final Function(bool) onSelected;

  @override
  _SeatState createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  Color borderColor, color, seatNoColor;
  int seatNo;

  @override
  Widget build(BuildContext context) {
    if (widget.selected) {
      borderColor = AppColors.text.skyBlue;
      color = AppColors.text.lightSkyBlue;
      seatNo = 3;
      seatNoColor = AppColors.text.black;
    } else {
      borderColor = Color(0xff5BFF62);
      color = Color(0xffD1FFBB);
      seatNoColor = AppColors.text.grey;
      seatNo = 1;
    }

    return GestureDetector(
      onTap: () {
        if (!widget.isFixed) {
          if (widget.enabled || widget.selected) {
            setState(() {
              widget.selected = !widget.selected;
            });
            widget.onSelected(widget.selected);
          }
        } else {
          Fluttertoast.showToast(msg: "Booked");
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5, top: 13),
        child: Container(
          height: 22,
          width: 17,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(4),
            border: Border.all(
                color: widget.isFixed ? Colors.grey : borderColor, width: 1),
            color: widget.isFixed ? Colors.grey.withOpacity(0.7) : color,
          ),
          child: Center(
            child: Icon(
              Icons.star,
              size: 7,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
