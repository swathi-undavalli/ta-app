import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/constants.dart';

// ignore: must_be_immutable
class AppTextField extends StatefulWidget {
  int? maxLimit;
  int? minLines;
  int? maxLines;
  Widget? icon;
  Widget? suffixIcon;
  double width;
  String? hintText;
  String? suffixText;
  bool required;
  Function(String?)? validator;
  Function(String)? onChangedCallBack;
  TextEditingController? controller;
  Function? errorValidator;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  TextInputType? keyboardType;
  TextInputAction textInputAction;
  bool enableSuggestions;
  Function? finalSubmit;
  String? labelText;
  bool isStrictNumber;
  List<TextInputFormatter>? inputFormatter;

  AppTextField({
    Key? key,
    this.maxLimit,
    this.isStrictNumber = false,
    this.labelText,
    this.suffixText,
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
    this.suffixIcon,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.go,
    this.inputFormatter,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppTextFieldsState createState() => _AppTextFieldsState();
}

class _AppTextFieldsState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    widget.nextFocusNode ??= FocusNode();
    return SizedBox(
      width: widget.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: TextFormField(
          style: const TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.normal,
          ),
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.isStrictNumber ? TextInputType.number : widget.keyboardType,
          textInputAction: (widget.finalSubmit == null) ? widget.textInputAction : TextInputAction.done,
          inputFormatters: widget.isStrictNumber ? [FilteringTextInputFormatter.digitsOnly] : widget.inputFormatter,
          enableSuggestions: widget.enableSuggestions,
          decoration: InputDecoration(
            labelText: "${widget.hintText}  ${(widget.required) ? "*" : ""}",
            prefixStyle: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            suffixText: widget.suffixText,
            suffixIcon: widget.suffixIcon,
            icon: widget.icon,
            errorText: (widget.errorValidator != null) ? widget.errorValidator!() : null,
            labelStyle: const TextStyle(
              fontSize: FontSize.small,
              fontFamily: AppFonts.nunito,
            ),
          ),
          onTap: () {},
          validator: (value) {
            return widget.validator!(value);
          },
          onChanged: (value) {
            if (widget.onChangedCallBack != null) {
              widget.onChangedCallBack!(value);
            }
            if (widget.maxLimit != null && value.length == widget.maxLimit) {
              widget.nextFocusNode!.requestFocus();
            }
            setState(() {});
          },
          onFieldSubmitted: (value) {
            if (widget.finalSubmit == null) {
              widget.nextFocusNode!.requestFocus();
            } else {
              widget.finalSubmit!();
            }
          },
        ),
      ),
    );
  }
}
