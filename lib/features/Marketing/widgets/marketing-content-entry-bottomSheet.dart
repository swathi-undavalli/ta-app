import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/util/alignment_extensions.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/features/Marketing/models/marketing-model.dart';
import '../../../core/widgets/app-button.dart';

class MarketingContentEntryBottomSheet extends StatefulWidget {
  final MarketingElement? marketingElement;
  final int? index;

  const MarketingContentEntryBottomSheet({
    Key? key,
    this.marketingElement,
    this.index,
  }) : super(key: key);

  static Future show(
    BuildContext context, {
    MarketingElement? marketingElementModel,
    int? elementIndex,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return MarketingContentEntryBottomSheet(
          marketingElement: marketingElementModel,
          index: elementIndex,
        );
      },
    );

    return data;
  }

  @override
  State<MarketingContentEntryBottomSheet> createState() => _MarketingContentEntryBottomSheetState();
}

class _MarketingContentEntryBottomSheetState extends State<MarketingContentEntryBottomSheet> {
  late TextEditingController urlTED;
  late TextEditingController nameTED;
  late TextEditingController delayTED;
  String? urlType;
  List<String> urlTypesList = ["Image", "Video", "Lottie"];
  String? urlError;
  String? urlTypeError;
  String? delayError;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    urlTED = TextEditingController(text: widget.marketingElement?.url ?? "");
    delayTED = TextEditingController(
        text: (widget.marketingElement?.delay != null) ? widget.marketingElement?.delay.toString() : "");
    nameTED = TextEditingController(text: widget.marketingElement?.name);
    if (widget.marketingElement != null) {
      urlType = widget.marketingElement?.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          if (showLoading)
            Container(
              width: Get.width,
              height: 450,
              color: Colors.grey,
              child: CircularProgressIndicator(
                color: Colors.black,
              ).center,
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              buildKeyValuePair(
                title: "Name",
                controller: nameTED,
                textInputType: TextInputType.text,
              ),
              buildKeyValuePair(
                title: "URL",
                controller: urlTED,
                errorText: urlError,
                textInputType: TextInputType.text,
              ),
              Spacing.h25,
              buildDropDown(),
              if (urlType == "Image")
                buildKeyValuePair(
                  title: "Delay Time",
                  controller: delayTED,
                  errorText: delayError,
                  textInputType: TextInputType.numberWithOptions(),
                ),
              Spacing.h50,
              AppButton.flat(
                onTap: () async {
                  if (isValid()) {
                    showLoading = true;
                    setState(() {});
                    DocumentSnapshot document =
                        await FirebaseFirestore.instance.collection('marketing').doc('marketing').get();
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    Marketing marketing = Marketing.fromJson(data);

                    MarketingElement marketingElement = MarketingElement(
                      url: urlTED.text,
                      type: urlType ?? "",
                      delay: int.tryParse(delayTED.text),
                      name: nameTED.text,
                    );

                    if (widget.index != null) {
                      marketing.marketingGallery?[widget.index!] = marketingElement;
                    } else {
                      marketing.marketingGallery?.add(marketingElement);
                    }
                    await FirebaseFirestore.instance.collection('marketing').doc('marketing').set(marketing.toJson());

                    showLoading = false;
                    setState(() {});

                    Get.back();
                  }
                  setState(() {});
                },
                text: "Submit",
                color: Colors.black,
                textColor: Colors.white,
              )
            ],
          ).paddingSymmetric(horizontal: 20, vertical: 20),
        ],
      ),
    );
  }

  bool isValid() {
    bool isValid = true;
    urlError = null;
    urlTypeError = null;
    delayError = null;

    if (urlTED.text.isEmpty) {
      urlError = "Required";
      isValid = false;
    }
    if (urlType == null || urlType!.isEmpty) {
      urlTypeError = "Required";
      isValid = false;
    }
    if (urlType == "Image" && delayTED.text.isEmpty) {
      delayError = "Required";
      isValid = false;
    }

    return isValid;
  }

  clear() {
    urlTED.text = "";
    urlType = null;
    urlError = null;
    urlTypeError = null;
    delayError = null;
    delayTED.text = "";
  }

  Widget buildDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(
                "Type",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: DropdownButton(
                underline: Container(height: 1, color: Colors.grey),
                isExpanded: true,
                value: (urlType != null) ? urlType : null,
                onChanged: (dynamic type) {
                  urlType = type;
                  if (urlType != "Image") {
                    delayTED.text = "";
                  }
                  setState(() {});
                },
                items: urlTypesList.map((value) {
                  return DropdownMenuItem(
                    child: Column(
                      children: [
                        Text(value),
                      ],
                    ),
                    value: value,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Text(
          urlTypeError ?? "",
          style: TextStyle(color: Colors.red.shade700, fontSize: 12),
        ).paddingOnly(left: 110),
      ],
    );
  }

  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Add Content",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget buildKeyValuePair(
      {required String title,
      required TextEditingController controller,
      required TextInputType textInputType,
      String? errorText}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              keyboardType: textInputType,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: '',
                errorText: errorText,
                suffixText: (title == "Delay Time") ? "sec" : "",
                suffixIcon: (title == "URL" && urlTED.text.isNotEmpty)
                    ? GestureDetector(
                        onTap: () {
                          urlTED.text = "";
                          setState(() {});
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.black,
                        ).paddingAll(5))
                    : SizedBox(),
                errorStyle: TextStyle(color: Colors.red.shade700),
                border: UnderlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    ).paddingOnly(top: 15);
  }
}
