import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class AppTextField extends StatefulWidget {
  int maxLimit;
  int minLines;
  int maxLines;
  Widget icon;
  double width;
  String hintText;
  bool required;
  Function(String) validator;
  Function(String) onChangedCallBack;
  TextEditingController controller;
  Function errorValidator;
  FocusNode focusNode;
  FocusNode nextFocusNode;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  bool enableSuggestions;
  Function finalSubmit;
  // Function onChanged;
  String labelText;
  bool isStrictNumber;

  AppTextField({
    this.maxLimit,
    this.isStrictNumber = false,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.icon,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.enableSuggestions = true,
    this.finalSubmit,
    this.validator,
    this.errorValidator,
    this.onChangedCallBack,
    this.width = 320,
    this.required = false,
    this.keyboardType = TextInputType.name,
    this.textInputAction = TextInputAction.go,
  });

  @override
  _AppTextFieldsState createState() => _AppTextFieldsState();
}

class _AppTextFieldsState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    if (widget.nextFocusNode == null) widget.nextFocusNode = FocusNode();
    return Container(
      width: widget.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: TextFormField(
          style: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.normal,
          ),
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.isStrictNumber
              ? TextInputType.number
              : widget.keyboardType,
          textInputAction: (widget.finalSubmit == null)
              ? widget.textInputAction
              : TextInputAction.done,
          inputFormatters: widget.isStrictNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          enableSuggestions: widget.enableSuggestions,
          decoration: InputDecoration(
            labelText: "${widget.hintText}  ${(widget.required) ? "*" : ""}",
            prefixStyle: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            icon: widget.icon,
            errorText: widget.errorValidator(),
            labelStyle: TextStyle(
              fontSize: FontSize.small,
              fontFamily: AppFonts.nunito,
            ),
          ),
          onTap: () {},
          validator: (value) {
            return widget.validator(value);
          },
          onChanged: (value) {
            if (widget.onChangedCallBack != null)
              widget.onChangedCallBack(value);
            if (widget.maxLimit != null && value.length == widget.maxLimit)
              widget.nextFocusNode.requestFocus();
            setState(() {});
          },
          onFieldSubmitted: (value) {
            if (widget.finalSubmit == null)
              widget.nextFocusNode.requestFocus();
            else
              widget.finalSubmit();
          },
        ),
      ),
    );
  }
}
