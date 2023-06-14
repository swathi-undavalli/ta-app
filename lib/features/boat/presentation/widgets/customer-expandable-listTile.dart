import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class ExpandableListTile extends StatefulWidget {
  const ExpandableListTile({
    Key? key,
    required this.expandedChild,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String title;
  final Widget expandedChild;
  final Color color;

  @override
  State<ExpandableListTile> createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(
        minHeight: isExpanded ? 500 : 50,
      ),
      width: Get.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: Get.width - 200,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                IconButton(
                  splashRadius: 20,
                  icon: Icon(isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ).paddingSymmetric(vertical: 3),
            isExpanded
                ? FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 200)),
                initialData: SizedBox(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return widget.expandedChild
                        .paddingSymmetric(horizontal: 15);
                  }
                  return SizedBox();
                })
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
