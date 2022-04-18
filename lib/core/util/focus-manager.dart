import 'package:flutter/cupertino.dart';

class AppFocusManager{

  static FocusNode focusNode = FocusNode();


  static removeFocus(){

    focusNode.requestFocus();

  }

}