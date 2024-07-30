import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../core/constants/constants.dart';
import '../../../core/util/alignment_extensions.dart';
import '../../../core/util/spacing_widgets.dart';
import '../../../core/widgets/app_button.dart';
import '../../employees/model/employee.dart';
import '../models/marketing.dart';

class MarketingContentEntryBottomSheet extends StatefulWidget {
  final MarketingElement? marketingElement;
  final int? index;

  const MarketingContentEntryBottomSheet({
    super.key,
    this.marketingElement,
    this.index,
  });

  static Future show(
    BuildContext context, {
    MarketingElement? marketingElementModel,
    int? elementIndex,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
  List<String> urlTypesList = ['Image', 'Video', 'Lottie'];
  String? urlError;
  String? urlTypeError;
  String? delayError;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    urlTED = TextEditingController(text: widget.marketingElement?.url ?? '');
    delayTED = TextEditingController(
      text: (widget.marketingElement?.duration != null) ? widget.marketingElement?.duration.toString() : '',
    );
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
              width: Screen.width,
              height: 550,
              color: Colors.grey,
              child: const CircularProgressIndicator(
                color: Colors.black,
              ).center,
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              buildKeyValuePair(
                title: 'Name',
                controller: nameTED,
                textInputType: TextInputType.text,
              ),
              buildKeyValuePair(
                title: 'URL',
                controller: urlTED,
                errorText: urlError,
                textInputType: TextInputType.text,
              ),
              buildKeyValuePair(
                title: 'Duration',
                controller: delayTED,
                errorText: delayError,
                textInputType: const TextInputType.numberWithOptions(),
              ),
              Spacing.h25,
              buildDropDown(),
              Spacing.h50,
              buildSubmitButton(context),
            ],
          ).paddingSymmetric(horizontal: 20, vertical: 20).scrollable,
        ],
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return AppButton.flat(
      onTap: () async {
        if (isValid()) {
          showLoading = true;
          setState(() {});
          DocumentSnapshot document = await FirebaseFirestore.instance.collection('marketing').doc('marketing').get();
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

          Marketing marketing = Marketing.fromJson(data);

          MarketingElement marketingElement = MarketingElement(
            url: urlTED.text,
            type: urlType ?? '',
            duration: int.parse(delayTED.text),
            name: nameTED.text,
            createdBy: currentEmployee?.firstName,
          );

          if (widget.index != null) {
            marketing.marketingElements?[widget.index!] = marketingElement;
          } else {
            marketing.marketingElements?.add(marketingElement);
          }
          await FirebaseFirestore.instance.collection('marketing').doc('marketing').set(marketing.toJson());

          showLoading = false;
          setState(() {});
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
        setState(() {});
      },
      text: 'Submit',
      color: Colors.black,
      textColor: Colors.white,
    );
  }

  bool isValid() {
    bool isValid = true;
    urlError = null;
    urlTypeError = null;
    delayError = null;

    if (urlTED.text.isEmpty) {
      urlError = 'Required';
      isValid = false;
    }
    if (urlType == null || urlType!.isEmpty) {
      urlTypeError = 'Required';
      isValid = false;
    }
    if (delayTED.text.isEmpty) {
      delayError = 'Required';
      isValid = false;
    }

    return isValid;
  }

  clear() {
    urlTED.text = '';
    urlType = null;
    urlError = null;
    urlTypeError = null;
    delayError = null;
    delayTED.text = '';
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
                'Type',
                style: TextStyle(
                  fontFamily: AppFonts.nunito,
                  color: AppColors.text.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
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
                  setState(() {});
                },
                items: urlTypesList.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Column(
                      children: [
                        Text(
                          value,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Text(
          urlTypeError ?? '',
          style: TextStyle(color: Colors.red.shade700, fontSize: 12),
        ).paddingOnly(left: 110),
      ],
    );
  }

  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Add Content',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget buildKeyValuePair({
    required String title,
    required TextEditingController controller,
    required TextInputType textInputType,
    String? errorText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.black,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: textInputType,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: '',
              errorText: errorText,
              suffixText: (title == 'Duration') ? 'sec' : '',
              suffixIcon: (title == 'URL' && urlTED.text.isNotEmpty)
                  ? GestureDetector(
                      onTap: () {
                        urlTED.text = '';
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ).paddingAll(5),
                    )
                  : const SizedBox(),
              errorStyle: TextStyle(color: Colors.red.shade700),
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
      ],
    ).paddingOnly(top: 15);
  }
}
